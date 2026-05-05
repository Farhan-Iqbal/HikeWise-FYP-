import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/trail_model.dart';
import '../models/profile_model.dart';

class DatabaseService {
  final _supabase = Supabase.instance.client;

  // 1. Fetch User Profile
  Future<UserProfile?> getUserProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();
      
      return UserProfile.fromJson(response);
    } catch (e) {
      print('Error fetching profile: $e');
      return null;
    }
  }

  // 2. Save or Update User Profile
  Future<void> saveUserProfile(UserProfile profile) async {
    try {
      await _supabase.from('profiles').upsert(profile.toJson());
    } catch (e) {
      throw Exception('Failed to save profile: $e');
    }
  }

  // 3. Check if Profile Exists (Useful for redirection logic)
  Future<bool> hasCompletedProfile() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return false;

    final response = await _supabase
        .from('profiles')
        .select('id')
        .eq('id', user.id)
        .maybeSingle();
        
    return response != null;
  }

  Future<List<Trail>> getAllTrails() async {
    try {
      final data = await _supabase
          .from('hiking_trails') 
          .select();

      // This converts the raw list from Supabase into our Trail objects
      return (data as List).map((json) => Trail.fromJson(json)).toList();
    } catch (e) {
      print("Error fetching trails: $e");
      return [];
    }
  }
}