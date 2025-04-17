import 'package:flutter/foundation.dart';
import '../data/csv_import.dart';

class SelectedProvisionsProvider with ChangeNotifier {
  final Map<String, ProvisionModel> _selectedProvisions = {};
  
  Map<String, ProvisionModel> get selectedProvisions => _selectedProvisions;
  
  List<ProvisionModel> get selectedProvisionsList => _selectedProvisions.values.toList();
  
  int get count => _selectedProvisions.length;
  
  bool isSelected(String provisionId) {
    return _selectedProvisions.containsKey(provisionId);
  }
  
  void addProvision(ProvisionModel provision) {
    _selectedProvisions[provision.provisionId] = provision;
    notifyListeners();
  }
  
  void removeProvision(String provisionId) {
    _selectedProvisions.remove(provisionId);
    notifyListeners();
  }
  
  void clearAll() {
    _selectedProvisions.clear();
    notifyListeners();
  }
  
  // Calculate total effect on actuarial balance
  double get totalLongRangeEffect {
    double total = 0.0;
    for (var provision in _selectedProvisions.values) {
      total += provision.longRangeEffectRaw;
    }
    return total;
  }
  
  // Calculate total effect on 75th year balance
  double get total75YearEffect {
    double total = 0.0;
    for (var provision in _selectedProvisions.values) {
      total += provision.year75EffectRaw;
    }
    return total;
  }
  
  // Calculate percentage of long-range shortfall eliminated
  int get shortfallPercentageEliminated {
    // Total shortfall is 3.50% of payroll (from the 2024 Trustees Report)
    const totalShortfall = 3.50;
    return ((totalLongRangeEffect / totalShortfall) * 100).round();
  }
  
  // Calculate percentage of 75th year shortfall eliminated
  int get shortfall75YearPercentageEliminated {
    // Total 75th year shortfall is 4.64% of payroll (from the 2024 Trustees Report)
    const totalShortfall75Year = 4.64;
    return ((total75YearEffect / totalShortfall75Year) * 100).round();
  }
}
