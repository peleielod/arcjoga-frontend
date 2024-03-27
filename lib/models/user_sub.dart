import 'package:intl/intl.dart';

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
    DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime parsedPaymentDue = format.parse(json['payment_due']);

    return UserSub(
      userId: json['user_id'],
      mainSubId: json['main_sub_id'],
      paymentDue: parsedPaymentDue,
      active: json['active'] == 1,
      canceledAt: json['canceled_at'],
    );
  }
}
