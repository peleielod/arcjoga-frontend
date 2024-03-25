import 'package:intl/intl.dart';

class UserCourse {
  final int id;
  final String imageUrl;
  final String title;
  final String description;
  final int price;
  final bool isFree;
  final int order;
  final int validityWeeks;
  final DateTime validity;
  final String formattedValidity;

  UserCourse({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    required this.isFree,
    required this.order,
    required this.validityWeeks,
    required this.validity,
    required this.formattedValidity,
  });

  factory UserCourse.fromJson(Map<String, dynamic> json) {
    DateFormat format = DateFormat("yyyy. MM. dd.");
    DateTime parsedValidity = format.parse(json['formatted_validity']);

    return UserCourse(
      id: json['id'],
      imageUrl: json['image_url'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      isFree: json['is_free'] == 1,
      order: json['home_order'] ?? 0,
      validityWeeks: json['validity_weeks'],
      validity: parsedValidity,
      formattedValidity: json['formatted_validity'],
    );
  }
}
