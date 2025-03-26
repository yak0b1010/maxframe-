import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _categories = ['laptops', 'pc', 'monitors', 'accessories'];
  String _selectedCategory = 'laptops';
  final List<Map<String, dynamic>> _cart = [];
  int _cartCount = 0;

  @override
  Widget build(BuildContext context) {
    final isAdmin = Provider.of<AuthService>(context).isAdmin;
    return Scaffold(
      backgroundColor: Color(0xFF1E1E1E), // dgray
      appBar: AppBar(
        title: Text(
          'Welcome',
          style: TextStyle(fontFamily: 'DGT', fontWeight: FontWeight.normal),
        ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255), // dgray
        actions: [
          if (!isAdmin)
            Stack(
              children: [
                IconButton(
                  icon: Image.asset('lib/image/cart.png'), // Updated cart icon
                  onPressed: _showCart,
                ),
                if (_cartCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.green, // Changed red to green
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        '$_cartCount',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
              ],
            ),
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              onPressed: () => _showAddProductDialog(context),
            ),
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF1E1E1E)),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (!isAdmin) _buildSlideCards(),
            if (!isAdmin) SizedBox(height: 20),
            _buildCategoriesSection(),
            _buildProductList(), // Removed the `if (!isAdmin)` condition
          ],
        ),
      ),
    );
  }

  Widget _buildSlideCards() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1826, // 176 / 956
      width: MediaQuery.of(context).size.width * 0.8864, // 386 / 440
      margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.0364), // 16 / 440
      child: PageView.builder(
        itemCount: 3, // Example: 3 slides
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(20),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoriesSection() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.05),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCategorySquare('laptops', 'lib/image/laptop.png', screenWidth, screenHeight),
              _buildCategorySquare('pc', 'lib/image/pc.png', screenWidth, screenHeight),
            ],
          ),
          SizedBox(height: screenHeight * 0.0439), // 42 / 956
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCategorySquare('monitors', 'lib/image/monitor.png', screenWidth, screenHeight),
              _buildAccessoriesSquare(screenWidth, screenHeight),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySquare(String category, String imagePath, double screenWidth, double screenHeight) {
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = category),
      child: Column(
        children: [
          Container(
            width: screenWidth * 0.3864, // 170 / 440
            height: screenHeight * 0.1787, // 170 / 956
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255), // gray
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Image.asset(
                imagePath,
                width: screenWidth * 0.3, // Adjust image size
                height: screenHeight * 0.1,
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.01), // 10 / 956
          Text(
            category.toUpperCase(),
            style: TextStyle(
              fontSize: screenWidth * 0.0364, // 16 / 440
              fontWeight: FontWeight.normal,
              fontFamily: 'DGT',
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccessoriesSquare(double screenWidth, double screenHeight) {
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = 'accessories'),
      child: Column(
        children: [
          Container(
            width: screenWidth * 0.3864, // 170 / 440
            height: screenHeight * 0.1787, // 170 / 956
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255), // gray
              borderRadius: BorderRadius.circular(15),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: screenWidth * 0.0182, // 8 / 440
                  top: screenHeight * 0.08, // 18 / 956
                  child: Image.asset(
                    'lib/image/acss1.png',
                    width: screenWidth * 0.3, // Adjust image size
                    height: screenHeight * 0.1,
                  ),
                ),
                Positioned(
                  right: screenWidth * 0.00111, // 12 / 440
                  bottom: screenHeight * 0.09, // 28 / 956
                  child: Image.asset(
                    'lib/image/ascc2.png',
                    width: screenWidth * 0.25, // Adjust image size
                    height: screenHeight * 0.07,
                  ),
                ),
                Positioned(
                  left: screenWidth * 0.012, // 16 / 440
                  bottom: screenHeight * 0.09, // 36 / 956
                  child: Image.asset(
                    'lib/image/acss3.png',
                    width: screenWidth * 0.2, // Adjust image size
                    height: screenHeight * 0.07,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.01), // 10 / 956
          Text(
            'ACCESSORIES',
            style: TextStyle(
              fontSize: screenWidth * 0.0364, // 16 / 440
              fontWeight: FontWeight.normal,
              fontFamily: 'DGT',
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .where('category', isEqualTo: _selectedCategory)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
          ),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (ctx, index) => _buildProductCard(snapshot.data!.docs[index]),
        );
      },
    );
  }

  Widget _buildProductCard(DocumentSnapshot doc) {
    final product = doc.data() as Map<String, dynamic>;
    final isAdmin = Provider.of<AuthService>(context, listen: false).isAdmin;
    final int quantity = product['quantity'] ?? 0;
    return Card(
      child: InkWell(
        onTap: () => _showProductDetails(product),
        child: Column(
          children: [
            Expanded(
              child: Image.network(
                product['images'][0],
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('\$${product['price']}'),
                  Row(
                    children: [
                      if (!isAdmin)
                        IconButton(
                          icon: const Icon(Icons.add_shopping_cart),
                          onPressed: quantity > 0 ? () => _addToCart(product) : null,
                        ),
                      if (isAdmin)
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showEditProductDialog(doc.id, product),
                        ),
                      if (isAdmin)
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteProduct(doc.id),
                        ),
                    ],
                  ),
                  if (quantity <= 0)
                    const Text('Not Available', style: TextStyle(color: Colors.red)),
                  Text('Quantity: $quantity'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      _cart.add(product);
      _cartCount++;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added ${product['name']} to cart')),
    );
  }

  void _showCart() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Your Cart'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _cart.length,
            itemBuilder: (ctx, index) {
              final product = _cart[index];
              return ListTile(
                leading: Image.network(
                  product['images'][0],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(product['name']),
                subtitle: Text('\$${product['price']}'),
                trailing: IconButton(
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () => _removeFromCart(index),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () => _fakeCheckout(context),
            child: const Text('Checkout'),
          ),
        ],
      ),
    );
  }

  void _removeFromCart(int index) {
    setState(() {
      _cart.removeAt(index);
      _cartCount--;
    });
  }

  void _fakeCheckout(BuildContext context) async {
    final user = Provider.of<AuthService>(context, listen: false).currentUser;
    if (user == null) return;
    await FirebaseFirestore.instance.collection('orders').add({
      'userId': user.uid,
      'items': _cart.map((p) => p['name']).toList(),
      'total': _cart.fold(0.0, (sum, p) => sum + (p['price'] as double)),
      'timestamp': FieldValue.serverTimestamp(),
    });
    setState(() {
      _cart.clear();
      _cartCount = 0;
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order placed successfully!')),
    );
  }

  Future<void> _deleteProduct(String productId) async {
    try {
      await FirebaseFirestore.instance.collection('products').doc(productId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting product: ${e.toString()}')),
      );
    }
  }

  void _showProductDetails(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 300,
              child: PageView.builder(
                itemCount: product['images'].length,
                itemBuilder: (ctx, index) => Image.network(
                  product['images'][index],
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product['name'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('\$${product['price']}', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 16),
                  Text(product['description']),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _priceController = TextEditingController();
    final TextEditingController _imageController = TextEditingController();
    final TextEditingController _categoryController = TextEditingController();
    final TextEditingController _descriptionController = TextEditingController();
    final TextEditingController _quantityController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Product'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
              TextField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final name = _nameController.text.trim();
                final price = double.parse(_priceController.text.trim());
                final imageUrl = _imageController.text.trim();
                final category = _categoryController.text.trim();
                final description = _descriptionController.text.trim();
                final quantity = int.parse(_quantityController.text.trim());
                if (name.isEmpty || price <= 0 || imageUrl.isEmpty || category.isEmpty || description.isEmpty || quantity < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields with valid data')),
                  );
                  return;
                }
                await FirebaseFirestore.instance.collection('products').add({
                  'name': name,
                  'price': price,
                  'images': [imageUrl],
                  'category': category,
                  'description': description,
                  'quantity': quantity,
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Product added successfully')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error adding product: ${e.toString()}')),
                );
              }
            },
            child: const Text('Add Product'),
          ),
        ],
      ),
    );
  }

  void _showEditProductDialog(String productId, Map<String, dynamic> product) {
    final TextEditingController _nameController = TextEditingController(text: product['name']);
    final TextEditingController _priceController = TextEditingController(text: product['price'].toString());
    final TextEditingController _imageController = TextEditingController(text: product['images'][0]);
    final TextEditingController _categoryController = TextEditingController(text: product['category']);
    final TextEditingController _descriptionController = TextEditingController(text: product['description']);
    final TextEditingController _quantityController = TextEditingController(text: product['quantity'].toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Product'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
              TextField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final name = _nameController.text.trim();
                final price = double.parse(_priceController.text.trim());
                final imageUrl = _imageController.text.trim();
                final category = _categoryController.text.trim();
                final description = _descriptionController.text.trim();
                final quantity = int.parse(_quantityController.text.trim());
                if (name.isEmpty || price <= 0 || imageUrl.isEmpty || category.isEmpty || description.isEmpty || quantity < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields with valid data')),
                  );
                  return;
                }
                await FirebaseFirestore.instance.collection('products').doc(productId).update({
                  'name': name,
                  'price': price,
                  'images': [imageUrl],
                  'category': category,
                  'description': description,
                  'quantity': quantity,
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Product updated successfully')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error updating product: ${e.toString()}')),
                );
              }
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) {
    Provider.of<AuthService>(context, listen: false).logout();
  }
}