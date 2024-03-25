import 'package:flutter/material.dart';
import 'package:arcjoga_frontend/style.dart';
import 'package:arcjoga_frontend/widgets/common/app_text_button.dart';

class ErrorDialog extends StatefulWidget {
  final String title;
  final String text;
  final String buttonText;
  final VoidCallback onPress;
  final bool showSlider;
  final String sliderText;
  final Function(bool)? onSwitchChanged;

  const ErrorDialog({
    super.key,
    required this.title,
    required this.text,
    required this.buttonText,
    required this.onPress,
    this.showSlider = false,
    this.sliderText = '',
    this.onSwitchChanged,
  });

  @override
  State<ErrorDialog> createState() => _ErrorDialogState();
}

class _ErrorDialogState extends State<ErrorDialog> {
  bool _isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(Style.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topRight,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 25,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title,
                  style: Style.primaryDarkTitle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Text(
                  widget.text,
                  style: Style.primaryDarkText,
                  textAlign: TextAlign.center,
                ),
                if (widget.showSlider) ...[
                  const SizedBox(height: 20),
                  SwitchListTile(
                    title: Text(
                      widget.sliderText,
                      style: Style.primaryDarkText,
                    ),
                    value: _isSwitched,
                    onChanged: (value) {
                      setState(() {
                        _isSwitched = value;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 20),
                  AppTextButton(
                    backgroundColor: const Color(Style.primaryDark),
                    text: 'Beállítás',
                    textStyle: Style.textWhite,
                    onPressed: () => Navigator.of(context).pop(_isSwitched),
                  ),
                ],
                const SizedBox(height: 20),
                AppTextButton(
                  backgroundColor: const Color(Style.buttonDark),
                  text: widget.buttonText,
                  textStyle: Style.textWhite,
                  onPressed: widget.onPress,
                ),
              ],
            ),
          ),
          Positioned(
            right: 10,
            top: -25,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(Style.primaryDark),
                minimumSize: const Size(40, 40),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 38,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
