import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../data/options_curriculum.dart';
import 'home_screen.dart';

class LevelSelectionScreen extends StatefulWidget {
  const LevelSelectionScreen({super.key});

  @override
  State<LevelSelectionScreen> createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _schoolCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  bool _obscureConfirmPassword = true;

  String? _selectedClassLevel;
  String? _selectedStream;
  String? _selectedOption;
  bool _isLoading = false;

  final List<String> _allClassLevels = [
    '7eme', '8eme', '9eme',
    '1ere', '2eme', '3eme', '4eme',
  ];

  String _displayClassName(String level) {
    final map = {
      '7eme': '7ème Année de Base',
      '8eme': '8ème Année de Base',
      '9eme': '9ème Année de Base',
      '1ere': '1ère Année Secondaire',
      '2eme': '2ème Année Secondaire',
      '3eme': '3ème Année Secondaire',
      '4eme': 'Baccalauréat (4ème)',
    };
    return map[level] ?? level;
  }

  String _displayStreamName(String stream) {
    switch (stream) {
      case 'commun': return 'Commun';
      case 'pilote': return 'Pilote';
      case 'general': return 'Tronc commun';
      case 'sciences': return 'Sciences';
      case 'lettres': return 'Lettres';
      case 'economie': return 'Économie & Gestion';
      case 'tech_info': return 'Technologie Info';
      case 'math': return 'Mathématiques';
      case 'sciences_exp': return 'Sciences Expérimentales';
      case 'sciences_tech': return 'Sciences Techniques';
      case 'sciences_info': return 'Sciences Informatiques';
      case 'sport': return 'Sport';
      default: return stream;
    }
  }

  Future<void> _register() async {
    if (_nameCtrl.text.trim().isEmpty ||
        _emailCtrl.text.trim().isEmpty ||
        _schoolCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Veuillez remplir tous les champs")),
      );
      return;
    }

