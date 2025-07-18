// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/home_screen.dart';
import 'screens/product_list_screen.dart';
import 'screens/settings_screen.dart';

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
          backgroundColor: Colors.blue, // Ganti warna latar
          foregroundColor: Colors.white, // Ganti warna teks/icon
          centerTitle: false, // Judul ditengah
          elevation: 0, // Tanpa bayangan
        ),

        // Tema untuk Card widget
        cardTheme: const CardThemeData(
          elevation: 2, // Ketinggian bayangan
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
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
