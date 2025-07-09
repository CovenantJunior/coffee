import 'package:coffee/order.dart';
import 'package:coffee/transition.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {

  late AnimationController lottieController;
  late Animation<double> lottieFadeAnimation;
  
  @override
  void initState() {
    super.initState();
    // Initialize the Lottie controller
    lottieController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3)
    );
    lottieFadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: lottieController,
        curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
      ),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      lottieController.forward().whenComplete(() {
        Transition().navigatePushReplacement(context, const CoffeeOrderScreen());
      });
    });
  }
  
  @override
  void dispose() {
    super.dispose();
    lottieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: lottieFadeAnimation,
          child: Lottie.asset(
            'lotties/splash.json',
            height: 200,
            controller: lottieController,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.low,
            onLoaded: (composition) {
              lottieController.duration = composition.duration;
            },
          ),
        ),
      ),
    );
  }
}