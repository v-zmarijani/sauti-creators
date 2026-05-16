import 'package:supabase_flutter/supabase_flutter.dart';

// Replace these with your actual values from:
// Supabase Dashboard → Project Settings → API
const supabaseUrl = 'YOUR_SUPABASE_URL';
const supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

SupabaseClient get supabase => Supabase.instance.client;
