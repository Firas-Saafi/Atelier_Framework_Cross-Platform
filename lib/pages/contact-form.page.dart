import 'package:flutter/material.dart';
import '../models/contact.model.dart';
import '../services/mongodb.helper.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ContactFormPage extends StatefulWidget {
  final Contact? contact;

  ContactFormPage({this.contact});

  @override
  State<ContactFormPage> createState() => _ContactFormPageState();
}

class _ContactFormPageState extends State<ContactFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomController;
  late TextEditingController _prenomController;
  late TextEditingController _telephoneController;
  late TextEditingController _emailController;
  String? imagePath;

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController(text: widget.contact?.nom ?? '');
    _prenomController = TextEditingController(text: widget.contact?.prenom ?? '');
    _telephoneController = TextEditingController(text: widget.contact?.telephone ?? '');
    _emailController = TextEditingController(text: widget.contact?.email ?? '');
    imagePath = widget.contact?.imagePath;
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _telephoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> saveContact() async {
    if (_formKey.currentState!.validate()) {
      // Créer l'objet Contact avec les données du formulaire
      final contact = Contact(
        id: widget.contact?.id,
        nom: _nomController.text,
        prenom: _prenomController.text,
        telephone: _telephoneController.text,
        email: _emailController.text.isEmpty ? null : _emailController.text,
        imagePath: imagePath,
      );

      try {
        // Sauvegarder dans MongoDB
        if (widget.contact == null) {
          // Mode ajout
          await MongoDBHelper.instance.insertContact(contact);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Contact ajouté avec succès')),
          );
        } else {
          // Mode modification
          await MongoDBHelper.instance.updateContact(contact);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Contact modifié avec succès')),
          );
        }

        // Retourner à la page précédente avec succès
        Navigator.pop(context, true);
      } catch (e) {
        // Afficher un message d'erreur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la sauvegarde: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
 final ImagePicker _picker = ImagePicker();


  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );


      if (pickedFile != null) {
        setState(() {
          imagePath = pickedFile.path;
        });
      }
    } catch (e) {
      print('Erreur lors de la sélection de l\'image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la sélection de l\'image')),
      );
    }
  }


  Future<void> showImageSourceDialog() async {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Galerie'),
              onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Caméra'),
             


               onTap: () {
                Navigator.pop(context);
                pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact == null ? 'Nouveau contact' : 'Modifier contact'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: showImageSourceDialog,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
            backgroundImage: imagePath != null && File(imagePath!).existsSync()
                      ? FileImage(File(imagePath!))
                      : null,
                  child: imagePath == null
           ? Icon(Icons.add_a_photo, size: 40, color: Colors.grey[600])
                      : null,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Appuyez pour ajouter une photo',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 24),

              TextFormField(
                controller: _nomController,
                decoration: InputDecoration(
                  labelText: 'Nom',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un nom';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _prenomController,
                decoration: InputDecoration(
                  labelText: 'Prénom',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un prénom';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _telephoneController,
                decoration: InputDecoration(
                  labelText: 'Téléphone',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un numéro de téléphone';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email (optionnel)',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: saveContact,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                ),
                child: Text(
                  widget.contact == null ? 'Ajouter' : 'Modifier',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}