import 'package:flutter/material.dart';
import 'order_history.dart'; // Add this line if the page is in a separate file
import 'my_address_page.dart'; // Import the MyAddressPage
import 'settings_page.dart'; // Import SettingsPage
import 'account_page.dart';   // Import AccountPage
import 'payment_methods_page.dart'; // Import PaymentMethodsPage

import 'package:pos2_flutter/widgets/support_widget.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? image = "images/siam1.png";
  String? name = "Miranda West";
  String? quote = "Enjoy the taste of Thailand at its finest.";
  bool isPremium = true;
  String _address = "123 Thai Street, Bangkok"; // Default address

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
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
            icon: Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () {
              // Navigate to settings
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ),
        Positioned(
          top: 40,
          left: 20,
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
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
            child: CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage(image!),
              backgroundColor: Colors.white,
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
          name!,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black, // Font color black
          ),
        ),
        const SizedBox(height: 10),
        Text(
          quote!,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        isPremium
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber[700],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Colors.white, size: 16),
                    const SizedBox(width: 5),
                    Text(
                      "Premium Member",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            : SizedBox.shrink(),
      ],
    );
  }

  Widget _buildProfileOptions(BuildContext context) {
    return Column(
      children: [
        _buildProfileOption(
            icon: Icons.location_on_outlined,
            text: "My Address",
            onTap: () async {
              // Navigate to Address Page and wait for the updated address
              final updatedAddress = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyAddressPage()),
              );

              // If an updated address is returned, update the profile address
              if (updatedAddress != null) {
                setState(() {
                  _address = updatedAddress;
                });
              }
            }),
        _buildProfileOption(
            icon: Icons.person_outline,
            text: "Account",
            onTap: () {
              // Navigate to Account Page to edit profile data
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountPage()),
              );
            }),
        _buildProfileOption(
            icon: Icons.notifications_outlined,
            text: "Notifications",
            onTap: () {
              // Show notifications settings as a floating modal
              _showNotificationsDialog(context);
            }),
        _buildProfileOption(
            icon: Icons.payment_outlined,
            text: "Payment Methods",
            onTap: () {
              // Navigate to Payment Methods Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PaymentMethodsPage()),
              );
            }),
        _buildProfileOption(
            icon: Icons.language_outlined,
            text: "Language",
            onTap: () {
              // Show language settings as a floating modal
              _showLanguageDialog(context);
            }),
        _buildProfileOption(
            icon: Icons.history_outlined,
            text: "Order History",
            onTap: () {
              // Navigate to Order History Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrderHistory()),
              );
            }),
      ],
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
              offset: Offset(0, 5),
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
                  style: TextStyle(
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

  Widget _buildLogoutButton() {
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