    if (_selectedClassLevel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Veuillez sélectionner une classe")),
      );
      return;
    }

    if (_selectedStream == null) {
      final bool isCollege = _selectedClassLevel == '7eme' ||
          _selectedClassLevel == '8eme' ||
          _selectedClassLevel == '9eme';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isCollege
            ? "❌ Veuillez choisir un type d'établissement"
            : "❌ Veuillez sélectionner une section")),
      );
      return;
    }

    if (_shouldShowOption() && _selectedOption == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Veuillez choisir une option")),
      );
      return;
    }
    if (_passwordCtrl.text.isEmpty || _confirmPasswordCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Veuillez entrer un mot de passe")),
      );
      return;
    }

    if (_passwordCtrl.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Le mot de passe doit contenir au moins 6 caractères")),
      );
      return;
    }

    if (_passwordCtrl.text != _confirmPasswordCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Les mots de passe ne correspondent pas")),
      );
      return;
    }
    setState(() => _isLoading = true);

    final provider = context.read<AppProvider>();
    await provider.register(
      fullName: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
      schoolName: _schoolCtrl.text.trim(),
      cycle: _selectedClassLevel == '7eme' || _selectedClassLevel == '8eme' || _selectedClassLevel == '9eme'
          ? 'college'
          : 'lycee',
      classLevel: _selectedClassLevel!,
      stream: _selectedStream,
      optionId: _selectedOption,
    );

    setState(() => _isLoading = false);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  bool _shouldShowStream() {
    return _selectedClassLevel == '7eme' ||
        _selectedClassLevel == '8eme' ||
        _selectedClassLevel == '9eme' ||
        _selectedClassLevel == '1ere' ||
        _selectedClassLevel == '2eme' ||
        _selectedClassLevel == '3eme' ||
        _selectedClassLevel == '4eme';
  }

  bool _shouldShowOption() {
    return OptionCurriculum.hasOptions(_selectedClassLevel ?? '', _selectedStream);
  }

  List<String> _getAvailableStreams() {
    if (_selectedClassLevel == null) return [];
    if (_selectedClassLevel == '7eme' || _selectedClassLevel == '8eme' || _selectedClassLevel == '9eme') {
      return ['commun', 'pilote'];
    }
    if (_selectedClassLevel == '1ere') {
      return ['general', 'sport'];
    }
    if (_selectedClassLevel == '2eme') {
      return ['sciences', 'lettres', 'economie', 'tech_info', 'sport'];
    }
    if (_selectedClassLevel == '3eme' || _selectedClassLevel == '4eme') {
      return ['sciences_exp', 'math', 'economie', 'sciences_info', 'sciences_tech', 'lettres', 'sport'];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<AppProvider>().isDarkMode;
    final bgColor = isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F7FB);
    final surfaceColor = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1E293B);
    final textSecondary = isDark ? Colors.grey.shade400 : const Color(0xFF64748B);
    final textMuted = isDark ? Colors.grey.shade500 : const Color(0xFF94A3B8);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Créer un compte",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: textPrimary),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _buildTextField('Nom complet', Icons.person_outline, _nameCtrl, surfaceColor, textPrimary, textMuted),
            _buildTextField('Email', Icons.email_outlined, _emailCtrl, surfaceColor, textPrimary, textMuted),
            _buildPasswordField('Mot de passe', Icons.lock_outline, _passwordCtrl, surfaceColor, textPrimary, textMuted),
            _buildPasswordField('Confirmer le mot de passe', Icons.lock_outline, _confirmPasswordCtrl, surfaceColor, textPrimary, textMuted, obscureText: _obscureConfirmPassword, toggleObscure: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            }),
            _buildTextField('École', Icons.school_outlined, _schoolCtrl, surfaceColor, textPrimary, textMuted),
            const SizedBox(height: 20),
            _buildClassDropdown(surfaceColor, textPrimary, textSecondary, textMuted),
            if (_shouldShowStream()) ...[
              const SizedBox(height: 20),
              _buildStreamDropdown(surfaceColor, textPrimary, textSecondary, textMuted),
            ],
            if (_shouldShowOption()) ...[
              const SizedBox(height: 20),
              _buildOptionDropdown(surfaceColor, textPrimary, textSecondary, textMuted),
            ],
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isLoading ? null : _register,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1C3F7A),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Créer mon compte', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, IconData icon, TextEditingController ctrl, Color surfaceColor, Color textPrimary, Color textMuted) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: ctrl,
        style: TextStyle(color: textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: textMuted),
          prefixIcon: Icon(icon, color: const Color(0xFF1C3F7A)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    String hint,
    IconData icon,
    TextEditingController ctrl,
    Color surfaceColor,
    Color textPrimary,
    Color textMuted, {
    bool obscureText = true,
    VoidCallback? toggleObscure,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: ctrl,
        obscureText: obscureText,
        style: TextStyle(color: textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: textMuted),
          prefixIcon: Icon(icon, color: const Color(0xFF1C3F7A)),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: textMuted,
            ),
            onPressed: toggleObscure,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildClassDropdown(Color surfaceColor, Color textPrimary, Color textSecondary, Color textMuted) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Classe', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: textPrimary)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedClassLevel,
          isExpanded: true,
          dropdownColor: surfaceColor,
          style: TextStyle(color: textPrimary),
          decoration: InputDecoration(
            filled: true,
            fillColor: surfaceColor,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            hintText: "Sélectionnez votre classe",
            hintStyle: TextStyle(color: textMuted),
          ),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
          items: _allClassLevels.map((level) {
            return DropdownMenuItem(value: level, child: Text(_displayClassName(level), style: TextStyle(color: textPrimary)));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedClassLevel = value;
              _selectedStream = null;
              _selectedOption = null;
            });
          },
        ),
      ],
    );
  }

  Widget _buildStreamDropdown(Color surfaceColor, Color textPrimary, Color textSecondary, Color textMuted) {
    final streams = _getAvailableStreams();
    if (streams.isEmpty) return const SizedBox.shrink();

    final bool isCollege = _selectedClassLevel == '7eme' ||
        _selectedClassLevel == '8eme' ||
        _selectedClassLevel == '9eme';
    final String label = isCollege ? "Type d'établissement" : "Section";
    final String hint = isCollege
        ? "Choisissez votre type d'établissement"
        : "Sélectionnez votre section";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: textPrimary)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedStream,
          isExpanded: true,
          dropdownColor: surfaceColor,
          style: TextStyle(color: textPrimary),
          decoration: InputDecoration(
            filled: true,
            fillColor: surfaceColor,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            hintText: hint,
            hintStyle: TextStyle(color: textMuted),
          ),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
          items: streams.map((stream) {
            return DropdownMenuItem(value: stream, child: Text(_displayStreamName(stream), style: TextStyle(color: textPrimary)));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedStream = value;
              _selectedOption = null;
            });
          },
        ),
      ],
    );
  }

  Widget _buildOptionDropdown(Color surfaceColor, Color textPrimary, Color textSecondary, Color textMuted) {
    final options = OptionCurriculum.getAllOptions();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Option", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: textPrimary)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedOption,
          isExpanded: true,
          dropdownColor: surfaceColor,
          style: TextStyle(color: textPrimary),
          decoration: InputDecoration(
            filled: true,
            fillColor: surfaceColor,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            hintText: "Choisissez votre option",
            hintStyle: TextStyle(color: textMuted),
          ),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
          items: options.map((opt) {
            return DropdownMenuItem(
              value: opt['id'] as String,
              child: Text(opt['nameFr'] as String, style: TextStyle(color: textPrimary)),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedOption = value;
            });
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _schoolCtrl.dispose();
    super.dispose();
  }
}