import 'package:arcjoga_frontend/config.dart';
import 'package:arcjoga_frontend/helpers.dart';
import 'package:arcjoga_frontend/models/user.dart';
import 'package:arcjoga_frontend/pages/home.dart';
import 'package:arcjoga_frontend/pages/settings/change_email.dart';
import 'package:arcjoga_frontend/pages/settings/change_password.dart';
import 'package:arcjoga_frontend/pages/settings/user_courses.dart';
import 'package:arcjoga_frontend/pages/settings/user_subs.dart';
import 'package:arcjoga_frontend/providers/user_provider.dart';
import 'package:arcjoga_frontend/style.dart';
import 'package:arcjoga_frontend/widgets/common/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class SettingsList extends StatelessWidget {
  const SettingsList({super.key});

  void _changePassword(BuildContext context) {
    Navigator.pushNamed(context, ChangePassword.routeName);
  }

  void _changeEmail(BuildContext context) {
    Navigator.pushNamed(context, ChangeEmail.routeName);
  }

  void _subscriptions(BuildContext context) {
    Navigator.pushNamed(context, UserSubs.routeName);
  }

  void _userCourses(BuildContext context) {
    Navigator.pushNamed(context, UserCourses.routeName);
  }

  Future<void> _logout(BuildContext context) async {
    Provider.of<UserProvider>(
      context,
      listen: false,
    ).logout();

    Navigator.pushReplacementNamed(
      context,
      HomePage.routeName,
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    bool confirm = await showDialog(
          context: context,
          builder: (BuildContext context) => ErrorDialog(
            title: "Biztosan kijelentkezel?",
            text:
                "Ne feledd, hogy kijelentkezés után újra be kell jelentkezned a fiókodba, hogy hozzáférj a személyre szabott jóslásokhoz és előfizetési előnyökhöz. Ha csak átmenetileg hagyod el az alkalmazást, javasoljuk, hogy maradj bejelentkezve a kényelmes visszatérés érdekében.",
            buttonText: "Kijelentkezés",
            onPress: () {
              Navigator.of(context).pop(true);
            },
          ),
        ) ??
        false;

    if (confirm) {
      await _logout(context);
    }
  }

  Future<void> _deleteProfile(BuildContext context) async {
    // Show a confirmation dialog
    bool confirm = await showDialog(
          context: context,
          builder: (BuildContext context) => ErrorDialog(
            title: "Profil törlése",
            text:
                "Biztosan törölni szeretnéd a fiókod? Ez a művelet végleges, a fiókot nem lehet visszaállítani utána.",
            buttonText: "Törlés",
            onPress: () {
              Navigator.of(context).pop(true);
            },
          ),
        ) ??
        false;

    if (confirm) {
      try {
        User? user = await Provider.of<UserProvider>(
          context,
          listen: false,
        ).fetchUser();

        await Helpers.sendRequest(
          context,
          'deleteProfile',
          method: 'POST',
          body: {
            'userId': user?.id.toString() ?? '',
          },
          requireToken: true,
        );

        await _logout(context);
      } catch (e, stackTrace) {
        if (Config.isLiveMode) {
          await Sentry.captureException(
            e,
            stackTrace: stackTrace,
          );
        }
        // print('Error deleting profile: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight - 400,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.vpn_key,
                    color: Color(Style.primaryDark),
                  ),
                  title: const Text(
                    'JELSZÓ CSERE',
                    style: Style.textDarkBlue,
                  ),
                  onTap: () => _changePassword(context),
                ),
                const Divider(
                  color: Color(Style.primaryLight),
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.email,
                    color: Color(Style.primaryDark),
                  ),
                  title: const Text(
                    'EMAIL CSERE',
                    style: Style.textDarkBlue,
                  ),
                  onTap: () => _changeEmail(context),
                ),
                const Divider(
                  color: Color(Style.primaryLight),
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.subscriptions,
                    color: Color(Style.primaryDark),
                  ),
                  title: const Text(
                    'MEGVÁSÁROLT CSOMAGOK',
                    style: Style.textDarkBlue,
                  ),
                  onTap: () => _userCourses(context),
                ),
                const Divider(
                  color: Color(Style.primaryLight),
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.subscriptions,
                    color: Color(Style.primaryDark),
                  ),
                  title: const Text(
                    'ELŐFIZETÉS',
                    style: Style.textDarkBlue,
                  ),
                  onTap: () => _subscriptions(context),
                ),
                const Divider(
                  color: Color(Style.primaryLight),
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: Color(Style.primaryDark),
                  ),
                  title: const Text(
                    'KIJELENTKEZÉS',
                    style: Style.textDarkBlue,
                  ),
                  onTap: () => _handleLogout(context),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.delete_forever,
              color: Color(Style.primaryDark),
            ),
            title: const Text(
              'PROFIL TÖRLÉSE',
              style: Style.textDarkBlue,
            ),
            onTap: () => _deleteProfile(context),
          ),
        ],
      ),
    );
  }
}
