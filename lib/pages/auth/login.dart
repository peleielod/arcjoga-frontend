import 'package:arcjoga_frontend/layouts/main_layout.dart';
import 'package:arcjoga_frontend/pages/auth/register.dart';
import 'package:arcjoga_frontend/style.dart';
import 'package:arcjoga_frontend/widgets/appbars/app_drawer.dart';
import 'package:arcjoga_frontend/widgets/appbars/main_appbar.dart';
import 'package:arcjoga_frontend/widgets/auth/login_form.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  static const routeName = '/login';
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
            Container(
              child: Center(
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
