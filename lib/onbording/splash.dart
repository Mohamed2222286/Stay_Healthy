import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'onbording_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Container(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/splash.jpg',
                fit: BoxFit.cover,
              ),
              Align(
                alignment: Alignment.center,
                child: Lottie.asset(
                    'assets/animation/Animation - 1738338732628.json'),
              ),
              // SizedBox(
              //   height: 30,
              // ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 300),
                  child: Text(
                    'Stay Healthy',
                    style: GoogleFonts.poppins(
                      color: Color(0xFF0B82D4),
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        nextScreen: OnbordingPage(),
        backgroundColor: Colors.transparent,
        splashIconSize: double.infinity,
        duration: 3500,
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.bottomToTop,
      );
  }
}