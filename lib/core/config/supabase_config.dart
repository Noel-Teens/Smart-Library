import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase configuration loaded from .env file.
abstract final class SupabaseConfig {
  static String get url => dotenv.env['SUPABASE_URL']!;
  static String get anonKey => dotenv.env['SUPABASE_ANON_KEY']!;
  static String get googleWebClientId =>
      dotenv.env['GOOGLE_WEB_CLIENT_ID'] ?? '';

  /// Initializes the Supabase client. Call from `main()`.
  static Future<void> init() async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );
  }

  /// Convenience accessor for the Supabase client singleton.
  static SupabaseClient get client => Supabase.instance.client;
}
