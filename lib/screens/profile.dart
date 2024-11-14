import 'package:flutter/material.dart';
import 'package:pos2_flutter/widgets/support_widget.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? image = "images/siam1.png"; // Contoh gambar profil
  String? name = "Users"; // Nama pengguna
  String? email = "siamspice@gmail.com"; // Email pengguna
  String? phone = "081332846699"; // Nomor Telepon
  String? birthdate = "01 Januari 1990"; // Tanggal Lahir
  String? accountStatus = "Premium"; // Status akun
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff2f2f2),
        title: Center(
          child: Text(
            "Profile",
            style: AppWidget.boldTextFeildStyle(),
          ),
        ),
        automaticallyImplyLeading: false, // Optional: If you want to remove the back button
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.black),  // Icon pengaturan
            onPressed: () {
              // Tampilkan menu untuk logout atau hapus akun
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('More Settings'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.exit_to_app),
                          title: Text("Logout"),
                          onTap: () {
                            // Logic logout
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Logout berhasil!'),
                              backgroundColor: Colors.green,
                            ));
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.delete),
                          title: Text("Hapus Akun"),
                          onTap: () {
                            // Logic hapus akun
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Konfirmasi'),
                                  content: Text('Apakah Anda yakin ingin menghapus akun?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text('Akun berhasil dihapus!'),
                                          backgroundColor: Colors.red,
                                        ));
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Hapus'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      backgroundColor: Color(0xfff2f2f2),
      body: SingleChildScrollView(  // Membuat konten scrollable
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profil Picture
                ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.asset(
                    image!,
                    height: 150.0,
                    width: 150.0,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 20),

                // Name
                Card(
                  elevation: 5,
                  shadowColor: Colors.black45,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: [Colors.purple, Colors.deepPurpleAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person, color: Colors.white, size: 28),  // Add icon
                            SizedBox(width: 10),
                            Text(
                              name!,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Email
                Card(
                  elevation: 5,
                  shadowColor: Colors.black45,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: [Colors.purple, Colors.deepPurpleAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.email, color: Colors.white, size: 28),
                            SizedBox(width: 10),
                            Text(
                              email!,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Phone Number
                Card(
                  elevation: 5,
                  shadowColor: Colors.black45,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: [Colors.purple, Colors.deepPurpleAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.phone, color: Colors.white, size: 28),
                            SizedBox(width: 10),
                            Text(
                              phone!,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Checkout History
                  Card(
                    elevation: 5,
                    shadowColor: Colors.black45,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          colors: [Colors.purple, Colors.deepPurpleAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.history, color: Colors.white, size: 20), // Ikon riwayat
                              SizedBox(width: 10),
                              Text(
                                "Riwayat Checkout", // Teks Riwayat Checkout
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                SizedBox(height: 20),

                // Additional Settings Menu with Background
                Container(
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Icon(Icons.help, color: Colors.deepPurpleAccent),
                        title: Text('Pusat Bantuan'),
                        onTap: () {
                          // Action for Pusat Bantuan
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.description, color: Colors.deepPurpleAccent),
                        title: Text('Syarat & Ketentuan'),
                        onTap: () {
                          // Action for Syarat & Ketentuan
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.payment, color: Colors.deepPurpleAccent),
                        title: Text('SmartPay'),
                        onTap: () {
                          // Action for SmartPay
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.notifications, color: Colors.deepPurpleAccent),
                        title: Text('Pengaturan Notifikasi'),
                        onTap: () {
                          // Action for Pengaturan Notifikasi
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
