import 'package:arcjoga_frontend/config.dart';
import 'package:arcjoga_frontend/helpers.dart';
import 'package:arcjoga_frontend/models/course.dart';
import 'package:arcjoga_frontend/models/course_content.dart';
import 'package:arcjoga_frontend/models/course_with_content.dart';
import 'package:arcjoga_frontend/pages/course_watch.dart';
import 'package:arcjoga_frontend/style.dart';
import 'package:arcjoga_frontend/widgets/common/app_text_button.dart';
import 'package:arcjoga_frontend/widgets/common/network_image.dart';
import 'package:arcjoga_frontend/widgets/purchase/purchase_dialog.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

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
                  // AppNetworkImage(
                  //   imageUrl: '${Config.backendUrl}/${course.imageUrl}',
                  //   width: 325,
                  // ),
                  const SizedBox(height: 15),
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
                    child: course.price == 0 ||
                            (course.purchased != null && course.purchased!)
                        ? AppTextButton(
                            backgroundColor: const Color(Style.buttonDark),
                            text: 'Megnézem',
                            textStyle: Style.textWhite,
                            onPressed: () => _handleOpenCourse(context),
                          )
                        : AppTextButton(
                            backgroundColor: const Color(Style.buttonDark),
                            text: 'Ezt választom',
                            textStyle: Style.textWhite,
                            onPressed: () => _handlePurchaseCourse(context),
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

  void _handleOpenCourse(BuildContext context) async {
    try {
      var data = {
        'courseId': course.id,
      };

      CustomResponse response = await Helpers.sendRequest(
        context,
        'openCourse',
        method: 'post',
        body: data,
        requireToken: false,
      );

      if (response.statusCode == 200) {
        CourseWithContent courseWithContent =
            CourseWithContent.fromJson(response.data);
        CourseContent activeContent =
            CourseContent.fromJson(response.data['activeContent']);

        Navigator.pushNamed(
          context,
          CourseWatch.routeName,
          arguments: CourseWatchArguments(
            courseWithContent: courseWithContent,
            activeContent: activeContent,
          ),
        );
      }
    } catch (e, stackTrace) {
      if (Config.isLiveMode) {
        await Sentry.captureException(
          e,
          stackTrace: stackTrace,
        );
      }
      // Navigator.pop(context);
      print("SEND ERROR: $e");
    }
  }

  void _handlePurchaseCourse(BuildContext context) async {
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) => PurchaseDialog(
        title: course.title,
        price: course.price,
        itemId: course.id,
        validity: DateTime.now().add(
          Duration(days: 7 * course.validityWeeks),
        ),
      ),
    );
  }
}
