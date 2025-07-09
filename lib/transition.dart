import 'package:flutter/material.dart';

class Transition {

  void navigatePush(BuildContext context, Widget widget) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => widget,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Define the animation curves and tweens
          const beginScale = 0.8; // Start smaller
          const endScale = 1.0; // End at full size
          const beginRotation = -0.1; // Slight initial rotation (in radians)
          const endRotation = 0.0; // End at no rotation
          const curve = Curves.easeInOutCubic; // Smooth, elegant curve

          // Scale animation
          var scaleTween = Tween<double>(begin: beginScale, end: endScale).chain(CurveTween(curve: curve));
          var scaleAnimation = animation.drive(scaleTween);

          // Rotation animation
          var rotationTween = Tween<double>(begin: beginRotation, end: endRotation).chain(CurveTween(curve: curve));
          var rotationAnimation = animation.drive(rotationTween);

          // Fade animation
          var fadeTween = Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));
          var fadeAnimation = animation.drive(fadeTween);

          return Transform.scale(
            scale: scaleAnimation.value,
            child: Transform.rotate(
              angle: rotationAnimation.value,
              child: FadeTransition(
                opacity: fadeAnimation,
                child: child,
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400), // Slightly longer for effect
        reverseTransitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  void navigatePushReplacement(BuildContext context, Widget widget) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => widget,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Define the animation curves and tweens
          const beginScale = 0.8; // Start smaller
          const endScale = 1.0; // End at full size
          const beginRotation = -0.1; // Slight initial rotation (in radians)
          const endRotation = 0.0; // End at no rotation
          const curve = Curves.easeInOutCubic; // Smooth, elegant curve

          // Scale animation
          var scaleTween = Tween<double>(begin: beginScale, end: endScale)
              .chain(CurveTween(curve: curve));
          var scaleAnimation = animation.drive(scaleTween);

          // Rotation animation
          var rotationTween = Tween<double>(begin: beginRotation, end: endRotation).chain(CurveTween(curve: curve));
          var rotationAnimation = animation.drive(rotationTween);

          // Fade animation
          var fadeTween = Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));
          var fadeAnimation = animation.drive(fadeTween);

          return Transform.scale(
            scale: scaleAnimation.value,
            child: Transform.rotate(
              angle: rotationAnimation.value,
              child: FadeTransition(
                opacity: fadeAnimation,
                child: child,
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400), // Slightly longer for effect
        reverseTransitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }
}