import 'package:flutter/material.dart';
import 'package:arcjoga_frontend/style.dart';
import 'package:arcjoga_frontend/widgets/appbars/app_drawer.dart';

class MainLayout extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  final PreferredSizeWidget appBar;
  final Color backgroundColor;

  const MainLayout({
    super.key,
    required this.children,
    required this.appBar,
    this.title,
    this.backgroundColor = const Color(Style.white),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: backgroundColor,
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                if (title != null)
                  Text(
                    title!.toUpperCase(),
                    style: Style.primaryDarkTitle,
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 10),
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
