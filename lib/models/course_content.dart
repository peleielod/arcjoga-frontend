class CourseContent {
  final int id;
  final int courseId;
  final String thumbnailUrl;
  final String title;
  final String description;
  final String videoUrl;
  final int order;
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
    required this.hasTimer,
    required this.cameraEnabled,
  });

  factory CourseContent.fromJson(Map<String, dynamic> json) {
    var testJson = json;
    return CourseContent(
      id: json['id'],
      courseId: json['course_id'],
      thumbnailUrl: json['thumbnail_url'],
      title: json['title'],
      description: json['description'],
      videoUrl: json['video_url'],
      order: json['order'],
      hasTimer: json['has_timer'] == 1,
      cameraEnabled: json['camera_enabled'] == 1,
    );
  }
}
