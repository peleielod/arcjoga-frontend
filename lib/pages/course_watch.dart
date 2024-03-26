import 'package:arcjoga_frontend/helpers.dart';
import 'package:arcjoga_frontend/layouts/main_layout.dart';
import 'package:arcjoga_frontend/models/course.dart';
import 'package:arcjoga_frontend/models/course_content.dart';
import 'package:arcjoga_frontend/models/course_with_content.dart';
import 'package:arcjoga_frontend/providers/user_provider.dart';
import 'package:arcjoga_frontend/style.dart';
import 'package:arcjoga_frontend/widgets/appbars/main_appbar.dart';
import 'package:arcjoga_frontend/widgets/common/accordion.dart';
import 'package:arcjoga_frontend/widgets/course/content_desc.dart';
import 'package:arcjoga_frontend/widgets/course/playlist.dart';
import 'package:arcjoga_frontend/widgets/course/timer.dart';
import 'package:arcjoga_frontend/widgets/course/user_camera.dart';
import 'package:arcjoga_frontend/widgets/course/video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CourseWatchArguments {
  final CourseWithContent courseWithContent;
  final CourseContent activeContent;

  CourseWatchArguments({
    required this.courseWithContent,
    required this.activeContent,
  });
}

class CourseWatch extends StatefulWidget {
  final CourseWithContent courseWithContent;
  final CourseContent activeContent;

  const CourseWatch({
    super.key,
    required this.courseWithContent,
    required this.activeContent,
  });

  static const routeName = '/courseWatch';

  @override
  State<CourseWatch> createState() => _CourseWatchState();
}

class _CourseWatchState extends State<CourseWatch> {
  CourseContent? _currentContent;

  @override
  void initState() {
    super.initState();
    setState(() {
      _currentContent = widget.activeContent;
    });
  }

  void _handleContentSelected(CourseContent content) async {
    setState(() {
      _currentContent = content;
    });
  }

  @override
  Widget build(BuildContext context) {
    Course course = widget.courseWithContent.course;
    List<CourseContent> contents = widget.courseWithContent.contents;

    return MainLayout(
      appBar: const MainAppBar(),
      children: [
        const SizedBox(height: 10),
        Text(
          course.title.toUpperCase(),
          style: Style.titleDark,
        ),
        const SizedBox(height: 20),
        if (_currentContent != null) ...[
          ContentVideoPlayer(content: _currentContent!),
          const SizedBox(height: 20),
          AppAccordion(
            title: 'LEÍRÁS MEGTEKINTÉSE',
            headerTextStyle: Style.textWhiteBold,
            child: ContentDesc(
              description: _currentContent!.description,
            ),
          ),
          if (_currentContent!.cameraEnabled) ...[
            const SizedBox(height: 20),
            const AppAccordion(
              title: 'KAMERA',
              headerTextStyle: Style.textWhiteBold,
              expandIcon: Icon(
                Icons.camera_alt,
                color: Color(Style.white),
              ),
              collapseIcon: Icon(
                Icons.camera_alt,
                color: Color(Style.white),
              ),
              child: UserCamera(),
            ),
          ],
          if (_currentContent!.hasTimer) ...[
            const SizedBox(height: 20),
            const AppAccordion(
              title: 'STOPPER',
              expandIcon: Icon(
                Icons.timer,
                color: Color(Style.white),
              ),
              collapseIcon: Icon(
                Icons.timer,
                color: Color(Style.white),
              ),
              headerTextStyle: Style.textWhiteBold,
              child: ContentTimer(),
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            height: 300,
            child: ContentPlaylist(
              contents: contents,
              activeContent: _currentContent!,
              onContentSelected: _handleContentSelected,
            ),
          ),
        ]
      ],
    );
  }
}
