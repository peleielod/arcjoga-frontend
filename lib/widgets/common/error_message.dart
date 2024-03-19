import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorMessage({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          Text(
            message,
            style: const TextStyle(color: Colors.red),
          ),
          if (onRetry != null)
            TextButton(
              onPressed: onRetry,
              child: const Text('Újra'),
            ),
        ],
      ),
    );
  }
}
