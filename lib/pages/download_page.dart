import 'package:flutter/material.dart';

class DownloadPage extends StatelessWidget {
  const DownloadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Download'),
      ),
      body: const Center(
        child: Text(
          'Halaman Download',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
