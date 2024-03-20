class Course {
  final int id;
  final String imageUrl;
  final String title;
  final String description;
  final int price;
  final bool isFree;
  final int order;
  final int validityWeeks;

  Course({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    required this.isFree,
    required this.order,
    required this.validityWeeks,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      imageUrl: json['image_url'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      isFree: json['is_free'],
      order: json['order'],
      validityWeeks: json['validity_weeks'],
    );
  }
}
