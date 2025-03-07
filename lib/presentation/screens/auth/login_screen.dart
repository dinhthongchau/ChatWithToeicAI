import 'package:ct312hm01_temp/presentation/common_widgets/custom_appbar_auth.dart';
import 'package:ct312hm01_temp/presentation/screens/auth/app_auth_provider.dart';
import 'package:ct312hm01_temp/presentation/screens/auth/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common_widgets/custom_notice_snackbar.dart';
import '../chat/chat_screen.dart';
import '../setting/theme_provider.dart';

class LoginScreen extends StatelessWidget {
  static const String route = "/login";

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.backgroundColor,
      appBar: AppBar(
        title: Text("TOEIC AI ChatBox",
            style: TextStyle(color: themeProvider.textColor)),
        backgroundColor: themeProvider.backgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
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
  bool _isHovered = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AppAuthProvider>();
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Login",
                style: TextStyle(
                    fontSize: 24,
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
            const SizedBox(height: 20),
            _buildLoginButton(authProvider, themeProvider),
            const SizedBox(height: 12),
            Center(
              child: MouseRegion(
                onEnter: (_) => setState(() => _isHovered = true),
                onExit: (_) => setState(() => _isHovered = false),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(RegisterScreen.route);
                  },
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                      _isHovered
                          ? themeProvider.userMessageColor.withOpacity(0.3)
                          : Colors.transparent,
                    ),
                  ),
                  child: Text(
                    "Don't have an account? Register",
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
    );
  }

  Widget _buildLabel(String text, ThemeProvider themeProvider) {
    return Text(text, style: TextStyle(color: themeProvider.textColor));
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
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: TextStyle(color: themeProvider.textColor),
    );
  }

  Widget _buildLoginButton(
      AppAuthProvider authProvider, ThemeProvider themeProvider) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          try {
            await authProvider.loginWithEmail(
                _emailController.text, _passwordController.text);
            if (context.mounted) {
              Navigator.of(context).pushNamed(ChatScreen.route);
              ScaffoldMessenger.of(context).showSnackBar(
                customNoticeSnackbar(
                  context,
                  "Sign in ok with ${authProvider.getEmailAfterSignIn()} ",
                  false,
                ),
              );
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                customNoticeSnackbar(context, "$e", true),
              );
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: themeProvider.historyBorderColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text("Login", style: TextStyle(color: themeProvider.textColor)),
      ),
    );
  }
}
