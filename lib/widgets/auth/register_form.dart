import 'package:flutter/material.dart';
import 'package:arcjoga_frontend/config.dart';
import 'package:arcjoga_frontend/helpers.dart';
import 'package:arcjoga_frontend/pages/auth/register_verify.dart';
import 'package:arcjoga_frontend/style.dart';
import 'package:arcjoga_frontend/validators.dart';
import 'package:arcjoga_frontend/widgets/common/app_text_button.dart';
import 'package:arcjoga_frontend/widgets/common/app_text_field.dart';
import 'package:arcjoga_frontend/widgets/common/error_message.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  String _errorMsg = '';

  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordAgainController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    if (!Config.isLiveMode) {
      // Assign initial values for testing
      _loadTestData();
    }
  }

  void _loadTestData() {
    _usernameController.text = 'Test Elek';
    _emailController.text = 'asd@asdasd.com';
    _passwordController.text = 'asdasd';
    _passwordAgainController.text = 'asdasd';
  }

  bool _isPasswordValid() {
    return _passwordController.text == _passwordAgainController.text;
  }

  void _handleRegister() async {
    try {
      if (_formKey.currentState!.validate() && _isPasswordValid()) {
        var data = {
          'username': _usernameController.text,
          'email': _emailController.text,
          'password': _passwordController.text
        };
        print('DATA------------->  $data');
        setState(() => _isLoading = true);
        CustomResponse response = await Helpers.sendRequest(
          context,
          'register',
          headers: null,
          method: 'post',
          body: data,
          requireToken: false,
        );

        var responseData = response.data;
        print('RESPONSE STATUSSS: ~~~~~~ ${response.statusCode}');
        if (response.statusCode == 200) {
          var userId = responseData['userId'];
          // Navigator.pop(context);
          Navigator.of(context).pushNamed(
            RegisterVerify.routeName,
            arguments: {
              'email': _emailController.text,
              'userId': userId as int,
            },
          );
        } else {
          setState(() {
            _errorMsg = responseData;
          });
        }
      } else {
        setState(() {
          _errorMsg = 'A két jelszó nem egyezik meg!';
        });
      }
    } catch (e, stackTrace) {
      if (Config.isLiveMode) {
        await Sentry.captureException(
          e,
          stackTrace: stackTrace,
        );
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Ensure you only pop if a modal or loader is shown
        // Navigator.pop(context);
      });
      print("SEND ERROR: $e");
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 30,
        horizontal: 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            AppTextField(
              textController: _emailController,
              textStyle: Style.primaryDarkTextSmall,
              textColor: const Color(Style.primaryDark),
              fillColor: const Color(Style.white),
              borderColor: const Color(Style.primaryDark),
              keyboardType: TextInputType.emailAddress,
              labelText: 'E-mail cím',
              validator: Validators.emailValidator,
            ),
            const SizedBox(height: 30),
            AppTextField(
              textController: _usernameController,
              textStyle: Style.primaryDarkTextSmall,
              textColor: const Color(Style.primaryDark),
              fillColor: const Color(Style.white),
              borderColor: const Color(Style.primaryDark),
              keyboardType: TextInputType.text,
              labelText: 'Felhasználónév',
              validator: Validators.requiredFieldValidator,
            ),
            const SizedBox(height: 30),
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
            if (_errorMsg.isNotEmpty)
              ErrorMessage(
                message: _errorMsg,
              ),
            const SizedBox(height: 30),
            // Checkbox(value: value, onChanged: onChanged)
            AppTextButton(
              text: 'Regisztráció',
              width: 330,
              textStyle: Style.textWhite,
              backgroundColor: _isLoading
                  ? Colors.grey
                  : const Color(
                      Style.primaryDark,
                    ),
              onPressed: () => _isLoading ? null : _handleRegister(),
            ),
          ],
        ),
      ),
    );
  }
}
