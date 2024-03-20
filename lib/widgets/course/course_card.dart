import 'package:arcjoga_frontend/models/course.dart';
import 'package:arcjoga_frontend/style.dart';
import 'package:arcjoga_frontend/widgets/common/app_text_button.dart';
import 'package:arcjoga_frontend/widgets/common/network_image.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(Style.white),
      child: Container(
        width: 150,
        // padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(Style.white),
          border: Border.all(
            width: 2,
            color: const Color(Style.primaryDark),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppNetworkImage(
                imageUrl: course.imageUrl,
                width: 106,
              ),
              const SizedBox(height: 20),
              Text(
                course.title.toUpperCase(),
                style: Style.primaryDarkTextSmall,
                textAlign: TextAlign.center,
              ),
              const Divider(
                color: Color(Style.borderLight),
                thickness: 2,
              ),
              Text(
                course.price == 0 ? 'Ingyenes' : '${course.price} Ft',
                style: Style.primaryDarkText,
              ),
              const Divider(
                color: Color(Style.borderLight),
                thickness: 2,
              ),
              Text(
                course.description,
                style: Style.primaryDarkText,
              ),
              AppTextButton(
                backgroundColor: const Color(Style.buttonDark),
                text: 'Megnézem',
                textStyle: Style.primaryDarkText,
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
