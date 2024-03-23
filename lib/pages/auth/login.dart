import 'package:another_flushbar/flushbar.dart';
import 'package:arcjoga_frontend/config.dart';
import 'package:arcjoga_frontend/helpers.dart';
import 'package:arcjoga_frontend/models/user.dart';
import 'package:arcjoga_frontend/pages/auth/register.dart';
import 'package:arcjoga_frontend/pages/home.dart';
import 'package:arcjoga_frontend/providers/user_provider.dart';
import 'package:arcjoga_frontend/style.dart';
import 'package:arcjoga_frontend/widgets/appbars/app_drawer.dart';
import 'package:arcjoga_frontend/widgets/appbars/main_appbar.dart';
import 'package:arcjoga_frontend/widgets/auth/login_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  static const routeName = '/login';
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final LocalAuthentication auth = LocalAuthentication();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics = await auth.canCheckBiometrics;
    String? useBiometricAuth = await secureStorage.read(
      key: 'useBiometricAuth',
    );
    // print('CanCHEck: $canCheckBiometrics, use BIOMETRIC: $useBiometricAuth');
    if (canCheckBiometrics && useBiometricAuth == 'true') {
      _authenticate();
    }
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
        localizedReason:
            'Használja a beállított biometrikus azonosításhoz megadott adatait (ujjlenyomat vagy arc scan)',
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );
      if (!authenticated) {
        // print('Biometric Auth failed!');
      } else {
        _handleAuthLogin();
      }
    } catch (e) {
      // print('Biometric auth exception: $e');
    }
  }

  void _handleAuthLogin() async {
    try {
      User? user = await Provider.of<UserProvider>(context).fetchUser();
      if (user != null) {
        CustomResponse response = await Helpers.sendRequest(
          context,
          'generateToken',
          method: 'post',
          body: {
            'userId': user.id,
          },
          requireToken: false,
        );

        if (response.statusCode == 200) {
          var responseData = response.data;
          String? token = responseData['access_token'];
          // print('RESPONSE TOKEN: $token');
          if (token != null) {
            Provider.of<UserProvider>(
              context,
              listen: false,
            ).login(
              token,
              responseData['expires_at'],
            );
          } else {
            Flushbar(
              message:
                  "A felhasználói azonosítás sikertelen volt! Kérjük jelentkezzen be!",
              duration: const Duration(seconds: 3),
              flushbarPosition: FlushbarPosition.TOP,
            ).show(context);
          }
          Navigator.of(context).pushNamed(HomePage.routeName);
        } else {
          Flushbar(
            message:
                "A felhasználói azonosítás sikertelen volt! Kérjük jelentkezzen be!",
            duration: const Duration(seconds: 3),
            flushbarPosition: FlushbarPosition.TOP,
          ).show(context);
        }
      }
    } catch (e, stackTrace) {
      if (Config.isLiveMode) {
        await Sentry.captureException(
          e,
          stackTrace: stackTrace,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: const MainAppBar(
        onAuthPage: true,
        title: 'Belépés',
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/arc_auth_bg.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Center(
              child: Column(
                children: [
                  Image.asset('assets/images/timi_auth.png'),
                  const LoginForm(),
                  const SizedBox(height: 20),
                  const Text(
                    'Még nincs fiókod?',
                    style: Style.textWhite,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        Register.routeName,
                      );
                    },
                    child: const Text(
                      'Regisztrálj!',
                      style: Style.textWhiteBold,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
