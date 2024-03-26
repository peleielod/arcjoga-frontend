import 'dart:async';

import 'package:arcjoga_frontend/style.dart';
import 'package:arcjoga_frontend/widgets/common/app_text_button.dart';
import 'package:flutter/material.dart';

class ContentTimer extends StatefulWidget {
  const ContentTimer({super.key});

  @override
  State<ContentTimer> createState() => _ContentTimerState();
}

class _ContentTimerState extends State<ContentTimer> {
  Timer? _timer;
  Duration _duration = Duration.zero;
  bool _isRunning = false;

  void _startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }
    setState(() {
      _isRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _duration += const Duration(seconds: 1);
      });
    });
  }

  void _stopTimer() {
    setState(() {
      _isRunning = false;
    });
    _timer?.cancel();
  }

  void _resetTimer() {
    setState(() {
      _duration = Duration.zero;
      _isRunning = false;
    });
    _timer?.cancel();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}h ${twoDigitMinutes}m ${twoDigitSeconds}s";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(Style.white),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            _formatDuration(_duration),
            style: Style.primaryLightText,
          ),
          const SizedBox(height: 20),
          if (!_isRunning)
            AppTextButton(
              width: 200,
              backgroundColor: const Color(Style.buttonDark),
              text: 'INDÍTÁS',
              textStyle: Style.textWhite,
              onPressed: _startTimer,
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AppTextButton(
                  backgroundColor: const Color(Style.buttonDark),
                  width: 120,
                  text: 'STOP',
                  textStyle: Style.textWhite,
                  onPressed: _stopTimer,
                ),
                AppTextButton(
                  backgroundColor: const Color(Style.buttonDark),
                  width: 170,
                  text: 'ALAPÁLLAPOT',
                  textStyle: Style.textWhite,
                  onPressed: _resetTimer,
                )
              ],
            )
        ],
      ),
    );
  }
}
