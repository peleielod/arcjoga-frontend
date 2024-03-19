import 'package:arcjoga_frontend/pages/auth/forgot_password.dart';
import 'package:arcjoga_frontend/pages/auth/forgot_password_sent.dart';
import 'package:arcjoga_frontend/pages/auth/forgot_password_verify.dart';
import 'package:arcjoga_frontend/pages/auth/login.dart';
import 'package:arcjoga_frontend/pages/auth/register.dart';
import 'package:arcjoga_frontend/pages/auth/register_verify.dart';
import 'package:arcjoga_frontend/pages/home.dart';
import 'package:arcjoga_frontend/pages/settings/change_email.dart';
import 'package:arcjoga_frontend/pages/settings/change_password.dart';
import 'package:arcjoga_frontend/pages/settings/profile.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      onGenerateRoute: (settings) {
        if (settings.name == ForgottPasswordSent.routeName) {
          final args = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => ForgottPasswordSent(email: args),
          );
        }

        if (settings.name == ForgotPasswordVerify.routeName) {
          final args = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => ForgotPasswordVerify(email: args),
          );
        }
        if (settings.name == RegisterVerify.routeName) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => RegisterVerify(
              email: args['email'],
              userId: args['userId'],
            ),
          );
        }
        return null;
      },
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        Login.routeName: (context) => const Login(),
        Register.routeName: (context) => const Register(),
        Profile.routeName: (context) => const Profile(),
        ChangePassword.routeName: (context) => const ChangePassword(),
        ChangeEmail.routeName: (context) => const ChangeEmail(),
        ForgotPassword.routeName: (context) => const ForgotPassword(),
      },
    );
  }
}
