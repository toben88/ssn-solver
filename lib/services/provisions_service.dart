import '../models/provision.dart';
import '../data/provisions_data_web.dart';
import '../data/csv_import.dart'; // Added for ProvisionModel class

class ProvisionsService {
  // Get all the provisions data from WebProvisionData
  final List<ProvisionModel> _webProvisions = WebProvisionData.getProvisionsData();
  
  // Get unique category IDs and names
  Map<String, String> getCategoryNames() {
    Map<String, String> categories = {};
    
    // Extract unique categories from provisions
    for (var provision in _webProvisions) {
      categories[provision.categoryId] = provision.categoryName;
    }
    
    return categories;
  }

  // Get provisions by category ID
  List<Provision> getProvisionsByCategory(String categoryId) {
    return _webProvisions
        .where((p) => p.categoryId == categoryId)
        .map(_convertProvisionModel)
        .toList();
  }

  // Get all provisions
  List<Provision> getAllProvisions() {
    return _webProvisions.map(_convertProvisionModel).toList();
  }

  // Convert ProvisionModel to Provision
  Provision _convertProvisionModel(ProvisionModel model) {
    // Extract graph and table links
    Map<String, String> relatedLinks = {};
    if (model.graphLink.isNotEmpty) {
      relatedLinks['Graph'] = model.graphLink;
    }
    if (model.tableLink.isNotEmpty) {
      relatedLinks['Table'] = model.tableLink;
    }
    
    // Split the impacts string into a list
    List<String> impactsList = model.impacts.split(';').map((s) => s.trim()).toList();
    
    return Provision(
      id: model.provisionId,
      category: model.categoryName,
      title: model.title,
      description: model.description,
      impacts: impactsList,
      relatedLinks: relatedLinks,
    );
  }
}
