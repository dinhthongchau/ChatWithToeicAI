import 'package:ct312hm01_temp/provider/app_auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';

class RegisterScreen extends StatelessWidget {
  static const String route = "/register";

  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/background2.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Semi-transparent Overlay for Readability
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const SizedBox.expand(),
          ),
          // Register Form
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: const Body(),
            ),
          ),
        ],
      ),
    );
  }
}

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      print("Email FocusNode changed: hasFocus=${_emailFocusNode.hasFocus}");
    });
    _passwordFocusNode.addListener(() {
      print(
          "Password FocusNode changed: hasFocus=${_passwordFocusNode.hasFocus}");
    });
    _confirmPasswordFocusNode.addListener(() {
      print(
          "Confirm Password FocusNode changed: hasFocus=${_confirmPasswordFocusNode.hasFocus}");
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AppAuthProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon and Title
          const Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          const Text(
            "TOEIC AI Chatbot",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black54,
                  offset: Offset(2, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Register Title
          const Text(
            "REGISTER",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black54,
                  offset: Offset(2, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Email Field
          _buildTextField(
            controller: _emailController,
            focusNode: _emailFocusNode,
            obscureText: false,
            label: "EMAIL",
            icon: Icons.email_outlined,
            keyboardType: TextInputType.visiblePassword,
            onTap: () {
              print("Email field tapped!");
              FocusScope.of(context).requestFocus(_emailFocusNode);
              if (_emailFocusNode.hasFocus) {
                print("Email field has focus, ensuring keyboard is visible");
              }
            },
          ),
          const SizedBox(height: 16),
          // Password Field
          _buildTextField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            obscureText: true,
            label: "PASSWORD",
            icon: Icons.lock_outline,
            keyboardType: TextInputType.visiblePassword,
            onTap: () {
              print("Password field tapped!");
              FocusScope.of(context).requestFocus(_passwordFocusNode);
              if (_passwordFocusNode.hasFocus) {
                print("Password field has focus, ensuring keyboard is visible");
              }
            },
          ),
          const SizedBox(height: 16),
          // Confirm Password Field
          _buildTextField(
            controller: _confirmPasswordController,
            focusNode: _confirmPasswordFocusNode,
            obscureText: true,
            label: "CONFIRM PASSWORD",
            icon: Icons.lock_outline,
            keyboardType: TextInputType.visiblePassword,
            onTap: () {
              print("Confirm Password field tapped!");
              FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
              if (_confirmPasswordFocusNode.hasFocus) {
                print(
                    "Confirm Password field has focus, ensuring keyboard is visible");
              }
            },
          ),
          const SizedBox(height: 32),
          // Register Button
          _buildRegisterButton(authProvider),
          const SizedBox(height: 16),
          // Login Link
          MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                overlayColor: WidgetStateProperty.all(
                  _isHovered
                      ? const Color(0xFF4FC3F7)
                          .withOpacity(0.3) // userMessageColor
                      : Colors.transparent,
                ),
              ),
              child: Text(
                "Already have an account? Login",
                style: TextStyle(
                  color: _isHovered
                      ? const Color(0xFF4FC3F7) // userMessageColor
                      : Colors.white, // textColor
                  fontWeight: _isHovered ? FontWeight.bold : FontWeight.normal,
                  fontSize: 16,
                  shadows: const [
                    Shadow(
                      color: Colors.black54,
                      offset: Offset(1, 1),
                      blurRadius: 3,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required bool obscureText,
    required String label,
    required IconData icon,
    required TextInputType keyboardType,
    required VoidCallback? onTap,
  }) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onTap: onTap,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white70), // textColor
        labelText: label,
        labelStyle:
            const TextStyle(color: Colors.white70),
        filled: false,
        border:  OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF4FC3F7)),
          borderRadius: BorderRadius.circular(30),
        ),
        enabledBorder:  OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF4FC3F7)),
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder:  OutlineInputBorder(
          borderSide: BorderSide(
              color: Color(0xFF4FC3F7), width: 2),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      style: const TextStyle(color: Colors.white),
      onTapOutside: (event) {
        focusNode.unfocus();
      },
    );
  }

  Widget _buildRegisterButton(AppAuthProvider authProvider) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (_passwordController.text != _confirmPasswordController.text) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Passwords do not match!")),
            );
            return;
          }
          try {
            await authProvider.signUpWithEmail(_emailController.text,
                _passwordController.text, _confirmPasswordController.text);
            if (!mounted) return;
            Navigator.of(context).pushNamed(LoginScreen.route);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      "Registration successful! - Welcome to TOEIC AI CHATBOT")),
            );
          } catch (e) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("$e")),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4FC3F7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 5,
        ),
        child: const Text(
          "REGISTER",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
