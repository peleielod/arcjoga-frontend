import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:arcjoga_frontend/config.dart';
import 'package:arcjoga_frontend/helpers.dart';
import 'package:arcjoga_frontend/pages/auth/login.dart';
import 'package:arcjoga_frontend/style.dart';
import 'package:arcjoga_frontend/validators.dart';
import 'package:arcjoga_frontend/widgets/appbars/main_appbar.dart';
import 'package:arcjoga_frontend/widgets/common/app_text_button.dart';
import 'package:arcjoga_frontend/widgets/common/app_text_field.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ForgottPasswordSent extends StatefulWidget {
  final String email;
  const ForgottPasswordSent({
    super.key,
    required this.email,
  });

  static const routeName = '/forgotPasswordSent';

  @override
  State<ForgottPasswordSent> createState() => _ForgottPasswordSentState();
}

class _ForgottPasswordSentState extends State<ForgottPasswordSent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordAgainController =
      TextEditingController();

  // bool _isLoading = false;
  bool _isVerified = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordAgainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(
        onAuthPage: true,
        showBackBtn: true,
      ),
      backgroundColor: const Color(Style.white),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: _isVerified
              ? Column(
                  children: [
                    const SizedBox(
                      width: 200,
                      child: Text(
                        'Az email helyreállítása sikeres volt!',
                        style: Style.primaryDarkText,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 30),
                    AppTextButton(
                      text: 'Bejelentkezés',
                      backgroundColor: const Color(Style.buttonDark),
                      onPressed: () => {
                        Navigator.pushNamed(
                          context,
                          Login.routeName,
                        )
                      },
                      textStyle: Style.textWhite,
                      width: 380,
                    ),
                  ],
                )
              : Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/register_logo_good.svg',
                          height: 200,
                        ),
                        const SizedBox(height: 15),
                        AppTextField(
                          labelText: 'Jelszó',
                          textController: _passwordController,
                          textStyle: Style.primaryDarkTextSmall,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          textColor: const Color(Style.primaryDark),
                          fillColor: const Color(Style.white),
                          borderColor: const Color(Style.primaryDark),
                          validator: Validators.passwordValidator,
                        ),
                        const SizedBox(height: 30),
                        AppTextField(
                          labelText: 'Jelszó újra',
                          textController: _passwordAgainController,
                          textStyle: Style.primaryDarkTextSmall,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          textColor: const Color(Style.primaryDark),
                          fillColor: const Color(Style.white),
                          borderColor: const Color(Style.primaryDark),
                          validator: Validators.passwordValidator,
                        ),
                        const SizedBox(height: 30),
                        // Checkbox(value: value, onChanged: onChanged)
                        AppTextButton(
                          text: 'Jelszó megváltoztatása',
                          width: 330,
                          textStyle: Style.textWhite,
                          backgroundColor: const Color(Style.primaryDark),
                          onPressed: _handleChangePassword,
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  bool _isPasswordValid() {
    return _passwordController.text == _passwordAgainController.text;
  }

  void _handleChangePassword() async {
    try {
      if (_formKey.currentState!.validate() && _isPasswordValid()) {
        var data = {
          'email': widget.email,
          'newPassword': _passwordController.text,
          'newPassword_confirmation': _passwordAgainController.text,
        };

        CustomResponse response = await Helpers.sendRequest(
          context,
          'changeForgotPassword',
          headers: null,
          method: 'post',
          body: data,
          requireToken: true,
        );

        if (response.statusCode == 200) {
          var responseData = response.data;
          print(responseData);
          setState(() {
            _isVerified = true;
          });
        }
      }
    } catch (e, stackTrace) {
      // Navigator.pop(context);
      if (Config.isLiveMode) {
        await Sentry.captureException(
          e,
          stackTrace: stackTrace,
        );
      }
      print("SEND ERROR: $e");
    }
  }
}
