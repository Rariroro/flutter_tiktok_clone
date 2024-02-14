import 'package:flutter/material.dart';
import 'package:flutter_tiktok_clone/constants/gaps.dart';
import 'package:flutter_tiktok_clone/constants/sizes.dart';
import 'package:flutter_tiktok_clone/features/authentication/login_form_screen.dart';
import 'package:flutter_tiktok_clone/features/authentication/widgets/auth_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _onSignUpTap(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _onEmailLoginTap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginFormScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.size40),
          child: Column(
            children: [
              Gaps.v80,
              const Text(
                'Log in to TikTok',
                style: TextStyle(
                    fontSize: Sizes.size24, fontWeight: FontWeight.w700),
              ),
              Gaps.v20,
              const Text(
                'Manage your account, check notifications, comment on videos, and more.',
                style: TextStyle(
                  fontSize: Sizes.size16,
                  color: Colors.black45,
                ),
                textAlign: TextAlign.center,
              ),
              Gaps.v40,
              GestureDetector(
                onTap: () => _onEmailLoginTap(context),
                child: const AuthButton(
                    icon: FaIcon(
                      FontAwesomeIcons.user,
                    ),
                    text: 'Use email or password'),
              ),
              Gaps.v16,
              const AuthButton(
                  icon: FaIcon(
                    FontAwesomeIcons.apple,
                  ),
                  text: 'Continue with Apple'),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 2,
        color: Colors.grey.shade50,
        padding: const EdgeInsets.symmetric(vertical: Sizes.size20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Don't have an account?",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Gaps.h5,
            GestureDetector(
              onTap: () => _onSignUpTap(context),
              child: Text(
                'Sign up',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
