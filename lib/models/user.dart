class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String website;
  final String companyName;

  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.website,
    required this.companyName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      username: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      website: json['website'] as String? ?? '',
      companyName: (json['company'] as Map<String, dynamic>?)?['name'] as String? ?? '',
    );
  }

  String get initial => name.isEmpty ? '?' : name[0].toUpperCase();
}
