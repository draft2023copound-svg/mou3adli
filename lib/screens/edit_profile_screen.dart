import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../data/options_curriculum.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameCtrl = TextEditingController();
  final _schoolCtrl = TextEditingController();

  String? _selectedClassLevel;
  String? _selectedStream;
  String? _selectedOption;
  bool _isLoading = false;
  bool _isUploadingPhoto = false;

  final List<String> _allClassLevels = [
    '7eme', '8eme', '9eme',
    '1ere', '2eme', '3eme', '4eme',
  ];

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() {
    final user = context.read<AppProvider>().user;
    if (user != null) {
      _nameCtrl.text = user.fullName;
      _schoolCtrl.text = user.schoolName;
      _selectedClassLevel = user.classLevel;
      _selectedStream = user.stream;
      _selectedOption = user.optionId;
    }
  }

  Future<void> _saveProfile() async {
    if (_nameCtrl.text.trim().isEmpty || _schoolCtrl.text.trim().isEmpty) {
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

    setState(() => _isLoading = true);

    final provider = context.read<AppProvider>();
    await provider.updateProfile(
      fullName: _nameCtrl.text.trim(),
      schoolName: _schoolCtrl.text.trim(),
      classLevel: _selectedClassLevel,
      stream: _selectedStream,
      optionId: _selectedOption,
    );

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Profil mis à jour !")),
      );
      Navigator.pop(context);
    }
  }

  bool _shouldShowStream(String classLevel) {
    return classLevel == '7eme' ||
        classLevel == '8eme' ||
        classLevel == '9eme' ||
        classLevel == '1ere' ||
        classLevel == '2eme' ||
        classLevel == '3eme' ||
        classLevel == '4eme';
  }

  bool _shouldShowOption() {
    return OptionCurriculum.hasOptions(_selectedClassLevel ?? '', _selectedStream);
  }

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

  // ═══════════════════════════════════════════════════════════
  // 📸 PHOTO DE PROFIL — FONCTIONNEL À 100%
  // ═══════════════════════════════════════════════════════════

  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context); // Ferme le bottom sheet

    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );

    if (picked == null) return;

    setState(() => _isUploadingPhoto = true);

    final provider = context.read<AppProvider>();
    final success = await provider.updateProfilePhoto(File(picked.path));

    setState(() => _isUploadingPhoto = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Photo de profil mise à jour !'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Erreur lors de la sauvegarde de la photo'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _removePhoto() async {
    Navigator.pop(context); // Ferme le bottom sheet

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.delete_outline, color: Colors.red),
            SizedBox(width: 10),
            Text("Supprimer la photo", style: TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
        content: const Text("Es-tu sûr de vouloir supprimer ta photo de profil ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Annuler", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Supprimer"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isUploadingPhoto = true);

    final provider = context.read<AppProvider>();
    final success = await provider.removeProfilePhoto();

    setState(() => _isUploadingPhoto = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
              ? '🗑️ Photo supprimée'
              : '❌ Erreur lors de la suppression'),
          backgroundColor: success ? Colors.orange : Colors.red,
        ),
      );
    }
  }

  void _showPhotoOptions(BuildContext context) {
    final user = context.read<AppProvider>().user;
    final hasPhoto = user?.photoUrl != null && user!.photoUrl!.isNotEmpty;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Indicateur de drag
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Photo de profil',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Personnalise ton avatar',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 24),
                // Galerie
                _PhotoOptionTile(
                  icon: Icons.photo_library_outlined,
                  label: 'Choisir depuis la galerie',
                  color: const Color(0xFF1C3F7A),
                  onTap: () => _pickImage(ImageSource.gallery),
                ),
                const SizedBox(height: 10),
                // Caméra
                _PhotoOptionTile(
                  icon: Icons.camera_alt_outlined,
                  label: 'Prendre une photo',
                  color: const Color(0xFF3B82F6),
                  onTap: () => _pickImage(ImageSource.camera),
                ),
                if (hasPhoto) ...[
                  const SizedBox(height: 10),
                  _PhotoOptionTile(
                    icon: Icons.delete_outline_rounded,
                    label: 'Supprimer la photo',
                    color: Colors.red,
                    onTap: _removePhoto,
                  ),
                ],
                const SizedBox(height: 10),
                // Annuler
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Annuler',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfilePhotoSection() {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final user = provider.user;
        final displayName = user?.fullName ?? 'Élève';
        final photoUrl = user?.photoUrl;
        final hasPhoto = photoUrl != null && photoUrl.isNotEmpty;

        return Center(
          child: Column(
            children: [
              const SizedBox(height: 8),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  // Avatar principal
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF1C3F7A).withOpacity(0.15),
                        width: 3,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: const Color(0xFF1C3F7A).withOpacity(0.08),
                      backgroundImage: hasPhoto ? FileImage(File(photoUrl)) : null,
                      child: !hasPhoto
                          ? Text(
                              displayName.isNotEmpty
                                  ? displayName[0].toUpperCase()
                                  : 'M',
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF1C3F7A),
                              ),
                            )
                          : null,
                    ),
                  ),
                  // Bouton stylo
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: GestureDetector(
                      onTap: _isUploadingPhoto
                          ? null
                          : () => _showPhotoOptions(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C3F7A),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF1C3F7A).withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: _isUploadingPhoto
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons.edit_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                displayName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Appuie sur le stylo pour changer ta photo',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
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
          'Modifier le profil',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.black87),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          children: [
            // ═══ PHOTO DE PROFIL ═══
            _buildProfilePhotoSection(),
            const SizedBox(height: 16),

            // ═══ CHAMPS DU FORMULAIRE ═══
            _buildTextField('Nom complet', Icons.person_outline, _nameCtrl),
            _buildTextField('École', Icons.school_outlined, _schoolCtrl),
            const SizedBox(height: 20),
            _buildClassDropdown(),
            if (_shouldShowStream(_selectedClassLevel ?? '')) ...[
              const SizedBox(height: 20),
              _buildStreamDropdown(),
            ],
            if (_shouldShowOption()) ...[
              const SizedBox(height: 20),
              _buildOptionDropdown(),
            ],
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1C3F7A),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Enregistrer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, IconData icon, TextEditingController ctrl) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: ctrl,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: const Color(0xFF1C3F7A)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildClassDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Classe', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.black87)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedClassLevel,
          isExpanded: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            hintText: "Sélectionnez votre classe",
          ),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
          items: _allClassLevels.map((level) {
            return DropdownMenuItem(value: level, child: Text(_displayClassName(level)));
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

  Widget _buildStreamDropdown() {
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
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.black87)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedStream,
          isExpanded: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            hintText: hint,
          ),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
          items: streams.map((stream) {
            return DropdownMenuItem(value: stream, child: Text(_displayStreamName(stream)));
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

  Widget _buildOptionDropdown() {
    final options = OptionCurriculum.getAllOptions();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Option", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.black87)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedOption,
          isExpanded: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            hintText: "Choisissez votre option",
          ),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
          items: options.map((opt) {
            return DropdownMenuItem(
              value: opt['id'] as String,
              child: Text(opt['nameFr'] as String),
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
}

// ═══════════════════════════════════════════════════════════
// WIDGET PRIVÉ : Option du bottom sheet photo
// ═══════════════════════════════════════════════════════════

class _PhotoOptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _PhotoOptionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: color.withOpacity(0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.15)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: color.withOpacity(0.5),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}