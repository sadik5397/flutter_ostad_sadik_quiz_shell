class QuizCategory {
  int id;
  String name;
  String description;

  QuizCategory({required this.id, required this.name, required this.description});

  factory QuizCategory.fromJson(Map<String, dynamic> json) {
    return QuizCategory(id: json['id'] ?? 0, name: json['name'] ?? '', description: json['description'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'description': description};
  }
}
