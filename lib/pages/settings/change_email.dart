import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:arcjoga_frontend/config.dart';
import 'package:arcjoga_frontend/helpers.dart';
import 'package:arcjoga_frontend/layouts/main_layout.dart';
import 'package:arcjoga_frontend/pages/home.dart';
import 'package:arcjoga_frontend/style.dart';
import 'package:arcjoga_frontend/validators.dart';
import 'package:arcjoga_frontend/widgets/appbars/main_appbar.dart';
import 'package:arcjoga_frontend/widgets/common/app_text_button.dart';
import 'package:arcjoga_frontend/widgets/common/app_text_field.dart';
import 'package:arcjoga_frontend/widgets/common/error_message.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ChangeEmail extends StatefulWidget {
  static const routeName = '/changeEmail';
  const ChangeEmail({super.key});

  @override
  State<ChangeEmail> createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  final _formKey = GlobalKey<FormState>();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  String _errorMsg = '';

  final TextEditingController _oldEmailController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _emailAgainController = TextEditingController();

  Future<void> _logout(BuildContext context) async {
    // Clear user data from secure storage
    await _secureStorage.delete(key: 'user');
    await _secureStorage.delete(key: 'token');
    // Navigate to the home page
    Navigator.pushReplacementNamed(
      context,
      HomePage.routeName,
    );
  }

  bool _isEmailValid() {
    return _emailController.text == _emailAgainController.text;
  }

  void _handleChangeEmail() async {
    try {
      if (_formKey.currentState!.validate() && _isEmailValid()) {
        var data = {
          'oldEmail': _oldEmailController.text,
          'newEmail': _emailController.text,
          'newEmail_confirmation': _emailAgainController.text,
        };

        CustomResponse response = await Helpers.sendRequest(
          context,
          'changeEmail',
          headers: null,
          method: 'post',
          body: data,
          requireToken: true,
        );

        if (response.statusCode == 200) {
          await _logout(context);
        }
      }
    } catch (e, stackTrace) {
      if (Config.isLiveMode) {
        await Sentry.captureException(
          e,
          stackTrace: stackTrace,
        );
      }
      // Navigator.pop(context);
      print("SEND ERROR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appBar: const MainAppBar(
        title: 'EMAIL CSERE',
        showBackBtn: true,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 50),
                Image.asset('assets/icons/mail_icon.png'),
                const SizedBox(height: 50),
                AppTextField(
                  labelText: 'Jelenlegi email cim',
                  textController: _oldEmailController,
                  keyboardType: TextInputType.emailAddress,
                  textStyle: Style.primaryLightTextSmall,
                  textColor: const Color(Style.primaryLight),
                  fillColor: const Color(Style.white),
                  borderColor: const Color(Style.primaryLight),
                  validator: Validators.emailValidator,
                ),
                const SizedBox(height: 30),
                AppTextField(
                  labelText: 'Email',
                  textController: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textStyle: Style.primaryLightTextSmall,
                  textColor: const Color(Style.primaryLight),
                  fillColor: const Color(Style.white),
                  borderColor: const Color(Style.primaryLight),
                  validator: Validators.emailValidator,
                ),
                const SizedBox(height: 30),
                AppTextField(
                  labelText: 'Email újra',
                  textController: _emailAgainController,
                  keyboardType: TextInputType.emailAddress,
                  textStyle: Style.primaryLightTextSmall,
                  textColor: const Color(Style.primaryLight),
                  fillColor: const Color(Style.white),
                  borderColor: const Color(Style.primaryLight),
                  validator: Validators.emailValidator,
                ),
                if (_errorMsg.isNotEmpty)
                  ErrorMessage(
                    message: _errorMsg,
                  ),
                const SizedBox(height: 30),
                // Checkbox(value: value, onChanged: onChanged)
                AppTextButton(
                  text: 'Email megváltoztatása',
                  width: 330,
                  textStyle: Style.textWhite,
                  backgroundColor: const Color(Style.buttonDark),
                  onPressed: _handleChangeEmail,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
