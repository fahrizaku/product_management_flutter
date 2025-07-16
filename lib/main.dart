// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/home_screen.dart';
import 'screens/product_list_screen.dart';

// Fungsi utama aplikasi yang dijalankan pertama kali
Future<void> main() async {
  // Memastikan widget binding sudah diinisialisasi sebelum menjalankan app
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Memuat file .env untuk konfigurasi environment
    await dotenv.load();
  } catch (e) {
    // Menangani error saat memuat .env secara diam-diam
    // Aplikasi tetap berjalan meskipun .env tidak ditemukan
  }

  // Menjalankan aplikasi Flutter
  runApp(const MyApp());
}

// Widget utama aplikasi yang merupakan StatelessWidget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Manager', // Judul aplikasi
      debugShowCheckedModeBanner: false, // Menyembunyikan banner debug
      theme: ThemeData(
        // Mengatur skema warna aplikasi dengan warna dasar biru
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true, // Menggunakan Material Design 3
        // Tema untuk AppBar
        appBarTheme: const AppBarTheme(
          centerTitle: true, // Judul ditengah
          elevation: 0, // Tanpa bayangan
        ),

        // Tema untuk Card widget
        cardTheme: const CardThemeData(
          elevation: 2, // Ketinggian bayangan
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ), // Sudut melengkung
          ),
        ),

        // Tema untuk input field
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),

        // Tema untuk elevated button
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ),
      ),
      home: const MainScreen(), // Halaman utama aplikasi
    );
  }
}

// Widget untuk layar utama dengan bottom navigation
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Index halaman yang sedang aktif

  // Daftar halaman yang akan ditampilkan
  final List<Widget> _pages = const [
    HomeScreen(), // Halaman dashboard
    ProductListScreen(), // Halaman daftar produk
    SettingsScreen(), // Halaman pengaturan
  ];

  // Fungsi untuk menangani tap pada bottom navigation
  void _onNavTapped(int index) {
    setState(() {
      _selectedIndex = index; // Mengubah halaman aktif
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          // Menampilkan judul sesuai halaman yang aktif
          _selectedIndex == 0
              ? 'Dashboard'
              : _selectedIndex == 1
              ? 'Produk'
              : 'Pengaturan',
        ),
      ),
      body: _pages[_selectedIndex], // Menampilkan halaman sesuai index
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // Index yang sedang aktif
        onTap: _onNavTapped, // Callback saat item di-tap
        selectedItemColor: Colors.blue, // Warna item yang dipilih
        unselectedItemColor: Colors.grey, // Warna item yang tidak dipilih
        items: const [
          // Item navigation untuk dashboard
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          // Item navigation untuk produk
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Produk'),
          // Item navigation untuk pengaturan
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}

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
