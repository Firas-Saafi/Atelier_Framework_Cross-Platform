import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InscriptionPage extends StatefulWidget {
  const InscriptionPage({super.key});
  State<InscriptionPage> createState() => _InscriptionPageState();
  
}

class _InscriptionPageState extends State<InscriptionPage> {
  late SharedPreferences prefs;

  TextEditingController txtLogin = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

   Future<void> onInscrire() async {
    // 1. Initialiser SharedPreferences
    prefs = await SharedPreferences.getInstance();
    // 2. Vérifier si les champs ne sont pas vides
    prefs.setBool("connecte", true);

    if (txtLogin.text.isNotEmpty && txtPassword.text.isNotEmpty) {
      // 3. Sauvegarder l'identifiant et le mot de passe
      prefs.setString("login", txtLogin.text);
      prefs.setString("password", txtPassword.text);
          prefs.setBool("connecte", true);
      // 4. Naviguer vers la page Home
            
            Navigator.pushReplacementNamed(context, '/home');
     } else {
           const snackBar = SnackBar(
        content: Text('Veuillez saisir l\'identifiant et le mot de passe.'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('inscription page'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: txtLogin,
                decoration:  InputDecoration(
                  labelText: 'Identifiant',
                  )),
              
              const SizedBox(height: 20),
              TextFormField(
                controller: txtPassword,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Mot de passe'),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: onInscrire,
                child:
                    const Text('Inscription', style: TextStyle(fontSize: 22)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/authentification');
                },
                child: const Text("J'ai déjà un compte",
                    style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
