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
      // Update deficit based on provision's impact
      // For demonstration, let's assume each provision reduces deficit by 1 trillion
      // In a real app, you would use actual impact values from the provision
      _currentDeficit -= 1.0;
      notifyListeners();
    }
  }

  void removeSelectedProvision(Provision provision) {
    if (_selectedProvisions.remove(provision)) {
      // Update deficit based on provision's impact
      // For demonstration, let's add back 1 trillion when a provision is removed
      // In a real app, you would use actual impact values from the provision
      _currentDeficit += 1.0;
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
