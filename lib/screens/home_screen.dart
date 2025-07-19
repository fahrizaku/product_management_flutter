// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service_product.dart';
import '../widgets/common_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> products = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final fetchedProducts = await ApiService.getProducts();
      setState(() {
        products = fetchedProducts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(onRefresh: loadDashboardData, child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const LoadingWidget(message: 'Memuat dashboard...');
    }

    if (error != null) {
      return CustomErrorWidget(message: error!, onRetry: loadDashboardData);
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selamat Datang!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Kelola produk Anda dengan mudah',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Statistics Cards
          Text('Statistik', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Total Produk',
                  value: products.length.toString(),
                  icon: Icons.shopping_bag,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  title: 'Stok Tersedia',
                  value: products.where((p) => p.stock > 0).length.toString(),
                  icon: Icons.inventory,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: 'Stok Habis',
                  value: products.where((p) => p.stock == 0).length.toString(),
                  icon: Icons.warning,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  title: 'Total Nilai',
                  value: 'Rp ${_calculateTotalValue()}',
                  icon: Icons.attach_money,
                  color: Colors.purple,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Low Stock Alert
          if (_getLowStockProducts().isNotEmpty) ...[
            Text(
              'Peringatan Stok',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Card(
              color: Colors.orange[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning, color: Colors.orange[700]),
                        const SizedBox(width: 8),
                        Text(
                          'Produk dengan Stok Menipis',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ..._getLowStockProducts().map(
                      (product) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          '• ${product.name} (${product.stock} unit)',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Quick Actions - Hanya refresh data
          Text('Aksi Cepat', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Center(
            child: SizedBox(
              width: double.infinity,
              child: _buildActionCard(
                title: 'Refresh Data',
                icon: Icons.refresh,
                onTap: loadDashboardData,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Info untuk navigasi ke produk
          Card(
            color: Colors.blue[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.blue[700]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Untuk melihat dan mengelola produk, gunakan tab "Produk" di bawah.',
                      style: TextStyle(fontSize: 14, color: Colors.blue[700]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 32, color: Colors.blue),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Product> _getLowStockProducts() {
    return products.where((p) => p.stock > 0 && p.stock <= 5).toList();
  }

  String _calculateTotalValue() {
    final total = products.fold<double>(
      0,
      (sum, product) => sum + (product.price * product.stock),
    );
    return total.toStringAsFixed(0);
  }
}
