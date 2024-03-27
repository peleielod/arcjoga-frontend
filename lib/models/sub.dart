import 'package:arcjoga_frontend/config.dart';

class Sub {
  final int id;
  final String title;
  final String description;
  final int price;
  final String imageUrl;

  Sub({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  factory Sub.fromJson(Map<String, dynamic> json) {
    var testJson = json;

    return Sub(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      imageUrl: '${Config.backendUrl}${json['image_url']}',
    );
  }
}
