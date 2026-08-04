import 'package:flutter/material.dart';
// ignore_for_file: unused_field
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'level_selection.dart';
import 'home_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _emailError;
  String? _passwordError;

  late AnimationController _animController;
  late Animation<double> _logoFade;
  late Animation<Offset> _logoSlide;
  late Animation<double> _boyFade;
  late Animation<Offset> _boySlide;
  late Animation<double> _formFade;
  late Animation<Offset> _formSlide;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: const Interval(0, 0.3, curve: Curves.easeOut)),
    );
    _logoSlide = Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animController, curve: const Interval(0, 0.3, curve: Curves.easeOut)),
    );

    _boyFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: const Interval(0.2, 0.5, curve: Curves.easeOut)),
    );
    _boySlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animController, curve: const Interval(0.2, 0.5, curve: Curves.easeOut)),
    );

    _formFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: const Interval(0.4, 0.8, curve: Curves.easeOut)),
    );
    _formSlide = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _animController, curve: const Interval(0.4, 0.8, curve: Curves.easeOut)),
    );

    _animController.forward();
  }

  bool _validateEmail(String email) {
    // Basic valid email check
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+\$');
    return regex.hasMatch(email);
  }

  void _validateFields() {
    setState(() {
      _emailError = _emailCtrl.text.isEmpty
          ? "Veuillez entrer votre email"
          : !_validateEmail(_emailCtrl.text)
              ? "Email invalide"
              : null;
      _passwordError = _passwordCtrl.text.isEmpty
          ? "Veuillez entrer votre mot de passe"
          : _passwordCtrl.text.length < 6
              ? "Minimum 6 caractères"
              : null;
    });
  }

  Future<void> _login() async {
    _validateFields();
    if (_emailError != null || _passwordError != null) return;

    setState(() => _isLoading = true);

    final provider = context.read<AppProvider>();
    final success = await provider.login(
      _emailCtrl.text.trim(),
      _passwordCtrl.text,
    );

    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("❌ Email ou mot de passe incorrect"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<AppProvider>().isDarkMode;
    final bgColor = isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F7FB);
    final surfaceColor = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1E293B);
    final textMuted = isDark ? Colors.grey.shade500 : const Color(0xFF94A3B8);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Logo Mou3adli
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 200,
                  height: 200,
                ),
              ),
              const SizedBox(height: 24),
              // Image mascotte boy
              Center(
                child: Image.asset(
                  'assets/images/boy.png',
                  width: 250,
                  height: 250,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 40),
              // Email
              Text(
                "Email",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: textPrimary),
                  decoration: InputDecoration(
                    hintText: "exemple@email.com",
                    hintStyle: TextStyle(color: textMuted),
                    prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF1C3F7A)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    errorText: _emailError,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Mot de passe",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _passwordCtrl,
                  obscureText: _obscurePassword,
                  style: TextStyle(color: textPrimary),
                  decoration: InputDecoration(
                    hintText: "Votre mot de passe",
                    hintStyle: TextStyle(color: textMuted),
                    prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF1C3F7A)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: textMuted,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    errorText: _passwordError,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                    );
                  },
                  child: const Text(
                    "Mot de passe oublié ?",
                    style: TextStyle(
                      color: Color(0xFF2563EB),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1C3F7A),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Se connecter",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
              ),
              const SizedBox(height: 20),
              // Separateur
              Row(
                children: [
                  Expanded(child: Divider(color: textMuted)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "ou",
                      style: TextStyle(color: textMuted),
                    ),
                  ),
                  Expanded(child: Divider(color: textMuted)),
                ],
              ),
              const SizedBox(height: 20),
              // Bouton Creer un compte
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LevelSelectionScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  side: const BorderSide(color: Color(0xFF1C3F7A)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text(
                  "Creer un compte",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1C3F7A),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _animController.dispose();
    super.dispose();
  }
}