class Sub {
  final String title;
  final String description;
  final int price;

  Sub({
    required this.title,
    required this.description,
    required this.price,
  });

  factory Sub.fromJson(Map<String, dynamic> json) {
    var testJson = json;

    return Sub(
      title: json['title'],
      description: json['description'],
      price: json['price'],
    );
  }
}
