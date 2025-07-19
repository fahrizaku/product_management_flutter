// lib/screens/product_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service_product.dart';
import 'product_form_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Product currentProduct;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    currentProduct = widget.product;
  }

  Future<void> refreshProduct() async {
    setState(() => isLoading = true);

    try {
      final updatedProduct = await ApiService.getProduct(currentProduct.id!);
      if (mounted) {
        setState(() {
          currentProduct = updatedProduct;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal memuat produk: $e')));
      }
    }
  }

  Future<void> deleteProduct() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: Text(
          'Apakah Anda yakin ingin menghapus produk "${currentProduct.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      try {
        await ApiService.deleteProduct(currentProduct.id!);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Produk berhasil dihapus')),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Gagal menghapus produk: $e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentProduct.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProductFormScreen(product: currentProduct),
                ),
              );
              if (result == true && mounted) {
                refreshProduct();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: deleteProduct,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refreshProduct,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Info Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informasi Produk',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    icon: Icons.shopping_bag,
                    label: 'Nama Produk',
                    value: currentProduct.name,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    icon: Icons.attach_money,
                    label: 'Harga',
                    value: 'Rp ${currentProduct.price.toStringAsFixed(0)}',
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    icon: Icons.inventory,
                    label: 'Stok',
                    value: '${currentProduct.stock} unit',
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Status Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Status', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: currentProduct.stock > 0
                              ? Colors.green
                              : Colors.red,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          currentProduct.stock > 0 ? 'Tersedia' : 'Habis',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (currentProduct.stock <= 5 && currentProduct.stock > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'Stok Menipis',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Timestamps Card
          if (currentProduct.createdAt != null ||
              currentProduct.updatedAt != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Riwayat',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    if (currentProduct.createdAt != null)
                      _buildInfoRow(
                        icon: Icons.calendar_today,
                        label: 'Dibuat',
                        value: _formatDateTime(currentProduct.createdAt!),
                      ),
                    if (currentProduct.updatedAt != null) ...[
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        icon: Icons.update,
                        label: 'Terakhir Diperbarui',
                        value: _formatDateTime(currentProduct.updatedAt!),
                      ),
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
