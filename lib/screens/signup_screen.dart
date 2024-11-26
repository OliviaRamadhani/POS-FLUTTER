import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:pos2_flutter/services/auth_api.dart'; // Impor AuthApi
import 'package:pos2_flutter/screens/signin_screen.dart';
import 'package:pos2_flutter/theme/theme.dart';
import 'package:pos2_flutter/models/user_model.dart'; // Impor model User

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formSignupKey = GlobalKey<FormState>();
  bool agreePersonalData = true;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController = TextEditingController(); // Controller untuk konfirmasi password
  final TextEditingController _addressController = TextEditingController();  // Controller untuk alamat
  final TextEditingController _phoneController = TextEditingController();     // Controller untuk nomor telepon

  // Fungsi untuk sign up
  Future<void> signUp() async {
    if (_formSignupKey.currentState!.validate() && agreePersonalData) {
      try {
        final authApi = AuthApi();
        final User? user = await authApi.register(
          _fullNameController.text,
          _emailController.text,
          _passwordController.text,
          _addressController.text,
          _phoneController.text,
          _passwordConfirmationController.text, // Kirim konfirmasi password
        );

        if (user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sign Up Successful!')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SignInScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sign Up Failed!')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else if (!agreePersonalData) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the processing of personal data'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            const Expanded(flex: 1, child: SizedBox(height: 10)),
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formSignupKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "images/bgg.png",
                          height: 200,
                          width: 300,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 1.0),
                        const SizedBox(height: 1.0),
                        // Full Name TextField
                        TextFormField(
                          controller: _fullNameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Full name';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: const Text('Full Name'),
                            hintText: 'Enter Full Name',
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        // Email TextField
                        TextFormField(
                          controller: _emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Email';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: const Text('Email'),
                            hintText: 'Enter Email',
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        // Password TextField
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          obscuringCharacter: '*',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Password';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: const Text('Password'),
                            hintText: 'Enter Password',
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        // Confirm Password TextField
                        TextFormField(
                          controller: _passwordConfirmationController,
                          obscureText: true,
                          obscuringCharacter: '*',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: const Text('Confirm Password'),
                            hintText: 'Re-enter Password',
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        // Address TextField
                        TextFormField(
                          controller: _addressController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your address';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: const Text('Address'),
                            hintText: 'Enter Address',
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        // Phone Number TextField
                        TextFormField(
                          controller: _phoneController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: const Text('Phone Number'),
                            hintText: 'Enter Phone Number',
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        // Agree to processing personal data
                        Row(
                          children: [
                            Checkbox(
                              value: agreePersonalData,
                              onChanged: (bool? value) {
                                setState(() {
                                  agreePersonalData = value!;
                                });
                              },
                              activeColor: lightColorScheme.primary,
                            ),
                            const Text(
                              'I agree to the processing of ',
                              style: TextStyle(color: Colors.black45),
                            ),
                            Text(
                              'Personal data',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: lightColorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25.0),
                        const SizedBox(height: 25.0),
                        // Sign up button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: signUp,
                            child: const Text('Sign up'),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                      ],
                    ),
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
