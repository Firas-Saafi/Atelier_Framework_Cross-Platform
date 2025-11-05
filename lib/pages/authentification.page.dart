import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthentificationPage extends StatefulWidget {
  const AuthentificationPage({super.key});
  @override
  State<AuthentificationPage> createState() => _AuthentificationPageState();
}

class _AuthentificationPageState extends State<AuthentificationPage> {
  // Déclarer les contrôleurs pour les champs de texte
  TextEditingController txtLogin = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  late SharedPreferences prefs;

  @override
  void dispose() {
    txtLogin.dispose();
    txtPassword.dispose();
    super.dispose();
  }

  Future<void> onAuthentifier() async {
    // 1. Initialiser SharedPreferences
    prefs = await SharedPreferences.getInstance();
    // 2. Vérifier si les champs ne sont pas vides
    if (txtLogin.text.isNotEmpty && txtPassword.text.isNotEmpty) {
      // 3. Récupérer les données sauvegardées
      String? savedLogin = prefs.getString("login");
      String? savedPassword = prefs.getString("password");

      // 4. Vérifier si les identifiants correspondent
      if (savedLogin != null &&
          savedPassword != null &&
          txtLogin.text == savedLogin &&
          txtPassword.text == savedPassword) {
        // 5. Marquer l'utilisateur comme connecté
        prefs.setBool("connecte", true);
        const snackBar = SnackBar(
          content: Text('Connection avec succes'),
          backgroundColor: Color.fromARGB(255, 54, 244, 79),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pushReplacementNamed(context, '/home');
       
      } else {
        const snackBar = SnackBar(
          content: Text('Identifiant ou mot de passe incorrect.'),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Authentification'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              TextFormField(
                controller: txtLogin,
                decoration: const InputDecoration(
                  labelText: 'Identifiant',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                  ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: txtPassword,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: onAuthentifier,
                child: const Text('Connexion', style: TextStyle(fontSize: 22)),
                
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/inscription');
                },
      child: const Text("Nouvel Utilisateur", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
