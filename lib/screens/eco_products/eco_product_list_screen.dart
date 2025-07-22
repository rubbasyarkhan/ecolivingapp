import 'package:flutter/material.dart';
import '../../models/eco_product.dart';
import '../../services/eco_product_service.dart';
import 'eco_product_detail_screen.dart';

class EcoProductListScreen extends StatefulWidget {
  @override
  _EcoProductListScreenState createState() => _EcoProductListScreenState();
}

class _EcoProductListScreenState extends State<EcoProductListScreen> {
  late Future<List<EcoProduct>> _products;

  @override
  void initState() {
    super.initState();
    _products = EcoProductService().fetchAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Eco-Friendly Products')),
      body: FutureBuilder<List<EcoProduct>>(
        future: _products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());

          if (!snapshot.hasData || snapshot.data!.isEmpty)
            return const Center(child: Text('No products found.'));

          final products = snapshot.data!;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                leading: Image.network(
                  product.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => 
                    const Icon(Icons.broken_image, size: 60),
                ),
                title: Text(product.name),
                subtitle: Text(
                  // Show first 60 chars of longDescription or description as preview
                  product.longDescription.isNotEmpty
                      ? '${product.longDescription.substring(0, product.longDescription.length > 60 ? 60 : product.longDescription.length)}...'
                      : product.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EcoProductDetailScreen(product: product),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
