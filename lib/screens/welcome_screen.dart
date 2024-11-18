import 'package:flutter/material.dart';
import 'package:pos2_flutter/screens/signin_screen.dart';
import 'package:pos2_flutter/screens/signup_screen.dart';
import 'package:pos2_flutter/widgets/custom_scaffold.dart';
import 'package:pos2_flutter/widgets/welcome_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Container(
        width: double.infinity, // Ensure it fills the screen width
        height: double.infinity, // Ensure it fills the screen height
        decoration: BoxDecoration(),
        child: Column(
          children: [
            Flexible(
              flex: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "images/sss1.png",
                        width: 250, // Adjust width as needed
                        height: 250, // Adjust height as needed
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 20),
                      RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Experience Thai Bliss!\n',
                              style: TextStyle(
                                fontFamily:
                                    'Kanit', // Custom Thai-inspired font
                                fontSize: 28.0,
                                fontWeight: FontWeight.w900,
                                color:
                                    Color.fromARGB(255, 3, 8, 36), // Dark text
                              ),
                            ),
                            TextSpan(
                              text:
                                  '\nJoin us for a delightful dining experience with authentic flavors. Discover the rich culinary heritage of Thailand, crafted with love and tradition.',
                              style: TextStyle(
                                fontFamily:
                                    'Kanit', // Custom Thai-inspired font
                                fontSize: 14,
                                color:
                                    Color.fromARGB(255, 1, 10, 32), // Dark text
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 20.0), // Adjust top padding to move up
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Expanded(
                      child: WelcomeButton(
                        buttonText: 'Sign in',
                        onTap: SignInScreen(),
                        color: Colors.transparent,
                        textColor: Color.fromARGB(255, 3, 21, 59),
                      ),
                    ),
                    Expanded(
                      child: WelcomeButton(
                        buttonText: 'Sign up',
                        onTap: const SignUpScreen(),
                        color: Color.fromARGB(206, 12, 5, 37),
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
