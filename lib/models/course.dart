class Course {
  final int id;
  final String imageUrl;
  final String title;
  final String description;
  final int price;
  final bool isFree;
  final int order;
  final int validityWeeks;
  final bool? purchased;
  final bool? isValid;
  final bool? watched;

  Course({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.price,
    required this.isFree,
    required this.order,
    required this.validityWeeks,
    this.isValid,
    this.purchased,
    this.watched,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    var testJson = json;

    return Course(
      id: json['id'],
      imageUrl: json['image_url'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      isFree: json['is_free'] == 1,
      order: json['home_order'] ?? 0,
      validityWeeks: json['validity_weeks'],
      isValid: json['isValid'],
      purchased: json['purchased'],
      watched: json['watched'], 
    );
  }
}
