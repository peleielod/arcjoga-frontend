import 'package:arcjoga_frontend/layouts/main_layout.dart';
import 'package:arcjoga_frontend/models/course.dart';
import 'package:arcjoga_frontend/models/user.dart';
import 'package:arcjoga_frontend/providers/course_provider.dart';
import 'package:arcjoga_frontend/providers/sub_provider.dart';
import 'package:arcjoga_frontend/providers/user_provider.dart';
import 'package:arcjoga_frontend/widgets/appbars/main_appbar.dart';
import 'package:arcjoga_frontend/widgets/course/course_card.dart';
import 'package:arcjoga_frontend/widgets/subs/sub_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<CourseProvider>(context, listen: false).fetchCourses(context);
    Provider.of<SubProvider>(context, listen: false).fetchSub(context);
  }

  @override
  Widget build(BuildContext context) {
    List<Course> courses = Provider.of<CourseProvider>(context).courses;
    User? user = Provider.of<UserProvider>(context).user;

    print('Courses: $courses');
    return MainLayout(
      appBar: const MainAppBar(
        onHomePage: true,
        title: 'TANFOLYAMOK',
      ),
      children: [
        if ((user != null && !user.hasSub) || (user == null))
          const Padding(
            padding: EdgeInsets.all(10),
            child: SubCard(),
          ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: CourseCard(
                  course: courses[index],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
