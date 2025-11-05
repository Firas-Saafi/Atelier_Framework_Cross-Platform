import 'package:flutter/material.dart';

class GlobalParams {
  static List<Map<String, dynamic>> menus = [
    {"title": "Accueil", "icon": Icon(Icons.home, color: Colors.blue), "route": "/home"},
    {"title": "Météo", "icon": Icon(Icons.sunny_snowing, color: Colors.blue), "route": "/meteo"},
    {"title": "Maps", "icon": Icon(Icons.location_on, color: Colors.blue), "route": "/maps"},
    {"title": "Contacts", "icon": Icon(Icons.phone, color: Colors.blue), "route": "/contacts"},
    {"title": "Messenger", "icon": Icon(Icons.messenger_outline, color: Colors.blue), "route": "/messenger"},
    {"title": "ChatBot", "icon": Icon(Icons.android, color: Colors.blue), "route": "/Chatbot"},
    {"title": "Paramètres", "icon": Icon(Icons.settings, color: Colors.blue), "route": "/parametres"},
    {"title": "Déconnexion", "icon": Icon(Icons.logout, color: Colors.blue), "route": "/authentification"},
  ];

  static List<Map<String, dynamic>> accueil = [
  {"image": AssetImage('images/meteo.png',), "route": "/meteo"},
  {"image": AssetImage('images/maps.png',), "route": "/maps"},
  {"image": AssetImage('images/contacts.png',), "route": "/contacts"},
  {"image": AssetImage('images/messenger.png',), "route": "/messenger"},
  {"image": AssetImage('images/chatbot.png',), "route": "/chatbot"},
  {"image": AssetImage('images/settings.png',), "route": "/parametres"},
  ];
}

