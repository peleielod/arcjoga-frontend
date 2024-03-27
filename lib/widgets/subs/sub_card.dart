import 'package:arcjoga_frontend/models/sub.dart';
import 'package:arcjoga_frontend/providers/sub_provider.dart';
import 'package:arcjoga_frontend/style.dart';
import 'package:arcjoga_frontend/widgets/common/app_text_button.dart';
import 'package:arcjoga_frontend/widgets/common/network_image.dart';
import 'package:arcjoga_frontend/widgets/purchase/purchase_dialog.dart';
import 'package:arcjoga_frontend/widgets/subs/best_price_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class SubCard extends StatelessWidget {
  const SubCard({super.key});

  @override
  Widget build(BuildContext context) {
    Sub? sub = Provider.of<SubProvider>(context).sub;

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 300,
        minWidth: 350,
      ),
      child: Card(
        color: const Color(Style.white),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(Style.secondaryLight),
            border: Border.all(
              width: 2,
              color: const Color(Style.primaryLight),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: IntrinsicHeight(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (sub != null) ...[
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        AppNetworkImage(
                          imageUrl: sub.imageUrl,
                          width: 325,
                        ),
                        const Positioned(
                          top: 50,
                          left: -50,
                          child: BestPriceBanner(
                            color: Color(Style.buttonDark),
                            text: 'LEGJOBB ÁR',
                            width: 180,
                            height: 40,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(
                        sub.title,
                        style: Style.titleDark,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Divider(
                        color: Color(Style.borderLight),
                        thickness: 2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        '${sub.price} Ft',
                        style: Style.primaryLightText,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Divider(
                        color: Color(Style.borderLight),
                        thickness: 2,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        sub.description,
                        style: Style.primaryDarkTextSmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: AppTextButton(
                        backgroundColor: const Color(Style.buttonDark),
                        text: 'Ezt választom',
                        textStyle: Style.textWhite,
                        onPressed: () => _handlePurchaseSub(context),
                      ),
                    )
                  ] else
                    const CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handlePurchaseSub(BuildContext context) async {
    try {
      Sub? sub = Provider.of<SubProvider>(
        context,
        listen: false,
      ).sub;
      print('Sub on open purchase: $sub');
      if (sub != null) {
        bool confirm = await showDialog(
          context: context,
          builder: (BuildContext context) => PurchaseDialog(
            title: sub.title,
            price: sub.price,
            itemId: sub.id,
            isSub: true,
          ),
        );
      } else {
        print('SUB IS NULL ON OPEN PURCHASE');
      }
    } catch (e) {
      print("OPEN PURCHASE SUB EXCEPTION: $e");
    }
  }
}
