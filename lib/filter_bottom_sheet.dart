import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  final List<String> availableFeatures;
  final Map<String, dynamic>? initialFilters;

  const FilterBottomSheet({
    super.key,
    required this.availableFeatures,
    this.initialFilters,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String _selectedDistrict;
  late String _selectedDifficulty;
  List<String> _selectedFeatures = [];

  final List<String> districts = [
    'All', 'Besut', 'Dungun', 'Hulu Terengganu', 'Kemaman',
    'Kuala Nerus', 'Kuala Terengganu', 'Marang', 'Setiu'
  ];

  @override
  void initState() {
    super.initState();
    _selectedDistrict = widget.initialFilters?['district'] ?? 'All';
    _selectedDifficulty = widget.initialFilters?['difficulty'] ?? 'All';
    _selectedFeatures = List<String>.from(widget.initialFilters?['features'] ?? []);
  }

  @override
  Widget build(BuildContext context) {
    // We use a fraction of the screen height to prevent the sheet from jumping
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Header with Clear All button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Filter Trails",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedDistrict = 'All';
                    _selectedDifficulty = 'All';
                    _selectedFeatures.clear();
                  });
                },
                child: const Text("Clear All", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
          const Divider(),

          // Scrollable Section
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text("District", style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedDistrict,
                    items: districts.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                    onChanged: (val) => setState(() => _selectedDistrict = val!),
                  ),
                  
                  const SizedBox(height: 24),
                  const Text("Difficulty", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['All', 'Easy', 'Moderate', 'Hard'].map((diff) {
                      return ChoiceChip(
                        label: Text(diff),
                        selected: _selectedDifficulty == diff,
                        onSelected: (val) => setState(() => _selectedDifficulty = diff),
                        selectedColor: const Color(0xFF2E7D32),
                        labelStyle: TextStyle(
                          color: _selectedDifficulty == diff ? Colors.white : Colors.black,
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 24),
                  const Text("Trail Features", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: widget.availableFeatures.map((feature) {
                      final isSelected = _selectedFeatures.contains(feature);
                      return FilterChip(
                        label: Text(feature),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              _selectedFeatures.add(feature);
                            } else {
                              _selectedFeatures.remove(feature);
                            }
                          });
                        },
                        selectedColor: Colors.green[100],
                        checkmarkColor: Colors.green[800],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          
          // Fixed Apply Button at bottom
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, {
                'district': _selectedDistrict,
                'difficulty': _selectedDifficulty,
                'features': _selectedFeatures,
              });
            },
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