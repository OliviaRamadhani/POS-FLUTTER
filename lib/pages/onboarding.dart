import 'package:flutter/material.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _imageOpacity;
  late Animation<double> _textOpacity;
  late Animation<double> _buttonScale;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Animations for image opacity, text opacity, and button scale
    _imageOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Interval(0.5, 1.0, curve: Curves.easeInOut)),
    );

    _buttonScale = Tween<double>(begin: 0.5, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    // Start the animations
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 234, 235, 231),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: FadeTransition(
                opacity: _imageOpacity,
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: Image.asset("images/sss1.png", fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              flex: 2,
              child: FadeTransition(
                opacity: _textOpacity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Explore\nThe Best\nThailand Food And Drinks",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Discover delicious food and drinks from Thailand that will make your taste buds dance.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Expanded(
              flex: 1,
              child: ScaleTransition(
                scale: _buttonScale,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10), // Reduced padding for a smaller button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Slightly rounded corners
                  ),
                  backgroundColor: const Color.fromARGB(255, 35, 42, 134),
                  shadowColor: Colors.black.withOpacity(0.4),
                  elevation: 8,
                ),
                onPressed: () {
                  // Add navigation or action here
                },
                child: Text(
                  "Get Started",
                  style: TextStyle(fontSize: 22, color: Colors.white), // Reduced font size
                ),
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }
}
