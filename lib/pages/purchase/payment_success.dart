import 'package:arcjoga_frontend/layouts/main_layout.dart';
import 'package:arcjoga_frontend/style.dart';
import 'package:arcjoga_frontend/widgets/appbars/main_appbar.dart';
import 'package:flutter/material.dart';

class PaymentSuccess extends StatelessWidget {
  const PaymentSuccess({super.key});

  static const routeName = '/paymentSuccessful';

  @override
  Widget build(BuildContext context) {
    return const MainLayout(
      appBar: MainAppBar(
        title: 'SIKERES FIZETÉS',
      ),
      children: [
        Text(
          'A fizetés sikeres volt!',
          style: Style.textDarkBlueBold,
        )
      ],
    );
  }
}
