import 'package:ct312hm01_temp/provider/app_auth_provider.dart';
import 'package:ct312hm01_temp/presentation/screens/auth/register_screen.dart';
import 'package:ct312hm01_temp/provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/database/user_db.dart';
import '../../common_widgets/custom_notice_snackbar.dart';
import '../chat/chat_screen.dart';

class LoginScreen extends StatelessWidget {
  static const String route = "/login";

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Semi-transparent Overlay for Readability
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const SizedBox.expand(),
          ),
          // Login Form
          const Body(), // Remove SingleChildScrollView and SizedBox from here
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
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
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
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AppAuthProvider>();

    return SingleChildScrollView(
      // Move SingleChildScrollView
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 32.0, vertical: 16.0), 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
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
            // Login Title
            const Text(
              "LOGIN",
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
              keyboardType: TextInputType
                  .visiblePassword,
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
                  print(
                      "Password field has focus, ensuring keyboard is visible");
                }
              },
            ),
            const SizedBox(height: 32),
            // Login Button
            _buildLoginButton(authProvider),
            const SizedBox(height: 16),
            // Login as Guest
            TextButton(
              onPressed: () {
                final chatProvider = context.read<ChatProvider>();
                final authProvider = context.read<AppAuthProvider>();

                authProvider.signOut();
                chatProvider.setUserId(-1, null);
                chatProvider.resetChat();

                Navigator.of(context).pushNamed(ChatScreen.route);
              },
              child: const Text(
                "Login as guest",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      offset: Offset(1, 1),
                      blurRadius: 3,
                    ),
                  ],
                ),
              ),
            ),
            // Register Link
            MouseRegion(
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => setState(() => _isHovered = false),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(RegisterScreen.route);
                },
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.all(
                    _isHovered
                        ? const Color(0xFF4FC3F7).withOpacity(0.3)
                        : Colors.transparent,
                  ),
                ),
                child: Text(
                  "Don't have an account? Register",
                  style: TextStyle(
                    color: _isHovered ? const Color(0xFF4FC3F7) : Colors.white,
                    fontWeight:
                        _isHovered ? FontWeight.bold : FontWeight.normal,
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
            // Add some spacing at the bottom to avoid content being too close to the edge
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          ],
        ),
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
        prefixIcon: Icon(icon, color: Colors.white70),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: false,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF4FC3F7)),
          borderRadius: BorderRadius.circular(30),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF4FC3F7)),
          borderRadius: BorderRadius.circular(30),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF4FC3F7), width: 2),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      style: const TextStyle(color: Colors.white),
      onTapOutside: (event) {
        focusNode.unfocus();
      },
    );
  }

  Widget _buildLoginButton(AppAuthProvider authProvider) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          try {
            await authProvider.loginWithEmail(
                _emailController.text, _passwordController.text);
            int? userId = await UserDB.getUserIdByEmail(_emailController.text);
            if (userId != null) {
              if (!mounted) return;
              context
                  .read<ChatProvider>()
                  .setUserId(userId, _emailController.text);
              context.read<ChatProvider>().startNewSession();
              print("Login successful");
              Navigator.of(context).pushNamed(
                ChatScreen.route,
                arguments: userId,
              );
            }
          } catch (e) {
            print("Login error: $e");
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              customNoticeSnackbar(context, "$e", true),
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
          "LOGIN",
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
