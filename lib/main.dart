import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tiktok_clone/constants/sizes.dart';
import 'package:flutter_tiktok_clone/features/authentication/email_screen.dart';
import 'package:flutter_tiktok_clone/features/authentication/login_screen.dart';
import 'package:flutter_tiktok_clone/features/authentication/sign_up_screen.dart';
import 'package:flutter_tiktok_clone/features/authentication/username_screen.dart';
import 'package:flutter_tiktok_clone/features/inbox/activity_screen.dart';
import 'package:flutter_tiktok_clone/features/main_navigation/main_navigation_screen.dart';
import 'package:flutter_tiktok_clone/features/onboarding/interests_screen.dart';
import 'package:flutter_tiktok_clone/router.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const TikTokApp());
}

class TikTokApp extends StatelessWidget {
  const TikTokApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: 'TikTok Clone',
      themeMode: ThemeMode.light,
      theme: ThemeData(
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: Sizes.size24,
            fontWeight: FontWeight.w700,
          ),
        ),
        //textTheme: GoogleFonts.itimTextTheme(),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: Sizes.size16 + Sizes.size2,
            fontWeight: FontWeight.w600,
          ),
        ),
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFFE9435A),
        splashColor: Colors.transparent,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFFE9435A),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
