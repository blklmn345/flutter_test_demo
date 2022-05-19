import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_demo/firebase_options.dart';
import 'package:flutter_test_demo/i18n/strings.g.dart';

class BootManager {
  static Future<void> configureDependencies() async {
    WidgetsFlutterBinding.ensureInitialized();
    // Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // i18n
    LocaleSettings.useDeviceLocale();
  }
}
