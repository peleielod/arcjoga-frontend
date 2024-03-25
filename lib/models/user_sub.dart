class UserSub {
  final int userId;
  final int mainSubId;
  final DateTime paymentDue;
  final bool active;
  final DateTime? canceledAt;

  UserSub({
    required this.userId,
    required this.mainSubId,
    required this.paymentDue,
    required this.active,
    this.canceledAt,
  });

  factory UserSub.fromJson(Map<String, dynamic> json) {
    var testJson = json;

    return UserSub(
      userId: json['user_id'],
      mainSubId: json['main_sub_id'],
      paymentDue: json['payment_due'],
      active: json['active'],
      canceledAt: json['canceled_at'],
    );
  }
}
