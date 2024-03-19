import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController textController;
  final TextStyle textStyle;
  final Color textColor;
  final Color fillColor;
  final Color borderColor;
  final TextInputType keyboardType;
  final String labelText;
  final String? Function(String?) validator;
  final bool showLabelWhenHasValue;
  final bool showLabelOnFocus;
  final bool obscureText;

  const AppTextField({
    super.key,
    required this.textController,
    required this.textStyle,
    required this.textColor,
    required this.fillColor,
    required this.borderColor,
    required this.keyboardType,
    required this.labelText,
    required this.validator,
    this.showLabelWhenHasValue = false,
    this.showLabelOnFocus = true,
    this.obscureText = false,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  String? getLabel() {
    TextEditingController controller = widget.textController;
    if (_focusNode.hasFocus && !widget.showLabelOnFocus) {
      return '';
    }
    if (!widget.showLabelWhenHasValue && controller.text.isNotEmpty) {
      return '';
    }
    return widget.labelText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textController,
      style: widget.textStyle,
      keyboardType: widget.keyboardType,
      obscureText: _obscureText,
      validator: widget.validator,
      focusNode: _focusNode,
      decoration: InputDecoration(
        labelText: getLabel(),
        labelStyle: widget.textStyle,
        fillColor: widget.fillColor,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: widget.borderColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: widget.borderColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: widget.borderColor,
          ),
        ),
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: widget.textColor,
                ),
                onPressed: _togglePasswordVisibility,
              )
            : null,
      ),
    );
  }
}
