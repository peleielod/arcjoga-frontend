import 'package:arcjoga_frontend/config.dart';
import 'package:arcjoga_frontend/models/course_with_content.dart';
import 'package:arcjoga_frontend/models/loader.dart';
import 'package:arcjoga_frontend/pages/auth/forgot_password.dart';
import 'package:arcjoga_frontend/pages/auth/forgot_password_sent.dart';
import 'package:arcjoga_frontend/pages/auth/forgot_password_verify.dart';
import 'package:arcjoga_frontend/pages/auth/login.dart';
import 'package:arcjoga_frontend/pages/auth/register.dart';
import 'package:arcjoga_frontend/pages/auth/register_verify.dart';
import 'package:arcjoga_frontend/pages/course_watch.dart';
import 'package:arcjoga_frontend/pages/home.dart';
import 'package:arcjoga_frontend/pages/purchase/payment_success.dart';
import 'package:arcjoga_frontend/pages/settings/change_email.dart';
import 'package:arcjoga_frontend/pages/settings/change_password.dart';
import 'package:arcjoga_frontend/pages/settings/profile.dart';
import 'package:arcjoga_frontend/pages/settings/user_courses.dart';
import 'package:arcjoga_frontend/pages/settings/user_subs.dart';
import 'package:arcjoga_frontend/providers/course_provider.dart';
import 'package:arcjoga_frontend/providers/sub_provider.dart';
import 'package:arcjoga_frontend/providers/user_provider.dart';
import 'package:arcjoga_frontend/widgets/common/loader_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:uni_links/uni_links.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const FlutterSecureStorage secureStorage = FlutterSecureStorage();
  await secureStorage.deleteAll();

  await initDeepLinkListener();

  await SentryFlutter.init((options) {
    options.dsn =
        'https://cc636aa848e469ddca7c45a97b3ca899@o4504498510299136.ingest.us.sentry.io/4506972825845760';
    options.tracesSampleRate = 1.0;
  }, appRunner: () {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]).then((_) {
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => UserProvider(),
            ),
            ChangeNotifierProvider(
              create: (context) => CourseProvider(),
            ),
            ChangeNotifierProvider(
              create: (context) => SubProvider(),
            ),
            ChangeNotifierProvider(
              create: (context) => LoaderModel(),
            ),
          ],
          child: const MyAppWithLoader(),
        ),
      );
    });
  });
}

Future<void> initDeepLinkListener() async {
  // Get any initial link
  final initialLink = await getInitialUri();

  if (initialLink != null) {
    // Handle the initial link if the app was started with a deep link
    handleDeepLink(initialLink);
  }

  // Listen for new links coming in while the app is running
  uriLinkStream.listen((Uri? uri) {
    if (uri != null) {
      handleDeepLink(uri);
    }
  }, onError: (err) async {
    print('DEeeeep link listener error: ${err.toString()}');
    if (Config.isLiveMode) {
      await Sentry.captureException(err);
    }
  });
}

void handleDeepLink(Uri uri) {
  print("Deep LINK Detected: ${uri.toString()}");
  if (uri.path == '/paymentSuccess') {
    // Example on how to navigate to a specific route based on the deep link
    MyApp.navigatorKey.currentState?.pushNamed(PaymentSuccess.routeName);
  }
}

class MyAppWithLoader extends StatelessWidget {
  const MyAppWithLoader({super.key});

  @override
  Widget build(BuildContext context) {
    // Watching the loader model state
    final loaderModel = Provider.of<LoaderModel>(context);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          const MyApp(),
          if (loaderModel.isLoading) ...[
            const Positioned.fill(child: LoaderWidget()),
          ],
        ],
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      onGenerateRoute: (settings) {
        if (settings.name == CourseWatch.routeName) {
          final args = settings.arguments as CourseWatchArguments;
          return MaterialPageRoute(
            builder: (context) => CourseWatch(
              courseWithContent: args.courseWithContent,
              activeContent: args.activeContent,
            ),
          );
        }

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
        UserSubs.routeName: (context) => const UserSubs(),
        UserCourses.routeName: (context) => const UserCourses(),
        PaymentSuccess.routeName: (context) => const PaymentSuccess(),
      },
    );
  }
}
