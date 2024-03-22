import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double width;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final isSvg = imageUrl.toLowerCase().endsWith('.svg');

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: isSvg
          ? SvgPicture.asset(
              imageUrl,
              width: 100,
              height: 70,
            )
          : CachedNetworkImage(
              width: width,
              // height: 70,
              imageUrl: imageUrl,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
    );
  }
}
