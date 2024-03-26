import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:arcjoga_frontend/pages/auth/login.dart';
import 'package:arcjoga_frontend/style.dart';
import 'package:arcjoga_frontend/widgets/appbars/main_appbar.dart';
import 'package:arcjoga_frontend/widgets/auth/register_form.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  static const routeName = '/register';

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(
        title: 'REGISZTRÁCIÓ',
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                SvgPicture.asset(
                  'assets/icons/logo.svg',
                  width: 250,
                  // height: 200,
                ),
                const SizedBox(height: 30),
                const RegisterForm(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Van már fiókod?',
                      style: Style.textDarkBlue,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Login.routeName);
                      },
                      child: const Text(
                        'Lépj be!',
                        style: Style.textDarkBlueBold,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
