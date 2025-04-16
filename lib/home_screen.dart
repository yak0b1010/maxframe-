import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:maxframe/wishlist_screen.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'about_us_screen.dart';
import 'auth_service.dart';
import 'card_screen.dart';
import 'hot_screen.dart';
import 'order_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _wishlist = []; // List to store wishlist product names
  final List<String> _categories = ['laptops', 'pc', 'monitors', 'accessories'];
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String _selectedCategory = 'laptops';
  final List<Map<String, dynamic>> _orders = [];
  final List<Map<String, dynamic>> _cart = [];
  int _cartCount = 0;
  @override
  Widget build(BuildContext context) {
    final isAdmin = Provider.of<AuthService>(context).isAdmin;
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E), // Dark gray background

      appBar: AppBar(
        title: Text(
          isAdmin ? 'Admin Panel' : 'Welcome',
          style: const TextStyle(
            fontFamily: 'DGT',
            fontWeight: FontWeight.normal,
            color: Colors.black, // Black text for contrast
          ),
        ),
        backgroundColor: Colors.lime, // Lime green background
        centerTitle: true, // Center-align the title for better aesthetics
        elevation: 4, // Add a subtle shadow for depth

        actions: [
          if (!isAdmin)
            Stack(
              alignment: Alignment.center, // Align stack items properly
              children: [
                IconButton(
                  icon: Image.asset('lib/image/cart.png'), // Updated cart icon
                  onPressed: _showCart,
                  tooltip: 'View Cart', // Tooltip for accessibility
                ),
                if (_cartCount > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(6), // Increased padding for visibility
                      decoration: BoxDecoration(
                        color: Colors.red, // Red background for urgency
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(2, 2), // Shadow for depth
                          ),
                        ],
                      ),
                      child: Text(
                        '$_cartCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold, // Bold text for clarity
                        ),
                      ),
                    ),
                  ),
              ],
            ),

          if (!isAdmin)
            IconButton(
              icon: const Icon(Icons.payments_outlined, color: Colors.black),
              onPressed: () => Navigator.pushNamed(context, '/card'),
              tooltip: 'Card',
            ),

          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.add, color: Colors.black), // Add product icon
              onPressed: () => _showAddProductDialog(context),
              tooltip: 'Add Product', // Tooltip for accessibility
            ),

          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black), // Logout icon
            onPressed: () => _logout(context),
            tooltip: 'Logout', // Tooltip for accessibility
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            if (!isAdmin) _buildSlideCards(),
            if (!isAdmin) const SizedBox(height: 20),
            _buildCategoriesSection(),
            _buildProductList(), // Removed the `if (!isAdmin)` condition
          ],
        ),
      ),
    );
  }
  Widget _buildSlideCards() {
    return Column(
      children: [
        // Big Slider (Store Logo + Map)
        Container(
          height: MediaQuery.of(context).size.height * 0.1826, // ~176px
          width: MediaQuery.of(context).size.width * 0.8864, // ~386px
          margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width * 0.0364), // ~16px
          child: PageView.builder(
            itemCount: 2, // Store Logo + Map
            itemBuilder: (context, index) {
              if (index == 0) {
                // First slide: Store Logo
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutUsScreen()),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: AssetImage('lib/image/StoreLogo2.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                );
              } else {
                // Second slide: Store Location Map
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AboutUsScreen()),
                    );
                  },
                  child: AbsorbPointer(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20), // Match the container's border radius
                        child: FlutterMap(
                          options: MapOptions(
                            center: LatLng(36.260229142538186, 6.688279598255074), // Replace with your store's coordinates
                            zoom: 16.0,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                              subdomains: ['a', 'b', 'c'],
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: LatLng(36.260229142538186, 6.688279598255074), // Replace with your store's coordinates
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ),

        // Small Carousel (Centered)
        Center(
          child: SizedBox(
            height: 30, // Height of the small carousel
            width: MediaQuery.of(context).size.width * 0.35, // Width of the carousel (25% of screen width)
            child: PageView.builder(
              itemCount: 4,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final List<Map<String, dynamic>> carouselItems = [
                  {
                    'name': 'Hot',
                    'widget': HotScreen(products: _products), // Replace with your HotScreen widget
                  },
                  {
                    'name': 'Wishlist',
                    'widget': WishlistScreen(wishlist: _wishlist), // Replace with your WishlistScreen widget
                  },
                  {
                    'name': 'Orders',
                    'widget': OrdersScreen(orders: _orders), // Pass the local orders list
                  },
                  {
                    'name': 'About Us',
                    'widget': AboutUsScreen(), // Replace with your AboutUsScreen widget
                  },
                ];

                final item = carouselItems[index];
                final screenWidth = MediaQuery.of(context).size.width;

                return GestureDetector(
                  onTap: () {
                    // Navigate to the corresponding widget when clicked
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => item['widget']),
                    );
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.lime, // Lime-colored stroke
                            width: 2, // Stroke width
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            item['name'], // Name of the item
                            style: TextStyle(
                              fontSize: screenWidth * 0.04, // Dynamic font size (4% of screen width)
                              fontWeight: FontWeight.bold,
                              fontFamily: 'DGT',
                              color: Colors.lime,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
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

    // Check if the product is already in the wishlist
    final bool isInWishlist = _wishlist.contains(product['name']);

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
                  Text(
                    product['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text('\$${product['price']}'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Star Icon for Wishlist
                      IconButton(
                        icon: Icon(
                          Icons.star,
                          color: isInWishlist ? Colors.yellow : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            if (isInWishlist) {
                              _wishlist.remove(product['name']); // Remove from wishlist
                            } else {
                              _wishlist.add(product['name']); // Add to wishlist
                            }
                          });
                        },
                      ),

                      // Shopping Cart and Admin Buttons
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
      final existingProductIndex = _cart.indexWhere((item) => item['id'] == product['id']);
      if (existingProductIndex != -1) {
        // If the product already exists, increment its quantity
        _cart[existingProductIndex]['quantity'] += 1;
      } else {
        // Otherwise, add the product to the cart with an initial quantity of 1
        _cart.add({
          ...product,
          'quantity': 1, // Add the quantity field
        });
      }
      _cartCount++; // Increment the total cart count

    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added ${product['name']} to cart')),
    );
  }
  void _updateCartCount() {
    setState(() {
      _cartCount = _cart.fold(0, (sum, product) => sum + (product['quantity'] as int));
    });
  }

  void _showCart() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title Section
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Your Cart',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'DGT',
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Divider(thickness: 1, color: Colors.grey[300]),

                    // Empty Cart Message
                    if (_cart.isEmpty)
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.shopping_cart, size: 64, color: Colors.grey),
                            const SizedBox(height: 16),
                            const Text(
                              'Your cart is empty',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),

                    // Cart Items List
                    if (_cart.isNotEmpty)
                      SizedBox(
                        width: double.maxFinite,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _cart.length,
                          itemBuilder: (ctx, index) {
                            final product = _cart[index];
                            return ListTile(
                              leading: CachedNetworkImage(
                                imageUrl: product['images'][0],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              title: Text(product['name']),
                              subtitle: Text('\$${product['price']}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        if (product['quantity'] > 1) {
                                          product['quantity'] -= 1;
                                        } else {
                                          _cart.removeAt(index);
                                        }
                                        _updateCartCount();
                                      });
                                    },
                                    onLongPress: () {
                                      setState(() {
                                        _cart.removeAt(index);
                                        _updateCartCount();
                                      });
                                    },
                                  ),
                                  Text(
                                    '${product['quantity']}',
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle, color: Colors.green),
                                    onPressed: () {
                                      setState(() {
                                        product['quantity'] += 1;
                                        _updateCartCount();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                    // Total Price Section
                    if (_cart.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'DGT',
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '\$${_cart.fold(0.0, (sum, p) => sum + (p['price'] as double) * (p['quantity'] as int))}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'DGT',
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    Divider(thickness: 1, color: Colors.grey[300]),

                    // Action Buttons
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
                            child: const Text('Close'),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _cart.clear(); // Clear the cart
                                _updateCartCount(); // Reset the cart count
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Cart cleared successfully')),
                              );
                            },
                            icon: const Icon(Icons.playlist_remove_sharp, color: Colors.red, size: 30), // clrscr icon
                            tooltip: 'Clear Cart', // Tooltip for accessibility
                          ),
                          if (_cart.isNotEmpty)
                            ElevatedButton(
                              onPressed: () => _fakeCheckout(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lime,
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              ),
                              child: const Text('Checkout'),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }



  void _fakeCheckout(BuildContext context) async {
    final user = Provider.of<AuthService>(context, listen: false).currentUser;
    if (user == null) return;

    try {
      // Check if payment info is saved in Firestore
      final paymentInfo = await FirebaseFirestore.instance
          .collection('userPaymentInfo')
          .doc(user.uid)
          .get();

      if (!paymentInfo.exists) {
        // If no payment info exists, navigate to the PaymentScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PaymentScreen()),
        );
        return; // Stop further execution until payment info is provided
      }

      // Proceed with checkout if payment info exists
      await FirebaseFirestore.instance.collection('orders').add({
        'userId': user.uid,
        'items': _cart.map((p) => {
          'name': p['name'],
          'quantity': p['quantity'], // Include the quantity
          'price': p['price'],
        }).toList(),
        'total': _cart.fold(
          0.0,
              (sum, p) => sum + (p['price'] as double) * (p['quantity'] as int),
        ),
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        _cart.clear(); // Clear the cart
        _cartCount = 0; // Reset the cart count
      });

      Navigator.pop(context); // Close the cart dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order placed successfully!')),
      );
    } catch (e) {
      // Handle Firestore permission errors
      if (e.toString().contains('permission')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You do not have permission to place an order. Redirecting to payment info...')),
        );

        // Redirect to the PaymentScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PaymentScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error placing order: ${e.toString()}')),
        );
      }
    }
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

List<Map<String, dynamic>> _products = [];
