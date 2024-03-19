import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:arcjoga_frontend/config.dart';
import 'package:arcjoga_frontend/helpers.dart';
import 'package:arcjoga_frontend/pages/auth/forgot_password_verify.dart';
import 'package:arcjoga_frontend/style.dart';
import 'package:arcjoga_frontend/validators.dart';
import 'package:arcjoga_frontend/widgets/appbars/main_appbar.dart';
import 'package:arcjoga_frontend/widgets/common/app_text_button.dart';
import 'package:arcjoga_frontend/widgets/common/app_text_field.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  static const routeName = '/forgotPassword';

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendForgotPassword() async {
    try {
      setState(() => _isLoading = true);
      if (_formKey.currentState!.validate()) {
        // Validate the form
        CustomResponse response = await Helpers.sendRequest(
          context,
          'sendForgotPassword',
          headers: null,
          method: 'post',
          requireToken: false,
          body: {
            'email': _emailController.text,
          },
        );
        if (response.statusCode == 200) {
          if (mounted) {
            Navigator.pop(context);
            setState(() => _isLoading = false);
          }

          Navigator.of(context).pushNamed(
            ForgotPasswordVerify.routeName,
            arguments: _emailController.text,
          );
        }
      }
    } catch (e, stackTrace) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      if (Config.isLiveMode) {
        await Sentry.captureException(
          e,
          stackTrace: stackTrace,
        );
      }
    }
    //  finally {
    //   if (mounted) {
    //     setState(() => _isLoading = false);
    //   }
    // }
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
                  const SizedBox(height: 30),
                  const Text(
                    'Elfelejtette jelszavát?',
                    style: Style.primaryDarkTextBold,
                  ),
                  const SizedBox(height: 30),
                  const SizedBox(
                    width: 300,
                    child: Text(
                      'Új jelszót küldünk az alábbi e-mail címre:',
                      style: Style.primaryDarkText,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AppTextField(
                      textController: _emailController,
                      textStyle: Style.primaryDarkTextSmall,
                      textColor: const Color(Style.primaryDark),
                      fillColor: const Color(Style.white),
                      borderColor: const Color(Style.primaryDark),
                      keyboardType: TextInputType.emailAddress,
                      labelText: 'E-mail cím',
                      validator: Validators.emailValidator,
                    ),
                  ),
                  const SizedBox(height: 30),
                  AppTextButton(
                    text: 'Küldés',
                    width: 330,
                    textStyle: Style.textWhite,
                    backgroundColor: _isLoading
                        ? Colors.grey
                        : const Color(
                            Style.primaryDark,
                          ),
                    onPressed: () => _isLoading ? null : _sendForgotPassword(),
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
