import 'package:flutter/foundation.dart';
import '../models/provision.dart';
import '../services/provisions_service.dart';

class ProvisionsProvider with ChangeNotifier {
  final ProvisionsService _service = ProvisionsService();
  String _selectedCategory = 'all';
  List<Provision> _provisions = [];
  List<Provision> _selectedProvisions = [];
  Map<String, String> _categories = {};
  bool _isInitialized = false;
  
  // Initial deficit in trillions
  final double projectedDeficit = 29.24;
  double _currentDeficit = 29.24;

  ProvisionsProvider() {
    _initialize();
  }

  void _initialize() {
    try {
      debugPrint('Initializing ProvisionsProvider...');
      _categories = _service.getCategoryNames();
      debugPrint('Categories loaded: ${_categories.length}');
      _provisions = _service.getAllProvisions();
      debugPrint('Provisions loaded: ${_provisions.length}');
      _isInitialized = true;
      
      // Find and auto-select provision A1 by default
      try {
        final provisionA1 = _provisions.firstWhere(
          (p) => p.id == 'A1',
        );
        debugPrint('Auto-selecting provision A1');
        addSelectedProvision(provisionA1);
      } catch (e) {
        debugPrint('Provision A1 not found for auto-selection: $e');
      }
      
      notifyListeners();
    } catch (e, stackTrace) {
      debugPrint('Error initializing ProvisionsProvider: $e');
      debugPrint('Stack trace: $stackTrace');
      _categories = {};
      _provisions = [];
      _isInitialized = true;
      notifyListeners();
    }
  }

  bool get isInitialized => _isInitialized;
  String get selectedCategory => _selectedCategory;
  double get currentDeficit => _currentDeficit;
  List<Provision> get selectedProvisions => _selectedProvisions;
  
  List<Provision> get provisions {
    if (!_isInitialized) return [];
    if (_selectedCategory == 'all') {
      debugPrint('Returning all provisions: ${_provisions.length}');
      return _provisions;
    }
    final categoryName = _categories[_selectedCategory];
    debugPrint('Filtering by category: $_selectedCategory ($categoryName)');
    return _provisions.where((p) => p.category == categoryName).toList();
  }
  
  Map<String, String> get categories => _categories;

  void selectCategory(String categoryId) {
    if (_selectedCategory != categoryId) {
      debugPrint('Selecting category: $categoryId');
      _selectedCategory = categoryId;
      notifyListeners();
    }
  }

  void addSelectedProvision(Provision provision) {
    if (!_selectedProvisions.contains(provision)) {
      _selectedProvisions.add(provision);
      
      // Update deficit based on real impact value from the provision
      // The impact is measured as percentage of payroll in the provisions_data_web.dart
      // For our simplified deficit calculation, we'll use the long-range effect
      // scaled to the deficit's units (trillions)
      
      // Extract long-range effect from the impacts data
      // Example format: "Long-range effect: 0.13% of payroll"
      double impactValue = 0.0;
      for (String impact in provision.impacts) {
        if (impact.contains('Long-range effect:')) {
          try {
            // Extract the numeric value from impact text
            String valueStr = impact.replaceAll('Long-range effect:', '').trim();
            valueStr = valueStr.replaceAll('% of payroll', '').trim();
            impactValue = double.tryParse(valueStr) ?? 0.0;
          } catch (e) {
            debugPrint('Error parsing impact value: $e');
          }
        }
      }
      
      // Scale the impact - negative values reduce deficit, positive increase it
      // For a scaled representation, multiply by 0.3 to convert percentage points to trillions
      final scaledImpact = impactValue * 0.3;
      _currentDeficit -= scaledImpact;
      
      debugPrint('Added provision: ${provision.id}, Impact: $impactValue%, Scaled: $scaledImpact trillion');
      notifyListeners();
    }
  }

  void removeSelectedProvision(Provision provision) {
    if (_selectedProvisions.remove(provision)) {
      // Extract and scale impact value to restore the deficit
      double impactValue = 0.0;
      for (String impact in provision.impacts) {
        if (impact.contains('Long-range effect:')) {
          try {
            String valueStr = impact.replaceAll('Long-range effect:', '').trim();
            valueStr = valueStr.replaceAll('% of payroll', '').trim();
            impactValue = double.tryParse(valueStr) ?? 0.0;
          } catch (e) {
            debugPrint('Error parsing impact value: $e');
          }
        }
      }
      
      // Scale the impact - we're removing, so flip the sign
      final scaledImpact = impactValue * 0.3;
      _currentDeficit += scaledImpact;
      
      debugPrint('Removed provision: ${provision.id}, Impact: $impactValue%, Scaled: $scaledImpact trillion');
      notifyListeners();
    }
  }

  void refresh() {
    debugPrint('Refreshing provisions...');
    _initialize();
  }
  
  void resetSelections() {
    debugPrint('Resetting selected provisions...');
    _selectedProvisions.clear();
    _currentDeficit = projectedDeficit;
    notifyListeners();
  }
}
