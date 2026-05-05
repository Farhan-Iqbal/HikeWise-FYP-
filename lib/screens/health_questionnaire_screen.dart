import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';
import '../services/database_service.dart';

class HealthQuestionnaireScreen extends StatefulWidget {
  @override
  _HealthQuestionnaireScreenState createState() => _HealthQuestionnaireScreenState();
}

class _HealthQuestionnaireScreenState extends State<HealthQuestionnaireScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dbService = DatabaseService();
  
  String _fullName = '';
  double _fitnessLevel = 1.0;
  bool _hasAsthma = false;
  bool _hasKneeInjury = false;
  bool _hasHeartCondition = false;
  String _preferredDifficulty = 'Easy';
  bool _isSaving = false;

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isSaving = true);

    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;
      
      final profile = UserProfile(
        id: userId,
        fullName: _fullName,
        fitnessLevel: _fitnessLevel.toInt(),
        hasAsthma: _hasAsthma,
        hasKneeInjury: _hasKneeInjury,
        hasHeartCondition: _hasHeartCondition,
        preferredDifficulty: _preferredDifficulty,
      );

      await _dbService.saveUserProfile(profile);
      
      // Navigate to Home after saving
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving profile: $e')),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Health & Fitness Profile')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tell us about yourself to get better trail recommendations.', 
                style: TextStyle(fontSize: 16, color: Colors.grey[700])),
              SizedBox(height: 25),
              
              TextFormField(
                decoration: InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
                validator: (val) => val!.isEmpty ? 'Please enter your name' : null,
                onSaved: (val) => _fullName = val!,
              ),
              SizedBox(height: 25),

              Text('Fitness Level: ${_fitnessLevel.toInt()}'),
              Slider(
                value: _fitnessLevel,
                min: 1, max: 4, divisions: 3,
                label: 'Level ${_fitnessLevel.toInt()}',
                onChanged: (val) => setState(() => _fitnessLevel = val),
              ),
              
              Divider(height: 40),
              Text('Health Conditions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              
              SwitchListTile(
                title: Text('Do you have Asthma?'),
                value: _hasAsthma,
                onChanged: (val) => setState(() => _hasAsthma = val),
              ),
              SwitchListTile(
                title: Text('Any Knee Injuries?'),
                value: _hasKneeInjury,
                onChanged: (val) => setState(() => _hasKneeInjury = val),
              ),
              SwitchListTile(
                title: Text('Any Heart Conditions?'),
                value: _hasHeartCondition,
                onChanged: (val) => setState(() => _hasHeartCondition = val),
              ),
              
              SizedBox(height: 30),
              _isSaving 
                ? Center(child: CircularProgressIndicator())
                : SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _saveProfile,
                      child: Text('Complete Setup'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}