class User {
  final int id;
  final String email;
  final String username;
  final String? avatarUrl;
  int freeFortuneCount;
  User({
    required this.id,
    required this.username,
    required this.freeFortuneCount,
    required this.email,
    this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['name'] ?? json['username'],
      freeFortuneCount: json['free_fortune_count'],
      avatarUrl: json['avatar_url'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'free_fortune_count': freeFortuneCount,
        'avatar_url': avatarUrl,
        'email': email,
      };
}
