import 'package:arcjoga_frontend/layouts/main_layout.dart';
import 'package:arcjoga_frontend/models/course.dart';
import 'package:arcjoga_frontend/providers/course_provider.dart';
import 'package:arcjoga_frontend/widgets/appbars/main_appbar.dart';
import 'package:arcjoga_frontend/widgets/course/course_card.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    List<Course> courses = Provider.of<CourseProvider>(context).courses;

    return MainLayout(
      appBar: const MainAppBar(),
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 10,
            ),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              return CourseCard(
                course: courses[index],
              );
            },
          ),
        ),
      ],
    );
  }
}
