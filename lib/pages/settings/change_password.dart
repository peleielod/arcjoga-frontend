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
import 'package:flutter_svg/svg.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ChangePassword extends StatefulWidget {
  static const routeName = '/changePassword';
  const ChangePassword({super.key});
  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordAgainController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String _errorMsg = '';
  bool _useBiometricAuth = false;

  @override
  void initState() {
    super.initState();
    _loadUseBiometricAuth();
  }

  void _loadUseBiometricAuth() async {
    String? useBiometricAuth =
        await _secureStorage.read(key: 'useBiometricAuth');
    if (useBiometricAuth != null) {
      setState(() {
        _useBiometricAuth = useBiometricAuth == 'true';
      });
    }
  }

  void _saveUseBiometricAuth(bool value) async {
    await _secureStorage.write(
      key: 'useBiometricAuth',
      value: value ? 'true' : 'false',
    );
  }

  void _handleChangeBiometricAuth(bool? newValue) async {
    setState(() {
      _useBiometricAuth = newValue!;
    });
    _saveUseBiometricAuth(newValue!);
  }

  bool _isPasswordValid() {
    return _passwordController.text == _passwordAgainController.text;
  }

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

  void _handleChangePassword() async {
    try {
      if (_formKey.currentState!.validate() && _isPasswordValid()) {
        var data = {
          'oldPassword': _oldPasswordController.text,
          'newPassword': _passwordController.text,
          'newPassword_confirmation': _passwordAgainController.text,
        };

        CustomResponse response = await Helpers.sendRequest(
          context,
          'changePassword',
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
    return MainLayout(
      appBar: const MainAppBar(
        title: 'JELSZO CSERE',
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
              SvgPicture.asset('assets/icons/jelszocsere.svg'),
              const SizedBox(height: 30),
              CheckboxListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 1,
                ),
                title: const Text("Biometrikus azonosítás használata"),
                value: _useBiometricAuth,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (newValue) {
                  _handleChangeBiometricAuth(newValue);
                },
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    AppTextField(
                      labelText: 'Jelenlegi jelszó',
                      textController: _oldPasswordController,
                      keyboardType: TextInputType.text,
                      textStyle: Style.primaryLightTextSmall,
                      textColor: const Color(Style.primaryLight),
                      fillColor: const Color(Style.white),
                      borderColor: const Color(Style.primaryLight),
                      validator: Validators.passwordValidator,
                    ),
                    const SizedBox(height: 30),
                    AppTextField(
                      labelText: 'Jelszó',
                      textController: _passwordController,
                      keyboardType: TextInputType.text,
                      textStyle: Style.primaryLightTextSmall,
                      textColor: const Color(Style.primaryLight),
                      fillColor: const Color(Style.white),
                      borderColor: const Color(Style.primaryLight),
                      validator: Validators.passwordValidator,
                    ),
                    const SizedBox(height: 30),
                    AppTextField(
                      labelText: 'Jelszó újra',
                      textController: _passwordAgainController,
                      keyboardType: TextInputType.text,
                      textStyle: Style.primaryLightTextSmall,
                      textColor: const Color(Style.primaryLight),
                      fillColor: const Color(Style.white),
                      borderColor: const Color(Style.primaryLight),
                      obscureText: true,
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
                      backgroundColor: const Color(Style.buttonDark),
                      onPressed: _handleChangePassword,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
