import 'package:arcjoga_frontend/config.dart';
import 'package:arcjoga_frontend/helpers.dart';
import 'package:arcjoga_frontend/models/sub.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class SubProvider with ChangeNotifier {
  Sub? _sub;

  Sub? get sub => _sub;

  void fetchSub(BuildContext context) async {
    try {
      CustomResponse response = await Helpers.sendRequest(
        context,
        'sub',
        requireToken: false,
      );

      if (response.statusCode == 200) {
        _sub = Sub.fromJson(response.data);
      }

      notifyListeners();
    } catch (e, stackTrace) {
      if (Config.isLiveMode) {
        await Sentry.captureException(
          e,
          stackTrace: stackTrace,
        );
      }
      // print('Error fetching categories: $e');
    }
  }
}
