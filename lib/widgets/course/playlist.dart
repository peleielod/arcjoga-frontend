import 'package:arcjoga_frontend/models/course_content.dart';
import 'package:arcjoga_frontend/style.dart';
import 'package:arcjoga_frontend/widgets/common/network_image.dart';
import 'package:flutter/material.dart';

class ContentPlaylist extends StatelessWidget {
  final List<CourseContent> contents;
  final CourseContent activeContent;
  final Function(CourseContent) onContentSelected;

  const ContentPlaylist({
    super.key,
    required this.contents,
    required this.activeContent,
    required this.onContentSelected,
  });

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: const Color(Style.playlistLight),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: contents.length,
        itemBuilder: (context, index) {
          CourseContent content = contents[index];
          bool isActive = content.id == activeContent.id;
          return InkWell(
            onTap: () => onContentSelected(content),
            child: Container(
              padding: const EdgeInsets.all(8),
              height: 80,
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(Style.borderLight)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AppNetworkImage(
                      imageUrl: content.thumbnailUrl,
                      width: 80,
                    ),
                  ),
                  const SizedBox(width: 10), // Spacer
                  // Title and Length
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          content.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(formatDuration(content.length)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
