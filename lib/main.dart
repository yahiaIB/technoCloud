import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app/app.dart';
import 'utils/preference_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  PreferenceUtils.getInstance();
  await PreferenceUtils.initPreferences();
  runApp(const MyApp());
}