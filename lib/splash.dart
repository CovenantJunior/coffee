import 'package:coffee/order.dart';
import 'package:coffee/transition.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LottieBuilder.asset(
        'lottie/splash.json',
        width: 200,
        height: 200,
        fit: BoxFit.fill,
        onLoaded: (composition) {
          final controller = AnimationController(
            vsync: NavigatorState(),
            duration: composition.duration,
          );
          controller.addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              Transition().navigatePushReplacement(context, const CoffeeOrderScreen());
            }
          });
          controller.forward();
        },
      ),
    );
  }
}