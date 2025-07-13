// lib/utils/constants.dart
class AppConstants {
  // API Configuration
  static const String defaultBaseUrl = 'http://localhost:3000';
  static const String apiPath = '/api';
  static const String productsEndpoint = '/products';

  // App Information
  static const String appName = 'Product Manager';
  static const String appVersion = '1.0.0';
  static const String developer = 'Flutter Team';

  // Validation
  static const int maxProductNameLength = 100;
  static const double maxPrice = 999999999.99;
  static const int maxStock = 999999;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double cardBorderRadius = 12.0;
  static const double buttonBorderRadius = 8.0;

  // Stock Thresholds
  static const int lowStockThreshold = 5;
  static const int outOfStockThreshold = 0;
}

class ApiResponseMessages {
  static const String networkError =
      'Gagal terhubung ke server. Periksa koneksi internet Anda.';
  static const String serverError =
      'Terjadi kesalahan pada server. Silakan coba lagi nanti.';
  static const String notFoundError = 'Data tidak ditemukan.';
  static const String validationError = 'Data yang dimasukkan tidak valid.';
  static const String unknownError = 'Terjadi kesalahan yang tidak diketahui.';
}

class ValidationMessages {
  static const String nameRequired = 'Nama produk tidak boleh kosong';
  static const String nameMaxLength = 'Nama produk maksimal 100 karakter';
  static const String priceRequired = 'Harga tidak boleh kosong';
  static const String priceInvalid = 'Harga harus berupa angka positif';
  static const String stockRequired = 'Stok tidak boleh kosong';
  static const String stockInvalid = 'Stok harus berupa angka non-negatif';
}
