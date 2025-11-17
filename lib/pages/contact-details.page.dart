import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/contact.model.dart';
import '../services/launcher.dart';
import '../services/mongodb.helper.dart';
import 'contact-form.page.dart';

class ContactDetailsPage extends StatefulWidget {
  final Contact contact;

  ContactDetailsPage({required this.contact});

  @override
  State<ContactDetailsPage> createState() => _ContactDetailsPageState();
}

class _ContactDetailsPageState extends State<ContactDetailsPage> {
  late Contact contact;

  @override
  void initState() {
    super.initState();
    contact = widget.contact;
  }

  Future<void> deleteContact() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmer la suppression'),
        content: Text('Voulez-vous vraiment supprimer ce contact ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await MongoDBHelper.instance.deleteContact(contact.id!);
      Navigator.pop(context, true);
    }
  }

  Future<void> editContact() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactFormPage(contact: contact),
      ),
    );

    if (result == true) {
      final updatedContact =
          await MongoDBHelper.instance.getContactById(contact.id!);
      if (updatedContact != null) {
        setState(() {
          contact = updatedContact;
        });
      }
    }
  }

  void copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label copié dans le presse-papier'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${contact.prenom} ${contact.nom}'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: editContact,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: deleteContact,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              color: Colors.blue[100],
              child: Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: contact.imagePath != null &&
                          File(contact.imagePath!).existsSync()
                      ? FileImage(File(contact.imagePath!))
                      : null,
                  child: contact.imagePath == null
                      ? Text(
                          '${contact.prenom[0]}${contact.nom[0]}',
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        )
                      : null,
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              '${contact.prenom} ${contact.nom}',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),

            // Actions rapides
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    FloatingActionButton(
                      heroTag: 'call',
                      onPressed: () {
                        LauncherService.makePhoneCall(
                            contact.telephone, context);
                      },
                      child: Icon(Icons.call),
                      backgroundColor: Colors.green,
                    ),
                    SizedBox(height: 8),
                    Text('Appeler'),
                  ],
                ),
                Column(
                  children: [
                    FloatingActionButton(
                      heroTag: 'sms',
                      onPressed: () {
                        LauncherService.sendSMS(contact.telephone, context);
                      },
                      child: Icon(Icons.message),
                      backgroundColor: Colors.blue,
                    ),
                    SizedBox(height: 8),
                    Text('Message'),
                  ],
                ),
                if (contact.email != null && contact.email!.isNotEmpty)
                  Column(
                    children: [
                      FloatingActionButton(
                        heroTag: 'email',
                        onPressed: () {
                          LauncherService.sendEmail(contact.email!, context);
                        },
                        child: Icon(Icons.email),
                        backgroundColor: Colors.orange,
                      ),
                      SizedBox(height: 8),
                      Text('Email'),
                    ],
                  ),
              ],
            ),

            SizedBox(height: 30),
            Divider(),

            // Informations détaillées
            ListTile(
              leading: Icon(Icons.phone, color: Colors.blue),
              title: Text('Téléphone'),
              subtitle: Text(contact.telephone),
              trailing: IconButton(
                icon: Icon(Icons.copy, size: 20),
                onPressed: () {
                  copyToClipboard(contact.telephone, 'Téléphone');
                },
              ),
            ),
            Divider(),
            if (contact.email != null && contact.email!.isNotEmpty)
              ListTile(
                leading: Icon(Icons.email, color: Colors.blue),
                title: Text('Email'),
                subtitle: Text(contact.email!),
                trailing: IconButton(
                  icon: Icon(Icons.copy, size: 20),
                  onPressed: () {
                    copyToClipboard(contact.email!, 'Email');
                  },
                ),
              ),
            if (contact.email != null && contact.email!.isNotEmpty) Divider(),
          ],
        ),
      ),
    );
  }
}
