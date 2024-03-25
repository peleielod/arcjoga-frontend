import 'package:arcjoga_frontend/layouts/main_layout.dart';
import 'package:arcjoga_frontend/models/course.dart';
import 'package:arcjoga_frontend/models/course_content.dart';
import 'package:arcjoga_frontend/models/course_with_content.dart';
import 'package:arcjoga_frontend/widgets/appbars/main_appbar.dart';
import 'package:flutter/material.dart';

class CourseWatch extends StatefulWidget {
  final CourseWithContent courseWithContent;

  const CourseWatch({
    super.key,
    required this.courseWithContent,
  });

  static const routeName = '/courseWatch';

  @override
  State<CourseWatch> createState() => _CourseWatchState();
}

class _CourseWatchState extends State<CourseWatch> {
  @override
  Widget build(BuildContext context) {
    Course course = widget.courseWithContent.course;
    List<CourseContent> contents = widget.courseWithContent.contents;

    return MainLayout(
      appBar: const MainAppBar(),
      children: [
        Text(course.title),
        Text(contents[0].title),
      ],
    );
  }
}
