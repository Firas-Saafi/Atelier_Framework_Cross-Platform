import 'dart:io';

import 'package:flutter/material.dart';
import '../menu/drawer.widget.dart';
import '../models/contact.model.dart';
import '../services/mongodb.helper.dart';
import 'contact-details.page.dart';
import 'contact-form.page.dart';

class Contacts extends StatefulWidget {
  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  List<Contact> contacts = [];
  bool isLoading = true;
 List<Contact> filteredContacts = [];
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  Future<void> loadContacts() async {
    setState(() {
      isLoading = true;
    });
    
    final data = await MongoDBHelper.instance.getAllContacts();
    
    setState(() {
      contacts = data;
      isLoading = false;
      filteredContacts = data;
    });
  }
void searchContacts(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredContacts = contacts;
      });
    } else {
      setState(() {
        filteredContacts = contacts.where((contact) {
          final fullName = '${contact.prenom} ${contact.nom}'.toLowerCase();
          final telephone = contact.telephone.toLowerCase();
          final searchLower = query.toLowerCase();
          return fullName.contains(searchLower) || telephone.contains(searchLower);
        }).toList();
      });
    }
  }

  Future<void> navigateToForm({Contact? contact}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactFormPage(contact: contact),
      ),
    );

    if (result == true) {
      loadContacts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                controller: searchController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Rechercher...',
                  hintStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                ),
                autofocus: true,
                onChanged: searchContacts,
              )
            : Text('Contacts (${contacts.length})'),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  searchController.clear();
                  filteredContacts = contacts;
                }
              });
            },
          ),
        ],
      ),

      drawer: MyDrawer(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : filteredContacts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.contacts_outlined, size: 100, color: Colors.grey),
                      SizedBox(height: 20),
                      Text(
                        'Aucun contact',
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Appuyez sur + pour ajouter un contact',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: filteredContacts.length,
                  itemBuilder: (context, index) {
                    final contact = filteredContacts[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue[200],
                        backgroundImage: contact.imagePath != null && File(contact.imagePath!).existsSync()
                        ? FileImage(File(contact.imagePath!))
                        : null,
                    child: contact.imagePath == null
                        ? Text(
                            '${contact.prenom[0]}${contact.nom[0]}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        : null,
                      ),
                      title: Text('${contact.prenom} ${contact.nom}'),
                      subtitle: Text(contact.telephone),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ContactDetailsPage(contact: contact),
    ),
  );

  if (result == true) {
    loadContacts();
  }
},
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToForm();
        },
        child: Icon(Icons.add),
        tooltip: 'Ajouter un contact',
      ),
    );
  }
}