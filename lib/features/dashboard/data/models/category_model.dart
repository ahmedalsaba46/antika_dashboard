class CategoryModel {
  final int id;
  final String name;

  const CategoryModel({required this.id, required this.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  CategoryModel copyWith({int? id, String? name}) {
    return CategoryModel(id: id ?? this.id, name: name ?? this.name);
  }
}
