import 'package:arcjoga_frontend/models/course.dart';
import 'package:arcjoga_frontend/models/course_content.dart';

class CourseWithContent {
  final Course course;
  final List<CourseContent> contents;

  CourseWithContent({
    required this.course,
    required this.contents,
  });

  factory CourseWithContent.fromJson(Map<String, dynamic> json) {
    // Parse the course
    final course = Course.fromJson(json['course']);

    // Parse the contents - assuming 'contents' is a list of course content JSON objects
    final contents = (json['course']['contents'] as List)
        .map((contentJson) => CourseContent.fromJson(contentJson))
        .toList();

    return CourseWithContent(
      course: course,
      contents: contents,
    );
  }
}
