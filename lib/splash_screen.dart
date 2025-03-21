import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:ct312hm01_temp/data/models/user_model.dart';
import 'package:ct312hm01_temp/presentation/screens/auth/login_screen.dart';
import 'package:ct312hm01_temp/presentation/screens/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimatedSplashScreenWidget extends StatelessWidget {
  final User? currentUser;

  const AnimatedSplashScreenWidget({super.key, this.currentUser});

  Widget _getNextScreen() {
    if (currentUser == null) {
      return const LoginScreen();
    } else {
      return ChatScreen(userId: currentUser!.userid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: SizedBox.expand(
        child: Lottie.asset('assets/animation_splash_screen.json', fit: BoxFit.fill),
      ),
        splashIconSize: double.infinity,

      nextScreen: _getNextScreen(),
      duration: 4000,
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}