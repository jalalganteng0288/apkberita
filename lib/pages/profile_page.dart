import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Widget buildInfoTile(IconData icon, String title, String subtitle, Color iconColor) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: Text(
          'informasi akun',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 10),
          Text(
            'Profil',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Info pengguna
          buildInfoTile(Icons.person, 'Nama Akun', 'Nama pengguna kamu', Colors.blue),
          buildInfoTile(Icons.location_on, 'Alamat', 'Kota atau lokasi kamu', Colors.green),
          buildInfoTile(Icons.cake, 'Tanggal Lahir', '01 Januari 2000', Colors.pink),
          buildInfoTile(Icons.wc, 'Jenis Kelamin', 'Laki-laki / Perempuan', Colors.purple),
          buildInfoTile(Icons.group, 'Grup Favorit', 'Berita Islami, Olahraga, Nasional', Colors.orange),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
