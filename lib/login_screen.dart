import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_service.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key});

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
                "Please sign-in",
                style: TextStyle(
                  fontSize: screenWidth * 0.0545, // 24 / 440
                  fontWeight: FontWeight.normal,
                  fontFamily: 'DGT',
                  color: Colors.white,
                ),
              ),
              SizedBox(height: screenHeight * 0.1883), // 196 / 956
              _buildInputField("Email", screenWidth, screenHeight, _emailController, false),
              SizedBox(height: screenHeight * 0.0502), // 48 / 956
              _buildInputField("Password", screenWidth, screenHeight, _passwordController, true),
              SizedBox(height: screenHeight * 0.0502), // 48 / 956
              _buildLoginButton(context, screenWidth, screenHeight),
              SizedBox(height: screenHeight * 0.0502), // 48 / 956
              _buildCreateAccountButton(context, screenWidth, screenHeight),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, double screenWidth, double screenHeight, TextEditingController controller, bool obscureText) {
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
          obscureText: obscureText, // Hide text if it's a password field
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

  Widget _buildLoginButton(BuildContext context, double screenWidth, double screenHeight) {
    return GestureDetector(
      onTap: () => _login(context),
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
            "Login",
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

  Widget _buildCreateAccountButton(BuildContext context, double screenWidth, double screenHeight) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/register'),
      child: Center(
        child: Text(
          "Create Account",
          style: TextStyle(
            fontSize: screenWidth * 0.0364, // 16 / 440
            fontWeight: FontWeight.bold,
            fontFamily: 'DGT',
            color: Color(0xFFCBEA00), // green
          ),
        ),
      ),
    );
  }

  Future<void> _login(BuildContext context) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (!_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid email address")),
      );
      return;
    }

    if (!_isStrongPassword(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password must be at least 8 characters long, contain a number, and an uppercase letter.")),
      );
      return;
    }

    try {
      await Provider.of<AuthService>(context, listen: false).login(email, password);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+com$');
    return emailRegex.hasMatch(email);
  }

  bool _isStrongPassword(String password) {
    if (password.length < 8) return false;
    if (!password.contains(RegExp(r'[A-Z]'))) return false;
    if (!password.contains(RegExp(r'[0-9]'))) return false;
    return true;
  }
}