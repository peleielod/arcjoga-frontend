class User {
  final int id;
  final String email;
  final String username;
  final String? avatarUrl;
  final bool hasSub;

  User({
    required this.id,
    required this.username,
    required this.hasSub,
    required this.email,
    this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['name'] ?? json['username'],
      hasSub: json['has_sub'] == 1,
      avatarUrl: json['avatar_url'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'has_sub': hasSub,
        'avatar_url': avatarUrl,
        'email': email,
      };
}
