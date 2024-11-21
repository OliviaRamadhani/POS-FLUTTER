import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pos2_flutter/widgets/support_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_model.dart';
import '../services/auth_api.dart';
import '../screens/signin_screen.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user; // Data pengguna
  bool isLoading = true; // Indikator loading
  bool isEditing = false;
  File? _selectedPhoto; // Untuk menyimpan foto baru yang dipilih
  final _formKey = GlobalKey<FormState>();

  // Controller untuk input form
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Memuat data pengguna saat halaman dibuka
  }

  Future<void> _loadUserData() async {
  final authApi = AuthApi();
  final fetchedUser = await authApi.getUser();

  if (fetchedUser == null) {
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Gagal memuat data pengguna")),
    );
    return;
  }

  setState(() {
    user = fetchedUser;
    isLoading = false;
    if (user != null) {
      _nameController.text = user?.name ?? '';
      _addressController.text = user?.address ?? '';
      _emailController.text = user?.email ?? '';
      _phoneController.text = user?.phone ?? '';
    }
  });
}


  Future<void> _updateProfile() async {
  if (_formKey.currentState!.validate()) {
    setState(() => isLoading = true);
    final authApi = AuthApi();

    // Cek perubahan
    bool isNameChanged = _nameController.text != (user?.name ?? '');
    bool isEmailChanged = _emailController.text != (user?.email ?? '');
    bool isPhoneChanged = _phoneController.text != (user?.phone ?? '');
    bool isAddressChanged = _addressController.text != (user?.address ?? '');
    bool isPhotoChanged = _selectedPhoto != null;

    if (!isNameChanged && !isEmailChanged && !isPhoneChanged && !isAddressChanged && !isPhotoChanged) {
      setState(() {
        isLoading = false;
        isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tidak ada perubahan yang dilakukan")),
      );
      return;
    }

    // Update data user
    final updatedUser = await authApi.updateUser(
      name: _nameController.text,
      address: _addressController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      photo: _selectedPhoto,
    );

    if (updatedUser != null) {
      setState(() {
        user = updatedUser; // Update data user di state
        isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profil berhasil diperbarui")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal memperbarui profil")),
      );
    }

    setState(() => isLoading = false);
  }
}


  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _selectedPhoto = File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff2f2f2),
        title: Center(
          child: Text(
            "Profile",
            style: AppWidget.boldTextFeildStyle(),
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          if (!isEditing)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.black),
              onPressed: () => setState(() => isEditing = true),
            ),
          
        ],
      ),
      backgroundColor: const Color(0xfff2f2f2),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Loading spinner
          : isEditing
              ? _buildEditForm()
              : _buildProfileView(),
    );
  }

  Widget _buildProfileView() {
  if (user == null) {
    return const Center(child: Text("Data pengguna tidak tersedia"));
  }

  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(60),
            child: Image.network(
              user?.photo ?? 'https://via.placeholder.com/150', // Foto dari API atau placeholder
              height: 150.0,
              width: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),
          _buildProfileCard(icon: Icons.person, label: user?.name ?? 'No Name'),
          const SizedBox(height: 20),
          _buildProfileCard(icon: Icons.email, label: user?.email ?? 'No Email'),
          const SizedBox(height: 20),
          _buildProfileCard(icon: Icons.phone, label: user?.phone ?? 'No Phone'),
          const SizedBox(height: 20),
          _buildProfileCard(icon: Icons.location_on, label: user?.address ?? 'No Address'),
          const SizedBox(height: 20),
          _buildProfileCard(icon: Icons.admin_panel_settings, label: user?.role.fullName ?? 'No Role'),
        ],
      ),
    ),
  );
}

  Widget _buildEditForm() {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              // Menu settings (logout)
              _showLogoutMenu(context);
            },
          ),
      ],
      leading: IconButton(
        icon: const Icon(Icons.close, color: Colors.black),
        onPressed: () => setState(() => isEditing = false),
      ),
      title: Text(
        "Edit Profile",
        style: AppWidget.boldTextFeildStyle(),
      ),
      centerTitle: true,
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Foto profil
              GestureDetector(
                onTap: _pickPhoto,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _selectedPhoto != null
                      ? FileImage(_selectedPhoto!)
                      : user?.photo != null
                          ? NetworkImage(user!.photo!)
                          : null,
                  child: const Icon(Icons.camera_alt, size: 30, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),

              // Input name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (value) => value == null || value.isEmpty ? "Name tidak boleh kosong" : null,
              ),
              const SizedBox(height: 20),

              // Input email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) => value == null || value.isEmpty ? "Email tidak boleh kosong" : null,
              ),
              const SizedBox(height: 20),

              // Input phone
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Phone"),
                validator: (value) => value == null || value.isEmpty ? "Phone tidak boleh kosong" : null,
              ),
              const SizedBox(height: 20),

              // Input address
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: "Address"),
                validator: (value) => value == null || value.isEmpty ? "Address tidak boleh kosong" : null,
              ),
              const SizedBox(height: 20),

              // Tombol simpan
              ElevatedButton(
                onPressed: _updateProfile,
                child: const Text("Simpan"),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildProfileCard({required IconData icon, required String label}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    child: Row(
      children: [
        // Ikon dengan warna biru tua
        Icon(
          icon,
          color: Color.fromARGB(255, 1, 47, 74), // Warna biru tua untuk ikon
          size: 28,
        ),
        const SizedBox(width: 20), // Jarak antar ikon dan teks
        // Teks dengan warna biru tua
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 18,
              color: Color.fromARGB(255, 1, 47, 47), // Warna biru tua untuk teks
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

  // Menu logout
  void _showLogoutMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Apakah Anda yakin ingin logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final authApi = AuthApi();
                await authApi.logout(); // Menghapus token dan data pengguna
                Navigator.of(context).pop(); // Menutup dialog
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Logout berhasil!'),
                  backgroundColor: Colors.green,
                ));
                // Tambahkan logika navigasi ke halaman login jika diperlukan
                Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => SignInScreen(),
                ),
              );
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }
}
