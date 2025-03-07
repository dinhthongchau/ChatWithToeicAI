import 'package:ct312hm01_temp/presentation/screens/auth/app_auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';
import '../chat/chat_screen.dart';
import '../setting/theme_provider.dart';

class RegisterScreen extends StatelessWidget {
  static const String route = "/register";

  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.backgroundColor,
      appBar: AppBar(title: const Text("TOEIC AI CHATBOX")),
      body: const Body(),
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
  bool _isHovered = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AppAuthProvider>();
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Register",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.textColor),
                ),
              ),
              const SizedBox(height: 20),
              _buildLabel("Email", themeProvider),
              _buildTextField(_emailController, themeProvider, false),
              const SizedBox(height: 12),
              _buildLabel("Password", themeProvider),
              _buildTextField(_passwordController, themeProvider, true),
              const SizedBox(height: 12),
              _buildLabel("Confirm Password", themeProvider),
              _buildTextField(_confirmPasswordController, themeProvider, true),
              const SizedBox(height: 20),
              _buildRegisterButton(authProvider, themeProvider),
              const SizedBox(height: 12),
              Center(
                child: MouseRegion(
                  onEnter: (_) => setState(() => _isHovered = true),
                  onExit: (_) => setState(() => _isHovered = false),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Already have an account? Login",
                      style: TextStyle(
                        color: _isHovered
                            ? themeProvider.userMessageColor
                            : themeProvider.textColor,
                        fontWeight:
                            _isHovered ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(text,
          style: TextStyle(color: themeProvider.textColor, fontSize: 16)),
    );
  }

  Widget _buildTextField(TextEditingController controller,
      ThemeProvider themeProvider, bool obscureText) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: themeProvider.inputBoxColor,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: themeProvider.inputBorderColor),
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      style: TextStyle(color: themeProvider.textColor, fontSize: 16),
    );
  }

  Widget _buildRegisterButton(
      AppAuthProvider authProvider, ThemeProvider themeProvider) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (_passwordController.text != _confirmPasswordController.text) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Passwords do not match!")),
            );
            return;
          }
          try {
            await authProvider.signUpWithEmail(_emailController.text,
                _passwordController.text, _confirmPasswordController.text);
            if (context.mounted) {
              Navigator.of(context).pushNamed(LoginScreen.route);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Registration successful! - Welcome to TOEIC AI CHATBOX")),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("$e")),
              );
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: themeProvider.historyBorderColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text("Register",
            style: TextStyle(color: themeProvider.textColor, fontSize: 18)),
      ),
    );
  }
}
