import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductDetailScreen extends StatelessWidget {
  final dynamic product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product['name'])),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: product['images'].length,
              itemBuilder: (ctx, index) => CachedNetworkImage(
                imageUrl: product['images'][index],
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('\$${product['price']}', 
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Text(product['description'],
                  style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                if (product['quantity'] <= 0)
                  const Text('OUT OF STOCK',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
