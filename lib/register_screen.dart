import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFF1E1E1E), // dgray
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.0818), // 36 / 440
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.1172), // 112 / 956
              Text(
                "Welcome",
                style: TextStyle(
                  fontSize: screenWidth * 0.1091, // 48 / 440
                  fontWeight: FontWeight.bold,
                  fontFamily: 'DGT',
                  color: Colors.white,
                ),
              ),
              SizedBox(height: screenHeight * 0.0899), // 86 / 956
              Text(
                "Please sign-up",
                style: TextStyle(
                  fontSize: screenWidth * 0.0545, // 24 / 440
                  fontWeight: FontWeight.normal,
                  fontFamily: 'DGT',
                  color: Colors.white,
                ),
              ),
              SizedBox(height: screenHeight * 0.1883), // 196 / 956
              _buildInputField("Email", screenWidth, screenHeight, _emailController),
              SizedBox(height: screenHeight * 0.0502), // 48 / 956
              _buildInputField("Password", screenWidth, screenHeight, _passwordController),
              SizedBox(height: screenHeight * 0.2303), // 220 / 956
              _buildRegisterButton(context, screenWidth, screenHeight),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, double screenWidth, double screenHeight, TextEditingController controller) {
    return Container(
      width: screenWidth * 0.8477, // 373 / 440
      height: screenHeight * 0.0544, // 52 / 956
      decoration: BoxDecoration(
        color: Color(0xFF454955), // gray
        borderRadius: BorderRadius.circular(35),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          style: TextStyle(
            fontSize: screenWidth * 0.0295, // 13 / 440
            fontWeight: FontWeight.normal,
            fontFamily: 'DGT',
            color: Colors.white,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: label,
            hintStyle: TextStyle(
              fontSize: screenWidth * 0.0295, // 13 / 440
              fontWeight: FontWeight.normal,
              fontFamily: 'DGT',
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context, double screenWidth, double screenHeight) {
    return GestureDetector(
      onTap: () => _register(context),
      child: Container(
        width: screenWidth * 0.3205, // 141 / 440
        height: screenHeight * 0.0544, // 52 / 956
        decoration: BoxDecoration(
          color: Color(0xFFCBEA00), // green
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFCBEA00).withOpacity(0.5),
              offset: Offset(0, -12),
              blurRadius: 20,
              spreadRadius: -15,
            ),
            BoxShadow(
              color: Color(0xFFCBEA00).withOpacity(0.5),
              offset: Offset(0, 12),
              blurRadius: 20,
              spreadRadius: -15,
            ),
          ],
        ),
        child: Center(
          child: Text(
            "Register",
            style: TextStyle(
              fontSize: screenWidth * 0.0295, // 13 / 440
              fontWeight: FontWeight.normal,
              fontFamily: 'DGT',
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _register(BuildContext context) async {
    try {
      await Provider.of<AuthService>(context, listen: false).signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      Navigator.pop(context); // Go back to the previous screen after registration
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
}