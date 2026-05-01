import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/trail_model.dart';

class DatabaseService {
  final _supabase = Supabase.instance.client;

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