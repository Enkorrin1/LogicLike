import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../domain/family_profile.dart';
import '../l10n/generated/app_localizations.dart';

abstract interface class ReminderScheduler {
  Future<void> scheduleForProfile(FamilyProfile profile);

  Future<void> cancelAllReminders();
}

class AppNotificationService implements ReminderScheduler {
  AppNotificationService({
    FlutterLocalNotificationsPlugin? plugin,
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const _channelId = 'logicloka_reminders';
  static const _channelName = 'Logic Loka reminders';
  static const _channelDescription =
      'Daily mission and calm practice reminders';
  static const _notificationIcon = 'ic_stat_logicloka';
  static const _dailyMissionReminderId = 3101;
  static const _eveningMissionReminderId = 3102;

  final FlutterLocalNotificationsPlugin _plugin;

  bool _initialized = false;
  bool _permissionRequested = false;
  bool _timeZoneConfigured = false;

  Future<void> initialize({bool requestPermission = true}) async {
    if (!_initialized) {
      await _configureTimeZone();

      const settings = InitializationSettings(
        android: AndroidInitializationSettings(_notificationIcon),
        iOS: DarwinInitializationSettings(),
        macOS: DarwinInitializationSettings(),
      );

      await _plugin.initialize(settings: settings);

      final androidPlugin = _androidPlugin;
      await androidPlugin?.createNotificationChannel(
        const AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: _channelDescription,
          importance: Importance.high,
        ),
      );

      _initialized = true;
    }

    if (requestPermission) {
      await _requestNotificationPermission();
    }
  }

  @override
  Future<void> scheduleForProfile(FamilyProfile profile) async {
    if (!profile.remindersEnabled) {
      await cancelAllReminders();
      return;
    }

    await initialize();
    await _cancelReminderIds();

    final l10n = lookupAppLocalizations(profile.language.locale);

    await _scheduleDailyMissionReminder(profile, l10n);

    if (!profile.completedOn(DateTime.now())) {
      await _scheduleEveningReminderIfRelevant(profile, l10n);
    }
  }

  @override
  Future<void> cancelAllReminders() async {
    await initialize(requestPermission: false);
    await _cancelReminderIds();
  }

  Future<void> _scheduleDailyMissionReminder(
    FamilyProfile profile,
    AppLocalizations l10n,
  ) async {
    await _plugin.zonedSchedule(
      id: _dailyMissionReminderId,
      title: l10n.notificationDailyTitle,
      body: l10n.notificationDailyBody(profile.childName),
      scheduledDate: _nextTime(hour: 18, minute: 30),
      notificationDetails: _notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'daily_mission',
    );
  }

  Future<void> _scheduleEveningReminderIfRelevant(
    FamilyProfile profile,
    AppLocalizations l10n,
  ) async {
    final scheduledDate = _todayAt(hour: 20, minute: 15);
    if (!scheduledDate.isAfter(tz.TZDateTime.now(tz.local))) {
      return;
    }

    await _plugin.zonedSchedule(
      id: _eveningMissionReminderId,
      title: l10n.notificationEveningTitle,
      body: l10n.notificationEveningBody(profile.childName),
      scheduledDate: scheduledDate,
      notificationDetails: _notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: 'evening_mission',
    );
  }

  Future<void> _cancelReminderIds() async {
    await _plugin.cancel(id: _dailyMissionReminderId);
    await _plugin.cancel(id: _eveningMissionReminderId);
  }

  Future<void> _requestNotificationPermission() async {
    if (_permissionRequested) {
      return;
    }

    await _androidPlugin?.requestNotificationsPermission();
    _permissionRequested = true;
  }

  Future<void> _configureTimeZone() async {
    if (_timeZoneConfigured) {
      return;
    }

    tz.initializeTimeZones();

    try {
      final timeZone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZone.identifier));
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'notifications',
          context: ErrorDescription('configuring local notification timezone'),
        ),
      );
      tz.setLocalLocation(tz.UTC);
    }

    _timeZoneConfigured = true;
  }

  NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        icon: _notificationIcon,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
      macOS: DarwinNotificationDetails(),
    );
  }

  AndroidFlutterLocalNotificationsPlugin? get _androidPlugin {
    return _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
  }

  tz.TZDateTime _nextTime({required int hour, required int minute}) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (!scheduledDate.isAfter(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  tz.TZDateTime _todayAt({required int hour, required int minute}) {
    final now = tz.TZDateTime.now(tz.local);
    return tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
  }
}
