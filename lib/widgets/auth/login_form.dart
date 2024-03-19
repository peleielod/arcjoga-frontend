import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:local_auth/local_auth.dart';
import 'package:arcjoga_frontend/config.dart';
import 'package:arcjoga_frontend/helpers.dart';
import 'package:arcjoga_frontend/models/user.dart';
import 'package:arcjoga_frontend/pages/auth/forgot_password.dart';
import 'package:arcjoga_frontend/pages/home.dart';
import 'package:arcjoga_frontend/style.dart';
import 'package:arcjoga_frontend/validators.dart';
import 'package:arcjoga_frontend/widgets/common/app_text_button.dart';
import 'package:arcjoga_frontend/widgets/common/app_text_field.dart';
import 'package:arcjoga_frontend/widgets/common/error_dialog.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // final LocalAuthentication _localAuth = LocalAuthentication();

  void _loadTestData() {
    _emailController.text = 'asd@good.com';
    _passwordController.text = 'asdasd';
  }

  @override
  void initState() {
    super.initState();

    if (!Config.isLiveMode) {
      _loadTestData();
    }
  }

  //  Future<void> _checkBiometricSupport() async {
  //   bool canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics;
  //   bool isBiometricEnabled = await _secureStorage.read('biometricAuth') ;
  //   print(
  //     'Can auth: $canAuthenticateWithBiometrics , is biometric enabled: $isBiometricEnabled',
  //   );
  //   if (canAuthenticateWithBiometrics && isBiometricEnabled) {
  //     _authenticateUser();
  //   }
  // }

  void _handleLogin() async {
    var data = {
      'login': _emailController.text,
      'password': _passwordController.text,
    };

    print('DATA: ---> $data');

    CustomResponse response = await Helpers.sendRequest(
      context,
      'login',
      method: 'post',
      body: data,
      requireToken: false,
    );

    if (response.statusCode == 200) {
      print("RESPONSE DATA: ${response.data}");
      var responseData = response.data;

      User user = User.fromJson(responseData['user']);
      String userJson = json.encode(user.toJson());

      String? token = responseData['access_token'];

      if (token != null) {
        await _secureStorage.write(
          key: 'token',
          value: token,
        );
        await _secureStorage.write(
          key: 'tokenExpiry',
          value: responseData['expires_at'],
        );

        await _secureStorage.write(
          key: 'user',
          value: userJson,
        );

        await _promptBiometricAuth();

        Navigator.of(context).pushNamed(HomePage.routeName);
      }
    }
  }

  Future<void> _promptBiometricAuth() async {
    bool? useBiometricAuth =
        await _secureStorage.read(key: 'useBiometricAuth') != null;
    if (!useBiometricAuth) {
      bool? enableBiometric = await showDialog<bool>(
        context: context,
        builder: (context) {
          // bool isSwitched = false;
          return ErrorDialog(
            title: 'Biometrikus azonosítás engedélyezése',
            text:
                'Szeretné ezentúl a biometrikus adatait használni a belépéshez?',
            showSlider: true,
            sliderText: 'Belépés engedélyezése biometrikus adatokkal',
            onSwitchChanged: (value) {
              // isSwitched = value;
              // Update the state of the switch
              Navigator.of(context).pop(value);
            },
            buttonText: 'Később beállítom',
            onPress: () => Navigator.of(context).pop(null),
          );
        },
      );
      // Store the user's choice in SecureStorage
      if (enableBiometric != null) {
        await _secureStorage.write(
          key: 'useBiometricAuth',
          value: enableBiometric ? 'true' : 'false',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          padding: const EdgeInsets.only(
            top: 50,
            left: 30,
            right: 30,
            bottom: 10,
          ),
          decoration: BoxDecoration(
            color: const Color(Style.primaryDark),
            border: Border.all(
              color: const Color(Style.secondaryDark),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Form(
            child: Column(
              children: [
                AppTextField(
                  labelText: 'Felhasználónév vagy e-mail cím',
                  textController: _emailController,
                  textStyle: Style.textWhiteSmall,
                  textColor: const Color(Style.white),
                  fillColor: const Color(Style.primaryDark),
                  borderColor: const Color(Style.primaryLight),
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.emailValidator,
                  showLabelOnFocus: false,
                ),
                const SizedBox(height: 20),
                AppTextField(
                  labelText: 'Jelszó',
                  textController: _passwordController,
                  textStyle: Style.textWhiteSmall,
                  textColor: const Color(Style.white),
                  fillColor: const Color(Style.primaryDark),
                  borderColor: const Color(Style.primaryLight),
                  keyboardType: TextInputType.text,
                  validator: Validators.emailValidator,
                  showLabelOnFocus: false,
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                AppTextButton(
                  text: 'Bejelentkezés',
                  width: 290,
                  backgroundColor: const Color(Style.primaryLight),
                  textStyle: Style.primaryDarkText,
                  onPressed: _handleLogin,
                ),
                // const SizedBox(height: 20),
                TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, ForgotPassword.routeName),
                  child: const Text(
                    'Elfelejtetted a jelszavad?',
                    style: Style.secondaryLightText,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -20,
          left: 60,
          child: Container(
            width: 290,
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: const Color(Style.primaryLight),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'Belépés',
              style: Style.textWhite,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
