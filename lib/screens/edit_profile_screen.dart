import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

const Color kPrimary = Color(0xff4F8CFF);
const Color kSecondary = Color(0xff6C63FF);
const Color kBackground = Color(0xffF8FAFC);

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _schoolController = TextEditingController();
  final _emailController = TextEditingController();

  String? _selectedClassLevel;
  String? _selectedStream;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AppProvider>(context, listen: false);
      final user = provider.user;
      if (user != null) {
        setState(() {
          _nameController.text = user.fullName;
          _schoolController.text = user.schoolName;
          _emailController.text = user.email;
          _selectedClassLevel = user.classLevel;
          _selectedStream = user.stream;
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _schoolController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        final user = provider.user;
        final photoUrl = user?.photoUrl;

        return Scaffold(
          backgroundColor: kBackground,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              "Modifier le profil",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.black87),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Center(
                  child: Hero(
                    tag: "profile",
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.15),
                            blurRadius: 25,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        backgroundImage: photoUrl != null && photoUrl.isNotEmpty
                            ? NetworkImage(photoUrl)
                            : null,
                        child: photoUrl == null || photoUrl.isEmpty
                            ? Text(
                                (user?.fullName ?? 'M')[0].toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.w900,
                                  color: kPrimary,
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("📷 Changement de photo à venir")),
                      );
                    },
                    icon: const Icon(Icons.camera_alt, size: 18),
                    label: const Text("Changer la photo"),
                  ),
                ),
                const SizedBox(height: 20),

                // Champs
                _buildTextField(_nameController, "Nom complet", "Entrez votre nom"),
                const SizedBox(height: 16),
                _buildTextField(_emailController, "Email", "votre@email.com", keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 16),
                _buildClassDropdown(),
                const SizedBox(height: 16),
                if (_selectedClassLevel != null && _shouldShowStream(_selectedClassLevel!))
                  _buildStreamDropdown(),
                if (_selectedClassLevel != null && _shouldShowStream(_selectedClassLevel!))
                  const SizedBox(height: 16),
                _buildTextField(_schoolController, "Établissement", "Nom de votre école/lycée"),

                const SizedBox(height: 32),

                // Bouton Enregistrer
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : () => _saveProfile(provider),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 4,
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            "Enregistrer les modifications",
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildClassDropdown() {
    const classes = [
      '7eme',
      '8eme',
      '9eme',
      '1ere',
      '2eme',
      '3eme',
      '4eme',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Classe",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedClassLevel,
          isExpanded: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            hintText: "Sélectionnez votre classe",
          ),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
          items: classes.map((cls) {
            return DropdownMenuItem(
              value: cls,
              child: Text(_displayClassName(cls)),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedClassLevel = value;
              if (value != null && !_shouldShowStream(value)) {
                _selectedStream = null;
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildStreamDropdown() {
    const streams = [
      'classique',
      'pilote',
      'sciences',
      'lettres',
      'economie',
      'tech_info',
      'math',
      'sciences_exp',
      'sciences_tech',
      'sciences_info',
      'sport',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Filière",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedStream,
          isExpanded: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            hintText: "Sélectionnez votre filière",
          ),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
          items: streams.map((stream) {
            return DropdownMenuItem(
              value: stream,
              child: Text(_displayStreamName(stream)),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedStream = value;
            });
          },
        ),
      ],
    );
  }

  /// La filière n'existe qu'à partir de la 2ème année secondaire.
  /// 1ère année = programme commun, pas de filière.
  bool _shouldShowStream(String classLevel) {
    return classLevel == '2eme' ||
        classLevel == '3eme' ||
        classLevel == '4eme';
  }

  String _displayClassName(String cls) {
    switch (cls) {
      case '7eme':
        return '7ème Année de Base';
      case '8eme':
        return '8ème Année de Base';
      case '9eme':
        return '9ème Année de Base';
      case '1ere':
        return '1ère Année Secondaire';
      case '2eme':
        return '2ème Année Secondaire';
      case '3eme':
        return '3ème Année Secondaire';
      case '4eme':
        return 'Baccalauréat';
      default:
        return cls;
    }
  }

  String _displayStreamName(String stream) {
    switch (stream) {
      case 'classique':
        return 'Classique';
      case 'pilote':
        return 'Pilote';
      case 'sciences':
        return 'Sciences';
      case 'lettres':
        return 'Lettres';
      case 'economie':
        return 'Économie & Gestion';
      case 'tech_info':
        return 'Technologie Info';
      case 'math':
        return 'Mathématiques';
      case 'sciences_exp':
        return 'Sciences Exp.';
      case 'sciences_tech':
        return 'Sciences Techniques';
      case 'sciences_info':
        return 'Sciences Info';
      case 'sport':
        return 'Sport';
      default:
        return stream;
    }
  }

  Future<void> _saveProfile(AppProvider provider) async {
    final name = _nameController.text.trim();
    final school = _schoolController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Le nom complet est requis")),
      );
      return;
    }

    if (_selectedClassLevel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Veuillez sélectionner une classe")),
      );
      return;
    }

    // La filière n'est obligatoire qu'à partir de la 2ème année
    if (_shouldShowStream(_selectedClassLevel!) && _selectedStream == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Veuillez sélectionner une filière")),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      await provider.updateProfile(
        fullName: name,
        schoolName: school,
        classLevel: _selectedClassLevel,
        stream: _selectedStream,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Profil mis à jour ! Matières et coefficients régénérés.")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Erreur : $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}