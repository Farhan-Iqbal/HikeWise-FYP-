import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String _selectedDistrict = 'All';
  String _selectedDifficulty = 'All';
  bool _wantsScenic = false;
  bool _wantsWaterfalls = false;

  final List<String> districts = [
    'All', 'Besut', 'Dungun', 'Hulu Terengganu', 'Kemaman', 
    'Kuala Nerus', 'Kuala Terengganu', 'Marang', 'Setiu'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 24),
          const Text("Filter Terengganu Trails", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          
          const Text("District", style: TextStyle(fontWeight: FontWeight.bold)),
          DropdownButton<String>(
            isExpanded: true,
            value: _selectedDistrict,
            items: districts.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
            onChanged: (val) => setState(() => _selectedDistrict = val!),
          ),
          
          const SizedBox(height: 20),
          const Text("Difficulty", style: TextStyle(fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 8,
            children: ['All', 'Easy', 'Moderate', 'Hard'].map((diff) {
              return ChoiceChip(
                label: Text(diff),
                selected: _selectedDifficulty == diff,
                onSelected: (val) => setState(() => _selectedDifficulty = diff),
                selectedColor: const Color(0xFF2E7D32),
                labelStyle: TextStyle(color: _selectedDifficulty == diff ? Colors.white : Colors.black),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 20),
          CheckboxListTile(
            title: const Text("Scenic Views"),
            value: _wantsScenic,
            onChanged: (val) => setState(() => _wantsScenic = val!),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            title: const Text("Waterfalls"),
            value: _wantsWaterfalls,
            onChanged: (val) => setState(() => _wantsWaterfalls = val!),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
          ),
          
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Apply Filters"),
          ),
        ],
      ),
    );
  }
}