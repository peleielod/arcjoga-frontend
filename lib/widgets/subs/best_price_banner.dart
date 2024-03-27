import 'package:arcjoga_frontend/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BestPriceBannerPainter extends CustomPainter {
  final Color color;
  BestPriceBannerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    // Start from bottom left
    path.moveTo(0, size.height);

    // Top point (adjust for banner tilt)
    path.lineTo(size.width * 0.235, 0);

    // Top right
    path.lineTo(size.width, 0);

    // Connect back to bottom (adjust for banner tilt)
    path.lineTo(size.width * 1.22, size.height);

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BestPriceBanner extends StatelessWidget {
  final Color color;
  final String text;
  final double width;
  final double height;

  const BestPriceBanner({
    super.key,
    required this.color,
    required this.text,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Transform.rotate(
          angle: -0.785398,
          child: CustomPaint(
            size: Size(width, height),
            painter: BestPriceBannerPainter(color: color),
            child: Container(
              width: width,
              height: height,
              alignment: Alignment.center,
              child: const SizedBox(),
            ),
          ),
        ),
        Positioned(
          top: 0,
          bottom: 20,
          right: 35,
          child: Transform.rotate(
            angle: -0.77, //-0.7854,
            child: Text(
              text,
              style: Style.textWhiteBold,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
