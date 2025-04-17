import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import '../data/csv_import.dart';
import '../data/provisions_data_web.dart';
import '../providers/selected_provisions_provider.dart';
import '../widgets/provision_card.dart';

class ActuarialProvisionsScreen extends StatefulWidget {
  const ActuarialProvisionsScreen({Key? key}) : super(key: key);

  @override
  _ActuarialProvisionsScreenState createState() => _ActuarialProvisionsScreenState();
}

class _ActuarialProvisionsScreenState extends State<ActuarialProvisionsScreen> {
  List<ProvisionModel> provisions = [];
  Map<String, List<ProvisionModel>> categorizedProvisions = {};
  bool isLoading = true;
  String selectedCategory = 'all';
  final double _mainAxisSpacing = 0; // Ultra-compact spacing for mobile
  final double _childAspectRatio = 2.0; // Increased aspect ratio for mobile

  @override
  void initState() {
    super.initState();
    _loadProvisions();
  }

  Future<void> _loadProvisions() async {
    try {
      // Using hardcoded data for all platforms for better performance
      // This is much faster than reading from CSV and parsing
      final fileProvisions = WebProvisionData.getProvisionsData();
      
      setState(() {
        provisions = fileProvisions;
        categorizedProvisions = ProvisionData.groupByCategory(provisions);
        isLoading = false;
      });
      
      print('Loaded ${fileProvisions.length} provisions from hardcoded data');
    } catch (e) {
      print('Error loading provisions: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  List<ProvisionModel> getFilteredProvisions() {
    if (selectedCategory == 'all') {
      return provisions;
    } else {
      return categorizedProvisions[selectedCategory] ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;
    final filteredProvisions = getFilteredProvisions();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Social Security Provisions'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Category Selector
                SizedBox(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ChoiceChip(
                          label: const Text('All'),
                          selected: selectedCategory == 'all',
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                selectedCategory = 'all';
                              });
                            }
                          },
                        ),
                      ),
                      ...categorizedProvisions.keys.map((category) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ChoiceChip(
                            label: Text(getCategoryDisplayName(category)),
                            selected: selectedCategory == category,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  selectedCategory = category;
                                });
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
                
                // Provisions Grid
                Expanded(
                  child: filteredProvisions.isEmpty
                      ? Center(
                          child: Text(
                            'No provisions found for this category',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        )
                      : GridView.builder(
                            padding: const EdgeInsets.all(8),
                            // Remove scrollbars in web to avoid controller issues
                            primary: true, // Use PrimaryScrollController instead of a custom one
                            physics: const AlwaysScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: isMobile ? 1 : 2,
                              mainAxisSpacing: _mainAxisSpacing,
                              crossAxisSpacing: 8,
                              childAspectRatio: _childAspectRatio,
                            ),
                            itemCount: filteredProvisions.length,
                            itemBuilder: (context, index) {
                              final provision = filteredProvisions[index];
                              return ProvisionCard(provision: provision);
                            },
                          ),
                ),
              ],
            ),
    );
  }

  String getCategoryDisplayName(String categoryId) {
    final Map<String, String> displayNames = {
      'cola': 'COLA',
      'benefit_level': 'Benefits',
      'retirement_age': 'Retirement',
      'family_benefits': 'Family',
      'payroll_tax': 'Payroll Tax',
      'coverage': 'Coverage',
      'trust_fund': 'Trust Fund',
      'taxation': 'Taxation',
    };
    
    return displayNames[categoryId] ?? categoryId;
  }
}

class ProvisionCard extends StatelessWidget {
  final ProvisionModel provision;

  const ProvisionCard({Key? key, required this.provision}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedProvisionsProvider = Provider.of<SelectedProvisionsProvider>(context);
    final isSelected = selectedProvisionsProvider.isSelected(provision.provisionId);
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;
    
    // Use smaller font size for ID on mobile
    final idFontSize = isMobile ? 9.0 : 12.0;
    
    // Use minimized padding on mobile for higher density
    final contentPadding = isMobile 
      ? const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0)
      : const EdgeInsets.all(12.0);
      
    // Visual density for mobile
    final visualDensity = isMobile 
      ? const VisualDensity(horizontal: -4, vertical: -4)
      : VisualDensity.standard;

    return Card(
      elevation: isSelected ? 4 : 1,
      color: isSelected ? Colors.blue.shade50 : null,
      child: InkWell(
        onTap: () {
          if (isSelected) {
            selectedProvisionsProvider.removeProvision(provision.provisionId);
          } else {
            selectedProvisionsProvider.addProvision(provision);
          }
        },
        child: Padding(
          padding: contentPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade700,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      provision.provisionId,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: idFontSize,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      provision.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Text(
                  provision.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Long range effect chip
                  Chip(
                    visualDensity: visualDensity,
                    label: Text(
                      '${provision.longRangeEffectRaw > 0 ? '+' : ''}${provision.longRangeEffectRaw}%',
                      style: TextStyle(
                        color: provision.longRangeEffectRaw >= 0 ? Colors.green.shade700 : Colors.red.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: isMobile ? 10 : 12,
                      ),
                    ),
                    backgroundColor: provision.longRangeEffectRaw >= 0 
                        ? Colors.green.shade50 
                        : Colors.red.shade50,
                  ),
                  
                  // 75th year effect chip
                  Chip(
                    visualDensity: visualDensity,
                    label: Text(
                      '${provision.year75EffectRaw > 0 ? '+' : ''}${provision.year75EffectRaw}%',
                      style: TextStyle(
                        color: provision.year75EffectRaw >= 0 ? Colors.green.shade700 : Colors.red.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: isMobile ? 10 : 12,
                      ),
                    ),
                    backgroundColor: provision.year75EffectRaw >= 0 
                        ? Colors.green.shade50 
                        : Colors.red.shade50,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
