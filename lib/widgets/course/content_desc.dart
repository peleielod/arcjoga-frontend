import 'package:arcjoga_frontend/style.dart';
import 'package:flutter/material.dart';

class ContentDesc extends StatelessWidget {
  final String description;

  const ContentDesc({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        // color: const Color(Style.white),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        description,
        style: Style.textWhiteSmall,
      ),
    );
  }
}
