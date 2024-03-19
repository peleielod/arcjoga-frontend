import 'package:flutter/material.dart';
import 'package:arcjoga_frontend/models/loader.dart';
import 'package:provider/provider.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final loaderModel = Provider.of<LoaderModel>(context);

    return loaderModel.isLoading
        ? Directionality(
            textDirection: TextDirection.ltr, // Default text direction
            child: Container(
              color: Colors.black.withOpacity(0.5), // Semi-transparent overlay
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
        : const Directionality(
            textDirection: TextDirection.ltr,
            child: SizedBox.shrink(),
          );
  }
}
