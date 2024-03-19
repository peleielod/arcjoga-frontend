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

class RegisterVerifyArguments {
  final String email;
  final int userId;

  RegisterVerifyArguments({
    required this.email,
    required this.userId,
  });
}

class RegisterVerify extends StatefulWidget {
  final String email;
  final int userId;

  static const routeName = '/veirfyRegister';

  const RegisterVerify({
    super.key,
    required this.email,
    required this.userId,
  });

  @override
  State<RegisterVerify> createState() => _RegisterVerifyState();
}

class _RegisterVerifyState extends State<RegisterVerify> {
  bool _isLoading = false;
  bool _isVerified = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();

  Future<void> _verifyCode() async {
    try {
      if (_formKey.currentState!.validate()) {
        var data = {
          'verificationCode': _codeController.text,
          'userId': widget.userId,
        };

        print('DATA: ---> $data');
        setState(() => _isLoading = true);
        CustomResponse response = await Helpers.sendRequest(
          context,
          'verifyRegister',
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
      'sendVerificationCode',
      method: 'post',
      body: {
        'id': widget.userId,
      },
      requireToken: false,
    );
    if (response.statusCode == 200) {}
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
                      ? Column(
                          children: [
                            const SizedBox(
                              width: 200,
                              child: Text(
                                'A visszaigazolás sikeres volt!',
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
