import 'package:arcjoga_frontend/models/user_course.dart';
import 'package:arcjoga_frontend/style.dart';
import 'package:arcjoga_frontend/widgets/common/app_text_button.dart';
import 'package:flutter/material.dart';

class UserCourseCard extends StatefulWidget {
  final UserCourse course;
  final bool active;

  const UserCourseCard({
    super.key,
    required this.course,
    required this.active,
  });

  @override
  State<UserCourseCard> createState() => _UserCourseCardState();
}

class _UserCourseCardState extends State<UserCourseCard> {
  @override
  Widget build(BuildContext context) {
    var cardWidth = MediaQuery.of(context).size.width - 20;
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 200,
          minWidth: cardWidth,
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(
                        widget.course.title,
                        style: Style.titleDark,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        'Érvényesség: ',
                        style: Style.textDarkBlue,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        widget.course.formattedValidity,
                        style: Style.textDarkBlue,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: widget.active
                          ? AppTextButton(
                              backgroundColor: const Color(Style.buttonDark),
                              width: cardWidth - 100,
                              text: 'ELŐFIZETÉS HOSSZABÍTÁSA',
                              textStyle: Style.textWhite,
                              onPressed: () {},
                            )
                          : AppTextButton(
                              backgroundColor: const Color(Style.buttonDark),
                              width: cardWidth - 100,
                              text: 'ÚJRA ELŐFIZETEK',
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
      ),
    );
  }
}
