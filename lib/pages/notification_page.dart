import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
      ),
      body: const Center(
        child: Text(
          'Halaman Notifikasi',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
