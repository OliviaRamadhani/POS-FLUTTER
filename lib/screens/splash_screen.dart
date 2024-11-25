import 'package:flutter/material.dart';
import 'package:pos2_flutter/screens/bottomnav.dart'; // Import the welcome screen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 5), // Splash screen duration
      vsync: this,
    );

    // Animation for fading in
    _fadeAnimation = Tween<double>(begin: 0, end: 4).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    // Animation for scaling (zoom effect)
    _scaleAnimation = Tween<double>(begin: 0.5, end: 4).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Start the animation
    _animationController.forward();

    // Navigate to the Welcome Screen after 3 seconds
    _navigateToWelcome();
  }

  void _navigateToWelcome() async {
    await Future.delayed(const Duration(seconds: 3)); // Duration of the splash screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const BottomNav()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color for splash screen
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "images/sss1.png", // Your splash screen logo
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Loading...",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose(); // Dispose animation controller
    super.dispose();
  }
}
