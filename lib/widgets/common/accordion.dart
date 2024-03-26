import 'package:arcjoga_frontend/style.dart';
import 'package:flutter/material.dart';

class AppAccordion extends StatefulWidget {
  final String title;
  final Widget child;
  final TextStyle? headerTextStyle;
  final Color? headerBackgroundColor;
  final Color? bodyBackgroundColor;
  final Icon? expandIcon;
  final Icon? collapseIcon;

  const AppAccordion({
    super.key,
    required this.title,
    required this.child,
    this.headerTextStyle,
    this.headerBackgroundColor = const Color(Style.buttonDark),
    this.bodyBackgroundColor = const Color(Style.white),
    this.expandIcon = const Icon(
      Icons.expand_more,
      color: Color(Style.white),
      size: 32,
    ),
    this.collapseIcon = const Icon(
      Icons.expand_less,
      color: Color(Style.white),
      size: 32,
    ),
  });

  @override
  State<AppAccordion> createState() => _AppAccordionState();
}

class _AppAccordionState extends State<AppAccordion> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
            color: widget.headerBackgroundColor,
            borderRadius: _isExpanded
                ? const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )
                : BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: widget.headerTextStyle ??
                    const TextStyle(color: Colors.white),
              ),
              IconButton(
                icon: _isExpanded ? widget.collapseIcon! : widget.expandIcon!,
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
              )
            ],
          ),
        ),
        _isExpanded
            ? Container(
                decoration: BoxDecoration(
                  color: widget.headerBackgroundColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                child: widget.child,
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
