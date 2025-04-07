import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:maxframe/product_detail_screen.dart';

class HotScreen extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  const HotScreen({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    // Sort products by checkoutCount in descending order
    final hotProducts = List<Map<String, dynamic>>.from(products)
      ..sort((a, b) => b['checkoutCount'].compareTo(a['checkoutCount']));

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E), // Set the background color here
      appBar: AppBar(
        title: const Text(
          'Hot Products',
          style: TextStyle(
            fontFamily: 'DGT',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.lime, // Lime green background
        centerTitle: true,
        elevation: 4, // Add a subtle shadow for depth
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (hotProducts.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_fire_department, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(
                        'No Hot Products Yet',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey, // Change the text color here
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (hotProducts.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: hotProducts.length,
                itemBuilder: (context, index) {
                  final product = hotProducts[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: InkWell(
                      onTap: () {
                        // Navigate to product details screen (optional)
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailScreen(product: product),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: product['images'][0],
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const CircularProgressIndicator(),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product['name'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'DGT',
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '\$${product['price']}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'DGT',
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Purchases: ${product['checkoutCount']}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'DGT',
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}