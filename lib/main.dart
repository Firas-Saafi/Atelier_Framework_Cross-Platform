import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/authentification.page.dart';
import 'pages/chatbot.page.dart';
import 'pages/contacts.page.dart';
import 'pages/home.page.dart';
import 'pages/inscription.page.dart';
import 'pages/maps.page.dart';
import 'pages/messenger.page.dart';
import 'pages/meteo.page.dart';
import 'pages/parametres.page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
static final routes = {
    '/home': (context) => HomePage(),
    '/inscription': (context) => InscriptionPage(),
    '/authentification': (context) => AuthentificationPage(),
    '/meteo': (context) => Meteo(),
    '/chatbot': (context) => ChatBot(),
    '/contacts': (context) => Contacts(),
    '/maps': (context) => Maps(),
    '/messenger': (context) => Messenger(),
    '/parametres': (context) => Parametres(),
  };

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: routes,
      home: FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            bool conn = snapshot.data?.getBool('connecte') ?? false;
            if (conn) {
              return HomePage();
            }
          }
          return AuthentificationPage();
        }
      )

    );
  }
}
