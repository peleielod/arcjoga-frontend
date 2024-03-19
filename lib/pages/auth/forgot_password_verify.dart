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
import 'package:arcjoga_frontend/widgets/common/error_message.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ForgotPasswordVerifyArguments {
  final String email;

  ForgotPasswordVerifyArguments({
    required this.email,
  });
}

class ForgotPasswordVerify extends StatefulWidget {
  final String email;

  static const routeName = '/veirfyForgotPassword';

  const ForgotPasswordVerify({
    super.key,
    required this.email,
  });

  @override
  State<ForgotPasswordVerify> createState() => _ForgotPasswordVerifyState();
}

class _ForgotPasswordVerifyState extends State<ForgotPasswordVerify> {
  bool _isLoading = false;
  bool _isVerified = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _changeFormKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordAgainController =
      TextEditingController();
  String _errorMsg = '';

  Future<void> _verifyCode() async {
    try {
      if (_formKey.currentState!.validate()) {
        var data = {
          'verificationCode': _codeController.text,
          'email': widget.email,
        };

        print('DATA: ---> $data');
        setState(() => _isLoading = true);
        CustomResponse response = await Helpers.sendRequest(
          context,
          'verifyForgotPassword',
          method: 'post',
          body: data,
          requireToken: false,
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
      print(e);

      if (Config.isLiveMode) {
        await Sentry.captureException(
          e,
          stackTrace: stackTrace,
        );
      }
    } finally {
      if (mounted) {
        if (_isLoading) {
          // if (Navigator.canPop(context)) {
          //   Navigator.pop(context);
          // }
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Future<void> _resendCode() async {
    CustomResponse response = await Helpers.sendRequest(
      context,
      'sendForgotPassword',
      method: 'post',
      body: {
        'email': widget.email,
      },
      requireToken: false,
    );
    if (response.statusCode == 200) {}
  }

  bool _isPasswordValid() {
    bool isValid = _passwordController.text == _passwordAgainController.text;
    if (!isValid) {
      setState(() {
        _errorMsg = 'A két jelszó nem egyezik!';
      });
    }
    return isValid;
  }

  void _handleChangePassword() async {
    try {
      if (_changeFormKey.currentState!.validate() && _isPasswordValid()) {
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
          requireToken: false,
        );

        if (response.statusCode == 200) {
          Navigator.pushNamed(context, Login.routeName);
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
          child: Center(
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
                  _isVerified
                      ? Form(
                          key: _changeFormKey,
                          child: Column(
                            children: [
                              const SizedBox(height: 30),
                              const Text(
                                'A visszaigazolás sikeres volt! Cserélje le a jelszavát és lépjen be fiókjába.',
                                style: Style.primaryDarkText,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 30),
                              AppTextField(
                                labelText: 'Új jelszó',
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
                                labelText: 'Új jelszó újra',
                                textController: _passwordAgainController,
                                textStyle: Style.primaryDarkTextSmall,
                                keyboardType: TextInputType.text,
                                obscureText: true,
                                textColor: const Color(Style.primaryDark),
                                fillColor: const Color(Style.white),
                                borderColor: const Color(Style.primaryDark),
                                validator: Validators.passwordValidator,
                              ),
                              if (_errorMsg.isNotEmpty)
                                ErrorMessage(
                                  message: _errorMsg,
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
                        )
                      : Column(
                          children: [
                            const SizedBox(
                              width: 200,
                              child: Text(
                                'Adja meg az email-ben kapott visszaigazoló kódot:',
                                style: Style.primaryDarkText,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 20),
                            AppTextField(
                              labelText: 'Visszaigazoló kód',
                              textController: _codeController,
                              textStyle: Style.primaryDarkText,
                              keyboardType: TextInputType.emailAddress,
                              textColor: const Color(Style.primaryDark),
                              fillColor: const Color(Style.white),
                              borderColor: const Color(Style.primaryDark),
                              showLabelOnFocus: false,
                              validator: Validators.requiredFieldValidator,
                            ),
                            const SizedBox(height: 30),
                            AppTextButton(
                              text: 'Visszaigazolás',
                              backgroundColor: const Color(Style.buttonDark),
                              onPressed: _verifyCode,
                              textStyle: Style.textWhite,
                              width: 380,
                            ),
                            const SizedBox(height: 30),
                            AppTextButton(
                              text: 'Kód újraküldése',
                              backgroundColor: const Color(Style.buttonDark),
                              onPressed: _resendCode,
                              textStyle: Style.textWhite,
                              width: 380,
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
