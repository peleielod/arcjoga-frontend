import 'package:arcjoga_frontend/layouts/main_layout.dart';
import 'package:arcjoga_frontend/providers/sub_provider.dart';
import 'package:arcjoga_frontend/providers/user_provider.dart';
import 'package:arcjoga_frontend/style.dart';
import 'package:arcjoga_frontend/widgets/appbars/main_appbar.dart';
import 'package:arcjoga_frontend/widgets/common/app_text_button.dart';
import 'package:arcjoga_frontend/widgets/subs/user_sub_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class UserSubs extends StatefulWidget {
  const UserSubs({super.key});

  static const routeName = '/userSubs';

  @override
  State<UserSubs> createState() => _UserSubsState();
}

class _UserSubsState extends State<UserSubs> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context).user;
    var sub = Provider.of<SubProvider>(context).sub;

    return MainLayout(
      appBar: const MainAppBar(
        title: 'ELŐFIZETÉSEK',
        showBackBtn: true,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 20,
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              SvgPicture.asset('assets/icons/elofizetesek.svg'),
              const SizedBox(height: 30),
              if (sub != null && user != null && user.hasSub) ...[
                const Text(
                  'Előfizetések',
                  style: Style.textDarkBlueBold,
                ),
                UserSubCard(
                  userSub: user.userSub!,
                  sub: sub,
                ),
              ] else ...[
                const Text(
                  'Még nem vásároltál előfizetést!',
                  style: Style.textDarkBlueBold,
                ),
                 const SizedBox(height: 30),
                const Text(
                  'Merülj el az arcjóga rejtelmeiben, és válaszd ki a személyes céljaidat leginkább támogató csomagot, vásárolj bérletet, hogy teljes körű hozzáférést kapj az összes gyakorlathoz és tananyaghoz',
                  style: Style.textDarkBlue,
                ),
                const SizedBox(height: 30),
                AppTextButton(
                  backgroundColor: const Color(Style.buttonDark),
                  text: 'CSOMAGOK MEGTEKINTÉSE',
                  textStyle: Style.textWhite,
                  width: 300,
                  onPressed: () {},
                )
              ],
            ],
          ),
        ),
      ],
    );
  }
}
