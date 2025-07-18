import 'package:flutter/material.dart';

// lib/screens/settings_screen.dart
// Halaman pengaturan aplikasi
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16), // Padding untuk seluruh konten
        children: [
          // Card untuk informasi aplikasi
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informasi Aplikasi',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  // Baris informasi nama aplikasi
                  _buildInfoRow('Nama Aplikasi', 'Product Manager'),
                  const SizedBox(height: 8),
                  // Baris informasi versi
                  _buildInfoRow('Versi', '1.0.0'),
                  const SizedBox(height: 8),
                  // Baris informasi developer
                  _buildInfoRow('Developer', 'Flutter Team'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Card untuk menu pengaturan
          Card(
            child: Column(
              children: [
                // Menu tentang aplikasi
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('Tentang'),
                  trailing: const Icon(Icons.chevron_right), // Ikon panah kanan
                  onTap: () {
                    // Menampilkan dialog tentang aplikasi
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Tentang Aplikasi'),
                        content: const Text(
                          'Aplikasi sederhana untuk mengelola produk dengan fitur CRUD lengkap.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(context), // Tutup dialog
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const Divider(), // Garis pemisah
                // Menu bantuan
                ListTile(
                  leading: const Icon(Icons.help),
                  title: const Text('Bantuan'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Menampilkan dialog bantuan
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Bantuan'),
                        content: const Text(
                          'Untuk bantuan, silakan hubungi developer melalui email atau GitHub.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget helper untuk membuat baris informasi
  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween, // Ruang di antara label dan value
      children: [
        Text(label), // Label di sebelah kiri
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ), // Value dengan font tebal
        ),
      ],
    );
  }
}
