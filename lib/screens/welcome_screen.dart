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
                        width: 300, // Adjust width as needed
                        height: 300, // Adjust height as needed
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
                                fontSize: 30.0,
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 3, 8,
                                    36), // White text for contrast on dark background
                              ),
                            ),
                            TextSpan(
                              text:
                                  '\nJoin us for a delightful dining experience with authentic flavors. Discover the rich culinary heritage of Thailand, crafted with love and tradition.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 1, 10,
                                    32), // White text for readability
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Expanded(
                    child: WelcomeButton(
                      buttonText: 'Sign in',
                      onTap: SignInScreen(),
                      color: Colors.transparent,
                      textColor: Colors.black,
                    ),
                  ),
                  Expanded(
                    child: WelcomeButton(
                      buttonText: 'Sign up',
                      onTap: const SignUpScreen(),
                      color: const Color.fromARGB(255, 33, 37, 70),
                      textColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
