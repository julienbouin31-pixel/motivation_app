import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> initSupabase() async {
  final url = dotenv.env['SUPABASE_URL'];
  final anonKey = dotenv.env['SUPABASE_ANON_KEY'];

  if (url == null || url.isEmpty || anonKey == null || anonKey.isEmpty) {
    throw StateError(
      'SUPABASE_URL ou SUPABASE_ANON_KEY manquant dans .env',
    );
  }

  await Supabase.initialize(
    url: url,
    // ignore: deprecated_member_use
    anonKey: anonKey,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );
}

SupabaseClient get supabaseClient => Supabase.instance.client;

Future<void> ensureAnonymousSession() async {
  final auth = supabaseClient.auth;
  if (auth.currentSession != null) return;
  await auth.signInAnonymously();
}
