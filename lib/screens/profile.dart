import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/auth_api.dart'; // Import AuthApi
import 'order_history.dart';
import 'my_address_page.dart';
import 'settings_page.dart';
import 'account_page.dart';
import 'payment_methods_page.dart';
import 'package:pos2_flutter/screens/welcome_screen.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user; // Data user akan disimpan di sini
  bool isLoading = true; // Indikator loading saat data dimuat
  final AuthApi authApi = AuthApi(); // Instance AuthApi untuk pengambilan data

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token'); // Ambil token dari SharedPreferences

    if (token != null) {
      final fetchedUser = await authApi.getUser(token); // Panggil API untuk mendapatkan data user
      if (fetchedUser != null) {
        setState(() {
          user = fetchedUser;
          isLoading = false;
        });
      } else {
        // Jika token tidak valid atau API gagal
        setState(() {
          isLoading = false;
        });
      }
    } else {
      // Jika tidak ada token
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Tampilkan loading spinner
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildUserInfo(),
                  const SizedBox(height: 20),
                  _buildProfileOptions(context),
                  const SizedBox(height: 20),
                  _buildLogoutButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
  return Stack(
    children: [
      Image.asset(
        "images/bgfp.png", // Background image path
        height: 300,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
      Positioned(
        top: 40,
        right: 20,
        child: IconButton(
          icon: const Icon(Icons.settings_outlined, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          },
        ),
      ),
      Positioned(
        top: 40,
        left: 20,
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      Positioned(
        bottom: 40,
        left: 0,
        right: 0,
        child: Center(
          child: GestureDetector(
            onTap: () {
              // Aksi yang akan dilakukan saat gambar profil diketuk
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountPage()),
              );
            },
            child: CircleAvatar(
              radius: 80,
              backgroundImage: user?.photo != null
                  ? NetworkImage(user!.photo!)
                  : const AssetImage("images/siam1.png") as ImageProvider,
              backgroundColor: Colors.white,
            ),
          ),
        ),
      ),
    ],
  );
}


  Widget _buildUserInfo() {
    return Column(
      children: [
        Text(
          user?.name ?? "Guest User",
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          user?.email ?? "No Email Available",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileOptions(BuildContext context) {
    return Column(
      children: [
        _buildProfileOption(
          icon: Icons.location_on_outlined,
          text: "My Address",
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyAddressPage()),
          ),
        ),
        _buildProfileOption(
          icon: Icons.person_outline,
          text: "Account",
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AccountPage()),
          ),
        ),
        _buildProfileOption(
          icon: Icons.history_outlined,
          text: "Order History",
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OrderHistory()),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: () {
        // Logout action
        SharedPreferences.getInstance().then((prefs) {
          prefs.clear(); // Hapus semua data dari SharedPreferences
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          );
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.redAccent.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            "Logout",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.black),
                const SizedBox(width: 20),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
          ],
        ),
      ),
    );
  }

Widget _buildLogoutButtoConfirm() {
  return GestureDetector(
    onTap: () {
      // Logout action
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Logout'),
            content: Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Add logout action here

                  // Navigate to WelcomeScreen after logging out
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WelcomeScreen(), // Navigate to WelcomeScreen
                    ),
                  );
                },
                child: Text('Logout'),
              ),
            ],
          );
        },
      );
    },
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.redAccent.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Text(
          "Logout",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}


  // Show Notifications Settings as a Floating Dialog
  void _showNotificationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Notifications Settings",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                ListTile(
                  title: Text("Enable Notifications"),
                  trailing: Switch(value: true, onChanged: (value) {}),
                ),
                ListTile(
                  title: Text("Push Notifications"),
                  trailing: Switch(value: true, onChanged: (value) {}),
                ),
                ListTile(
                  title: Text("Email Notifications"),
                  trailing: Switch(value: false, onChanged: (value) {}),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Show Language Settings as a Floating Dialog
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Language Settings",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                ListTile(
                  title: Text("English"),
                  trailing: Radio(value: 1, groupValue: 1, onChanged: (value) {}),
                ),
                ListTile(
                  title: Text("Thai"),
                  trailing: Radio(value: 2, groupValue: 1, onChanged: (value) {}),
                ),
                ListTile(
                  title: Text("Spanish"),
                  trailing: Radio(value: 3, groupValue: 1, onChanged: (value) {}),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
