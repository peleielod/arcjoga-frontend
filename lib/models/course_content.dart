import 'package:arcjoga_frontend/config.dart';

class CourseContent {
  final int id;
  final int courseId;
  final String thumbnailUrl;
  final String title;
  final String description;
  final String videoUrl;
  final int order;
  final Duration length;
  final bool hasTimer;
  final bool cameraEnabled;

  CourseContent({
    required this.id,
    required this.courseId,
    required this.thumbnailUrl,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.order,
    required this.length,
    required this.hasTimer,
    required this.cameraEnabled,
  });

  factory CourseContent.fromJson(Map<String, dynamic> json) {
    final lengthParts = json['length'].split(':').map(int.parse).toList();
    final duration = Duration(
      hours: lengthParts[0],
      minutes: lengthParts[1],
      seconds: lengthParts[2],
    );

    return CourseContent(
      id: json['id'],
      courseId: json['course_id'],
      thumbnailUrl: '${Config.backendUrl}storage/${json['thumbnail_url']}',
      title: json['title'],
      description: json['description'],
      videoUrl: '${Config.backendUrl}storage/${json['video_url']}',
      order: json['order'],
      length: duration,
      hasTimer: json['has_timer'] == 1,
      cameraEnabled: json['camera_enabled'] == 1,
    );
  }
}
