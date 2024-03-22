import 'package:arcjoga_frontend/config.dart';
import 'package:arcjoga_frontend/models/course.dart';
import 'package:arcjoga_frontend/style.dart';
import 'package:arcjoga_frontend/widgets/common/app_text_button.dart';
import 'package:arcjoga_frontend/widgets/common/network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CourseCard extends StatelessWidget {
  final Course course;

  const CourseCard({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 300,
        minWidth: 200,
      ),
      child: Card(
        color: const Color(Style.white),
        child: Container(
          width: 200,
          // height: 500,
          // padding: const EdgeInsets.symmetric(
          //   vertical: 5,
          //   horizontal: 5,
          // ),
          decoration: BoxDecoration(
            color: const Color(Style.white),
            border: Border.all(
              width: 2,
              color: const Color(Style.primaryLight),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: IntrinsicHeight(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppNetworkImage(
                    imageUrl: '${Config.backendUrl}/${course.imageUrl}',
                    width: 325,
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      course.title,
                      style: Style.titleDark,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Divider(
                      color: Color(Style.borderLight),
                      thickness: 2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      course.price == 0 ? 'Ingyenes' : '${course.price} Ft',
                      style: Style.primaryLightText,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Divider(
                      color: Color(Style.borderLight),
                      thickness: 2,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      course.description,
                      style: Style.primaryDarkTextSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: AppTextButton(
                      backgroundColor: const Color(Style.buttonDark),
                      text: 'Megnézem',
                      textStyle: Style.textWhite,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
