import 'package:flutter/material.dart';
import 'package:pos2_flutter/services/auth_api.dart';
import 'package:pos2_flutter/screens/signin_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formSignupKey = GlobalKey<FormState>();
  int currentStep = 0;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final AuthApi _authApi = AuthApi();

 Future<void> _register() async {
  if (_formSignupKey.currentState!.validate()) {
    if (_passwordController.text == _confirmPasswordController.text) {
      try {
        await _authApi.register(
          _fullNameController.text,
          _emailController.text,
          _passwordController.text,
          _confirmPasswordController.text,
          _phoneController.text,
          _otpController.text, // OTP dimasukkan setelah diverifikasi
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Successful!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
    }
  }
}


  Future<void> _verifyOtp() async {
    if (_otpController.text.isNotEmpty) {
      try {
        await _authApi.verifyOtp(_emailController.text, _otpController.text);
        setState(() {
          currentStep++;
        });
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _submitPassword() async {
    if (_passwordController.text == _confirmPasswordController.text) {
      try {
        await _authApi.submitPassword(
          _emailController.text,
          _passwordController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign Up Successful!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F6), // Warna background
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
          image: DecorationImage(
          image: AssetImage("images/bgsi.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
          children: [
            const SizedBox(height: 80), // Spasi untuk posisi logo

            const SizedBox(height: 20), // Spasi antara logo dan kontainer
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Stepper(
                  currentStep: currentStep,
                  onStepContinue: () {
                    if (currentStep == 0) {
                      _register();
                    } else if (currentStep == 1) {
                      _verifyOtp();
                    } else if (currentStep == 2) {
                      _submitPassword();
                    }
                  },
                  onStepCancel: currentStep > 0
                      ? () {
                          setState(() {
                            currentStep--;
                          });
                        }
                      : null,
                  steps: [
                    Step(
                      title: const Text('Credentials'),
                      content: Form(
                        key: _formSignupKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _fullNameController,
                              validator: (value) =>
                                  value!.isEmpty ? 'Enter your full name' : null,
                              decoration: const InputDecoration(labelText: 'Full Name'),
                            ),
                            TextFormField(
                              controller: _emailController,
                              validator: (value) =>
                                  value!.isEmpty ? 'Enter your email' : null,
                              decoration: const InputDecoration(labelText: 'Email'),
                            ),
                            TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,  // Menampilkan keyboard numerik
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter your phone number';
                                }
                                if (int.tryParse(value) == null) {
                                  return 'Enter a valid phone number';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(labelText: 'Phone'),
                            )
                          ],
                        ),
                      ),
                    ),
                    Step(
                      title: const Text('Verify Email'),
                      content: TextFormField(
                        controller: _otpController,
                        decoration: const InputDecoration(labelText: 'Enter OTP'),
                      ),
                    ),
                    Step(
                      title: const Text('Set Password'),
                      content: Column(
                        children: [
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(labelText: 'Password'),
                          ),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                                labelText: 'Confirm Password'),
                          ),
                        ],
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
