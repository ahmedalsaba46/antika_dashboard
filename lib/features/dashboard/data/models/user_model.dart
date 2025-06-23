class UserModel {
  final String id;
  final String userName;
  final String email;
  final String? password;
  final String? phoneNumber;
  final String? city;
  final int status;
  final int appRole;
  final DateTime? createdAt;

  const UserModel({
    required this.id,
    required this.userName,
    required this.email,
    this.password,
    this.phoneNumber,
    this.city,
    required this.status,
    required this.appRole,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      userName: json['user_name'],
      email: json['email'],
      password: json['password'],
      phoneNumber: json['phone_number'],
      city: json['city'],
      status: json['status'],
      appRole: json['app_role'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    final map = {
      'user_name': userName,
      'email': email,
      'password': password,
      'phone_number': phoneNumber,
      'city': city,
      'status': status,
      'app_role': appRole,
    };
    if (id.isNotEmpty) {
      map['id'] = id;
    }
    return map;
  }

  // Add this method to UserModel
  UserModel copyWith({
    String? id,
    String? userName,
    String? email,
    String? password,
    String? phoneNumber,
    String? city,
    int? status,
    int? appRole,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      password: password ?? this.password,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      city: city ?? this.city,
      status: status ?? this.status,
      appRole: appRole ?? this.appRole,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
