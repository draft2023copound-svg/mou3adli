import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../data/tunisian_curriculum.dart';
import '../widgets/custom_widgets.dart';
import 'home_screen.dart';

class LevelSelectionScreen extends StatefulWidget {
  final bool isRegistering;
  const LevelSelectionScreen({super.key, this.isRegistering = false});

  @override
  State<LevelSelectionScreen> createState() => _LevelSelectionScreenState();
}

class _LevelSelectionScreenState extends State<LevelSelectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _schoolCtrl = TextEditingController();

  String _selectedCycle = 'college';
  int _selectedClassIndex = 2;
  String? _selectedStream;
  String _selectedType = 'classique';
  bool _isLoading = false;
  String? _error;

  final List<String> _collegeClasses = ['7ème Année', '8ème Année', '9ème Année'];
  final List<String> _lyceeClasses = ['1ère Année', '2ème Année', '3ème Année', '4ème Année'];
  final List<String> _collegeLevels = ['7eme', '8eme', '9eme'];
  final List<String> _lyceeLevels = ['1ere', '2eme', '3eme', '4eme'];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _schoolCtrl.dispose();
    super.dispose();
  }

  List<String> get _currentClassNames =>
      _selectedCycle == 'college' ? _collegeClasses : _lyceeClasses;

  List<String> get _currentClassLevels =>
      _selectedCycle == 'college' ? _collegeLevels : _lyceeLevels;

  String get _currentClassLevel => _currentClassLevels[_selectedClassIndex];

  bool get _needsStream => _selectedCycle == 'lycee' && _currentClassLevel != '1ere';

  List<Map<String, String>> get _availableStreams =>
      TunisianCurriculum.getStreams(_currentClassLevel);

  Future<void> _handleSubmit() async {
    if (_nameCtrl.text.trim().isEmpty ||
        _emailCtrl.text.trim().isEmpty ||
        _schoolCtrl.text.trim().isEmpty) {
      setState(() => _error = 'Veuillez remplir tous les champs');
      return;
    }
    if (_needsStream && _selectedStream == null) {
      setState(() => _error = 'Veuillez choisir une section');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    final provider = context.read<AppProvider>();
    await provider.register(
      fullName: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      schoolName: _schoolCtrl.text.trim(),
      cycle: _selectedCycle,
      classLevel: _currentClassLevel,
      stream: _selectedCycle == 'college' ? _selectedType : _selectedStream,
    );

    setState(() => _isLoading = false);

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  Widget _buildTextField(String hint, IconData icon, TextEditingController ctrl,
      {TextInputType? type}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: ctrl,
        keyboardType: type ?? TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: kRoyalBlue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 16,
          color: Color(0xFF263238),
        ),
      ),
    );
  }

  Widget _buildToggleRow(List<String> options, String selected, Function(String) onSelect,
      {List<String>? values}) {
    return Row(
      children: List.generate(options.length, (i) {
        final isSelected = selected == (values != null ? values[i] : options[i]);
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: i < options.length - 1 ? 12 : 0),
            child: GestureDetector(
              onTap: () => setState(() {
                onSelect(values != null ? values[i] : options[i]);
                if (_selectedCycle == 'lycee') {
                  _selectedStream = null;
                }
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected ? kRoyalBlue : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isSelected ? kRoyalBlue : Colors.grey.shade300,
                    width: 1.5,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: kRoyalBlue.withOpacity(.2),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    options[i],
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildClassCard(int index, String name) {
    final isSelected = _selectedClassIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedClassIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? kRoyalBlue : Colors.transparent,
            width: 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? kRoyalBlue.withOpacity(.12)
                  : Colors.black.withOpacity(.04),
              blurRadius: isSelected ? 20 : 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? kRoyalBlue.withOpacity(.1) : const Color(0xFFEEF2F6),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.school,
                color: isSelected ? kRoyalBlue : Colors.grey.shade500,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isSelected ? kRoyalBlue : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedCycle == 'college' ? 'Collège' : 'Lycée',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: kRoyalBlue.withOpacity(.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: kRoyalBlue, size: 18),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreamSelector() {
    final streams = _availableStreams;
    if (streams.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('section'),
        const SizedBox(height: 4),
        // CORRECTION ICI : SUPPRESSION DU .toList() DANS LE SPREAD
        ...streams.map((s) {
          final isSelected = _selectedStream == s['id'];
          return GestureDetector(
            onTap: () => setState(() => _selectedStream = s['id']),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: isSelected ? kRoyalBlue.withOpacity(.06) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? kRoyalBlue : Colors.grey.shade200,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? kRoyalBlue : Colors.grey.shade400,
                        width: 2,
                      ),
                      color: isSelected ? kRoyalBlue : Colors.transparent,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 14),
                  Text(
                    s['name']!,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: isSelected ? kRoyalBlue : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          'Créer mon compte',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          children: [
            _buildSectionTitle('Informations personnelles'),
            _buildTextField('Nom complet', Icons.person_outline, _nameCtrl),
            _buildTextField('Email', Icons.email_outlined, _emailCtrl,
                type: TextInputType.emailAddress),
            _buildTextField('Établissement scolaire', Icons.school_outlined, _schoolCtrl),

            const SizedBox(height: 8),

            _buildSectionTitle('Cycle'),
            _buildToggleRow(
              ['Collège', 'Lycée'],
              _selectedCycle,
              (v) => setState(() {
                _selectedCycle = v;
                _selectedClassIndex = 0;
                _selectedStream = null;
              }),
              values: ['college', 'lycee'],
            ),

            const SizedBox(height: 20),

            _buildSectionTitle('Classe'),
            ...List.generate(_currentClassNames.length, (i) => _buildClassCard(i, _currentClassNames[i])),

            if (_selectedCycle == 'college') ...[
              const SizedBox(height: 8),
              _buildSectionTitle('Type d\'établissement'),
              _buildToggleRow(
                ['Classique', 'Pilote'],
                _selectedType,
                (v) => setState(() => _selectedType = v),
                values: ['classique', 'pilote'],
              ),
            ],

            if (_needsStream) ...[
              const SizedBox(height: 16),
              _buildStreamSelector(),
            ],

            const SizedBox(height: 24),

            if (_error != null)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade400, size: 22),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _error!,
                        style: TextStyle(color: Colors.red.shade700, fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),

            CustomButton(
              text: _isLoading ? 'Création en cours...' : 'Continuer',
              onPressed: _isLoading ? null : _handleSubmit,
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}