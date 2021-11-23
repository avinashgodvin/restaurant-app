import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/pages/details_page.dart';
import 'package:restaurant_app/pages/home_page.dart';
import 'package:restaurant_app/pages/login_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_app/pages/password_reset_form_page.dart';
import 'package:restaurant_app/pages/password_reset_page.dart';
import 'package:restaurant_app/pages/shared_preference.dart';
import 'package:restaurant_app/pages/signUp_page.dart';
import 'package:restaurant_app/pages/testLoader.dart';
import 'package:restaurant_app/provider/my_provider.dart';
import 'package:restaurant_app/utils/routes.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await UserSimplePreference.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MyProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // home: HomePage(),
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: GoogleFonts.lato().fontFamily,
        ),
        initialRoute:
        UserSimplePreference.getRememberMeStatus()
            ? MyRoutes.homeRoute
            : MyRoutes.loginRoute,
        routes: {
          MyRoutes.homeRoute: (context) => HomePage(),
          MyRoutes.loginRoute: (context) => LoginPage(),
          MyRoutes.signUpRoute: (context) => SignUpPage(),
          MyRoutes.passwordResetRoute: (context) => ResetPassword(),
          MyRoutes.passwordResetFormRoute: (context) => PasswordRestFormPage(),
          MyRoutes.testRoute: (context) => TestLoader(),
          MyRoutes.detailsPage: (context) => DetailsPage(),
        },
      ),
    );
  }
}
