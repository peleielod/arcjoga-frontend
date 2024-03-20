import 'package:arcjoga_frontend/config.dart';
import 'package:arcjoga_frontend/helpers.dart';
import 'package:arcjoga_frontend/models/course.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class CourseProvider with ChangeNotifier {
  List<Course> _courses = [];

  List<Course> get courses => _courses;

  void fetchCourses(BuildContext context) async {
    try {
      CustomResponse response = await Helpers.sendRequest(
        context,
        'courses',
        requireToken: false,
      );

      _courses = List.from(
        response.data.map(
          (courseJson) => Course.fromJson(courseJson),
        ),
      );

      notifyListeners();
    } catch (e, stackTrace) {
      if (Config.isLiveMode) {
        await Sentry.captureException(
          e,
          stackTrace: stackTrace,
        );
      }
      // print('Error fetching categories: $e');
    }
  }
}
