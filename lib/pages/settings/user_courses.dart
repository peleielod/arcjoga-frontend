import 'package:arcjoga_frontend/layouts/main_layout.dart';
import 'package:arcjoga_frontend/models/user.dart';
import 'package:arcjoga_frontend/models/user_course.dart';
import 'package:arcjoga_frontend/providers/user_provider.dart';
import 'package:arcjoga_frontend/style.dart';
import 'package:arcjoga_frontend/widgets/appbars/main_appbar.dart';
import 'package:arcjoga_frontend/widgets/course/user_course_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class UserCourses extends StatefulWidget {
  const UserCourses({super.key});

  static const routeName = '/userCourses';

  @override
  State<UserCourses> createState() => _UserCoursesState();
}

class _UserCoursesState extends State<UserCourses> {
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);

    User? user = userProvider.user;
    List<UserCourse>? userCourses = userProvider.userCourses;

    var today = DateTime.now();
    var todayDate = DateTime(today.year, today.month, today.day);

    List<UserCourse>? activeCourses = userCourses?.where((course) {
      return course.validity.isAfter(todayDate) ||
          course.validity.isAtSameMomentAs(todayDate);
    }).toList();

    List<UserCourse>? inactiveCourses = userCourses?.where((course) {
      return course.validity.isBefore(todayDate);
    }).toList();

    return MainLayout(
      appBar: const MainAppBar(
        title: 'ELŐFIZETÉSEK',
        showBackBtn: true,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 20,
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              SvgPicture.asset('assets/icons/elofizetesek.svg'),
              const SizedBox(height: 30),
              if (user != null &&
                  userCourses != null &&
                  userCourses.isNotEmpty) ...[
                const Text(
                  'Megvásárolt csomagjaim',
                  style: Style.titleDarkLarge,
                ),
                const SizedBox(height: 10),
                if (activeCourses != null && activeCourses.isNotEmpty)
                  ...activeCourses.map(
                    (course) => UserCourseCard(
                      course: course,
                      active: true,
                    ),
                  ),
                const Text(
                  'Már nem aktív csomagjaim',
                  style: Style.titleDarkLarge,
                ),
                const SizedBox(height: 10),
                if (inactiveCourses != null && inactiveCourses.isNotEmpty)
                  ...inactiveCourses.map(
                    (course) => UserCourseCard(
                      course: course,
                      active: false,
                    ),
                  )
              ] else ...[
                const Text(
                  'Még nem vásároltál csomagot!',
                  style: Style.textDarkBlueBold,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
