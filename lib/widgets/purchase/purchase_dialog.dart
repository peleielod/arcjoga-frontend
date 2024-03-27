import 'package:arcjoga_frontend/config.dart';
import 'package:arcjoga_frontend/helpers.dart';
import 'package:arcjoga_frontend/style.dart';
import 'package:arcjoga_frontend/widgets/common/app_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class PurchaseDialog extends StatefulWidget {
  final String title;
  final int price;
  final int itemId;
  final DateTime? validity;
  final bool isSub;
  const PurchaseDialog({
    super.key,
    required this.title,
    required this.price,
    required this.itemId,
    this.validity,
    this.isSub = false,
  });

  @override
  State<PurchaseDialog> createState() => _PurchaseDialogState();
}

class _PurchaseDialogState extends State<PurchaseDialog> {
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
                const SizedBox(height: 20),
                SvgPicture.asset(
                  'assets/icons/koszonjuk.svg',
                ),
                const SizedBox(height: 20),
                const Text(
                  'Köszönjük választásodat!',
                  style: Style.textDarkBlueBold,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  'A megvásárolandó csomag',
                  style: Style.textDarkBlue,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: const Color(Style.borderLight),
                  ),
                  child: Text(
                    widget.title,
                    style: Style.textDarkBlue,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'A csomag ára',
                  style: Style.textDarkBlue,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: const Color(Style.borderLight),
                  ),
                  child: Text(
                    '${widget.price} ${widget.isSub ? "Ft / hó" : 'Ft'}',
                    style: Style.textDarkBlue,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 15),
                if (widget.validity != null) ...[
                  const Text(
                    'Érvényesség',
                    style: Style.textDarkBlue,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: const Color(Style.borderLight),
                    ),
                    child: Text(
                      DateFormat('yyyy. MM. dd.').format(
                        widget.validity!.toLocal(),
                      ),
                      style: Style.textDarkBlue,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                const Text(
                  'Kattints a "Fizetek" gombra a vásárlás befejezéséhez és az azonnali hozzáférésért.',
                  style: Style.textDarkBlue,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                AppTextButton(
                  backgroundColor: const Color(Style.buttonDark),
                  text: 'FIZETEK',
                  textStyle: Style.textWhite,
                  onPressed: _handlePayment,
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

  void _handlePayment() async {
    try {
      String endpoint =
          widget.isSub ? 'course/purchase/1' : 'course/purchase/0';

      var data = {
        'courseId': widget.itemId,
        'title': widget.title,
        if (!widget.isSub) 'validity': widget.validity!.toIso8601String(),
        'price': widget.price,
      };

      CustomResponse response = await Helpers.sendRequest(
        context,
        endpoint,
        method: 'post',
        requireToken: true,
        body: data,
      );

      if (response.statusCode == 200) {
        var responseBody = response.data;
        if (responseBody != null && responseBody['GatewayUrl'] != null) {
          final gatewayUrl = responseBody['GatewayUrl'];
          _launchBarionPaymentUrl(gatewayUrl);
        } else {
          // Handle error
          print('Error initiating payment');
        }
      }
    } catch (e, stackTrace) {
      print('Handle payment EXCEPTION: $e');
      if (Config.isLiveMode) {
        await Sentry.captureException(
          e,
          stackTrace: stackTrace,
        );
      }
    }
  }

  Future<void> _launchBarionPaymentUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      // Handle error
      print('Could not launch $url');
    }
  }
}
