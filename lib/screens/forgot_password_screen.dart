import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;
  String? _emailError;

  bool _validateEmail(String email) {
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return regex.hasMatch(email);
  }

  Future<void> _sendResetEmail() async {
    setState(() {
      _emailError = _emailCtrl.text.isEmpty
          ? "Veuillez entrer votre email"
          : !_validateEmail(_emailCtrl.text)
              ? "Email invalide"
              : null;
    });

    if (_emailError != null) return;

    setState(() => _isLoading = true);

    final provider = context.read<AppProvider>();
    final success = await provider.sendPasswordReset(_emailCtrl.text.trim());

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      setState(() => _emailSent = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("❌ Aucun compte trouvé avec cet email"),
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _emailSent ? _buildSuccessView(textPrimary) : _buildFormView(surfaceColor, textPrimary, textMuted),
        ),
      ),
    );
  }

  Widget _buildFormView(Color surfaceColor, Color textPrimary, Color textMuted) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Center(
          child: Image.asset(
            'assets/images/logo.png',
            width: 180,
            height: 180,
          ),
        ),
        const SizedBox(height: 32),
        Text(
          "Mot de passe oublié ?",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Entrez votre email et nous vous enverrons un lien pour réinitialiser votre mot de passe.",
          style: TextStyle(
            fontSize: 16,
            color: textMuted,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 32),
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
        ElevatedButton(
          onPressed: _isLoading ? null : _sendResetEmail,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1C3F7A),
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : const Text(
                  "Envoyer le lien",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
        ),
      ],
    );
  }

  Widget _buildSuccessView(Color textPrimary) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle_outline,
            color: Colors.green,
            size: 60,
          ),
        ),
        const SizedBox(height: 32),
        Text(
          "Email envoyé !",
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Vérifiez votre boîte de réception. Nous avons envoyé un lien de réinitialisation à ${_emailCtrl.text}.",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0xFF64748B),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1C3F7A),
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
          ),
          child: const Text(
            "Retour à la connexion",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }
}