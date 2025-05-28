import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Pengaturan Akun',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),

        const ListTile(
          leading: Icon(Icons.person),
          title: Text('Nama Akun'),
          subtitle: Text('Nama pengguna kamu'),
        ),
        const ListTile(
          leading: Icon(Icons.location_on),
          title: Text('Alamat'),
          subtitle: Text('Kota atau lokasi kamu'),
        ),
        const ListTile(
          leading: Icon(Icons.cake),
          title: Text('Tanggal Lahir'),
          subtitle: Text('01 Januari 2000'),
        ),
        const ListTile(
          leading: Icon(Icons.wc),
          title: Text('Jenis Kelamin'),
          subtitle: Text('Laki-laki / Perempuan'),
        ),
        const ListTile(
          leading: Icon(Icons.group),
          title: Text('Grup Favorit'),
          subtitle: Text('Berita Islami, Olahraga, Nasional'),
        ),

        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: () => _logout(context),
          icon: const Icon(Icons.logout),
          label: const Text('Keluar / Logout'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
