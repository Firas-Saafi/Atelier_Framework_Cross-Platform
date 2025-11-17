
import 'package:mongo_dart/mongo_dart.dart';


class Contact {
  ObjectId? id;
  String nom;
  String prenom;
  String telephone;
  String? email;
  String? imagePath;

  Contact({
    this.id,
    required this.nom,
    required this.prenom,
    required this.telephone,
    this.email,
    this.imagePath,
  });


  // Convertir un Contact en Map pour l'insertion dans MongoDB
  Map<String, dynamic> toMap() {
    return {
      if (id != null) '_id': id,
      'nom': nom,
      'prenom': prenom,
      'telephone': telephone,
      'email': email,
      'imagePath': imagePath,
    };
  }


  // Créer un Contact à partir d'un Map récupéré de MongoDB
  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['_id'] as ObjectId?,
      nom: map['nom'],
      prenom: map['prenom'],
      telephone: map['telephone'],
      email: map['email'],
      imagePath: map['imagePath'],
    );
  }
}

