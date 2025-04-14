import '../models/provision.dart';
import '../data/provisions_data.dart';

class ProvisionsService {
  Map<String, String> getCategoryNames() {
    final categories = provisionsData['categories'] as List<dynamic>;
    return Map<String, String>.fromEntries(
      categories.map((category) => MapEntry(
            category['id'] as String,
            category['name'] as String,
          )),
    );
  }

  List<Provision> getProvisionsByCategory(String categoryId) {
    final categories = provisionsData['categories'] as List<dynamic>;
    final category = categories.firstWhere(
      (cat) => cat['id'] == categoryId,
      orElse: () => {'provisions': []},
    );
    
    return List<Map<String, dynamic>>.from(category['provisions'] as List)
        .map((json) => _createProvision(json, category['name'] as String))
        .toList();
  }

  List<Provision> getAllProvisions() {
    final categories = provisionsData['categories'] as List<dynamic>;
    List<Provision> allProvisions = [];
    
    for (var category in categories) {
      final provisions = List<Map<String, dynamic>>.from(
        category['provisions'] as List,
      ).map((json) => _createProvision(json, category['name'] as String));
      allProvisions.addAll(provisions);
    }
    
    return allProvisions;
  }

  Provision _createProvision(Map<String, dynamic> json, String categoryName) {
    return Provision(
      id: json['id'] as String,
      category: categoryName,
      title: json['title'] as String,
      description: json['description'] as String,
      impacts: List<String>.from(json['impacts'] as List),
      relatedLinks: Map<String, String>.from(json['relatedLinks'] as Map),
    );
  }
}
