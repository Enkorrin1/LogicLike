import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/app/logic_like_app.dart';
import 'src/data/app_locale_store.dart';
import 'src/data/family_profile_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();

  runApp(
    LogicLikeApp(
      appLocaleStore: SharedPreferencesAppLocaleStore(preferences),
      familyProfileStore: SharedPreferencesFamilyProfileStore(preferences),
    ),
  );
}
