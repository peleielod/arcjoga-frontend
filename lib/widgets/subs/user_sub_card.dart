import 'package:arcjoga_frontend/models/sub.dart';
import 'package:arcjoga_frontend/models/user_sub.dart';
import 'package:flutter/material.dart';

class UserSubCard extends StatefulWidget {
  final UserSub userSub;
  final Sub sub;

  const UserSubCard({
    super.key,
    required this.userSub,
    required this.sub,
  });

  @override
  State<UserSubCard> createState() => _UserSubCardState();
}

class _UserSubCardState extends State<UserSubCard> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
