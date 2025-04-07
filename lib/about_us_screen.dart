// about_us_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E), // Dark background
      body: Stack(
        clipBehavior: Clip.none, // Allows overflow
        children: [
          // Background Overlay
          GestureDetector(
            onTap: () {
              Navigator.pop(context); // Close the screen when tapping outside
            },
            child: Container(
              color: Colors.black.withOpacity(0.5), // Semi-transparent overlay
            ),
          ),

          // "About Us" Text
          Positioned(
            top: MediaQuery.of(context).size.height * 0.05, // Adjust vertical position
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "About Us",
                style: TextStyle(
                  fontFamily: "DGT", // Custom font
                  fontSize: 40, // Adjust size
                  fontWeight: FontWeight.bold,
                  color: Colors.lime, // Match the border color
                ),
              ),
            ),
          ),

          // Circular Back Button (Replaces Logo)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.14, // Position above the card
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(8), // Padding around the button
                decoration: BoxDecoration(
                  color: Colors.lime, // Lime background
                  shape: BoxShape.circle, // Circular shape
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black), // Back arrow icon
                  iconSize: 30, // Adjust icon size
                  onPressed: () => Navigator.pop(context), // Navigate back
                ),
              ),
            ),
          ),

          // Content Card
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25, // Push card lower
            left: MediaQuery.of(context).size.width * 0.10,
            right: MediaQuery.of(context).size.width * 0.10,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.80, // 80% of screen width
              height: MediaQuery.of(context).size.height * 0.70, // 70% of screen height
              decoration: BoxDecoration(
                color: Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(35),
                border: Border.all(
                  color: Colors.lime, // Lime stroke
                  width: 4, // Adjust thickness
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),

                    // Centered Description Section
                    Expanded(
                      child: Center(
                        child: Text(
                          'MaxFrame is an e-commerce app made By 3 Students of OGX Uni, it delivers top-quality laptops, and their latest peripherals. At MaxFrame, we deliver cutting-edge technology and expert service to take your gaming to the next level.',
                          textAlign: TextAlign.center, // Centers text horizontally
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Store Location Section
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center, // Align children to the center
                        children: [
                          const Text(
                            'our store location',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),

                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              height: 150,
                              width: double.infinity,
                              child: FlutterMap(
                                options: MapOptions(
                                  center: LatLng(36.260229142538186, 6.688279598255074), // Replace with your store's coordinates
                                  zoom: 17,
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate: 'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=ASSlkmmFbyvNHE83Xgbq',
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Logo Positioned on Top
        ],
      ),
    );
  }
}