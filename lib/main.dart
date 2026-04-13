import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management_app/app.dart';
import 'package:library_management_app/core/config/supabase_config.dart';
import 'package:library_management_app/core/services/fcm_service.dart';

/// Application entry point.
///
/// Initializes Supabase, Firebase, and FCM, then launches the app
/// inside a Riverpod [ProviderScope].
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Initialize Supabase
  await SupabaseConfig.init();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize FCM (non-blocking — token is stored after sign-in anyway)
  FcmService.instance.init().catchError((_) {});

  runApp(
    const ProviderScope(
      child: SmartLibraryApp(),
    ),
  );
}
