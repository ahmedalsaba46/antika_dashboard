class AntiqueModel {
  final String id;
  final String userId;
  final String description;
  final String title;
  final double price;
  final String condition;
  final int categoryId;
  final DateTime createdAt;
  final int year;
  final int quantity;
  final int status;
  final String place;
  final String? imageUrl;

  const AntiqueModel({
    required this.id,
    required this.userId,
    required this.description,
    required this.title,
    required this.price,
    required this.condition,
    required this.categoryId,
    required this.createdAt,
    required this.year,
    required this.quantity,
    required this.status,
    required this.place,
    this.imageUrl,
  });

  factory AntiqueModel.fromJson(Map<String, dynamic> json) {
    return AntiqueModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      description: json['description'] as String,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      condition: json['condition'] as String,
      categoryId: json['category_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      year: json['year'] as int,
      quantity: json['quantity'] as int,
      status: json['status'] as int,
      place: json['place'] as String,
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'description': description,
      'title': title,
      'price': price,
      'condition': condition,
      'category_id': categoryId,
      'created_at': createdAt.toIso8601String(),
      'year': year,
      'quantity': quantity,
      'status': status,
      'place': place,
      'image_url': imageUrl,
    };
  }

  AntiqueModel copyWith({
    String? id,
    String? userId,
    String? description,
    String? title,
    double? price,
    String? condition,
    int? categoryId,
    DateTime? createdAt,
    int? year,
    int? quantity,
    int? status,
    String? place,
    String? imageUrl,
  }) {
    return AntiqueModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      description: description ?? this.description,
      title: title ?? this.title,
      price: price ?? this.price,
      condition: condition ?? this.condition,
      categoryId: categoryId ?? this.categoryId,
      createdAt: createdAt ?? this.createdAt,
      year: year ?? this.year,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
      place: place ?? this.place,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  bool get isActive => status == 'active';
  bool get isPending => status == 'pending';
  bool get isRejected => status == 'rejected';
}
