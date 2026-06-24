import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/app/logicx_app.dart';
import 'src/data/family_profile_store.dart';
import 'src/data/locale_store.dart';
import 'src/notifications/app_notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();
  final notificationService = AppNotificationService();

  runApp(
    LogicXApp(
      familyProfileStore: SharedPreferencesFamilyProfileStore(preferences),
      localeStore: SharedPreferencesLocaleStore(preferences),
      reminderScheduler: notificationService,
    ),
  );
}
