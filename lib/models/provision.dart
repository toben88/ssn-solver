class Provision {
  final String id;
  final String category;
  final String title;
  final String description;
  final List<String> impacts;
  final Map<String, String> relatedLinks;

  const Provision({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.impacts,
    required this.relatedLinks,
  });

  factory Provision.fromJson(Map<String, dynamic> json) {
    return Provision(
      id: json['id'] as String,
      category: json['category'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      impacts: List<String>.from(json['impacts'] as List),
      relatedLinks: Map<String, String>.from(json['relatedLinks'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'title': title,
      'description': description,
      'impacts': impacts,
      'relatedLinks': relatedLinks,
    };
  }
}
