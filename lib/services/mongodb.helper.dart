import 'package:mongo_dart/mongo_dart.dart';
import '../models/contact.model.dart';

class MongoDBHelper {
  static final MongoDBHelper instance = MongoDBHelper._init();
  static Db? _db;
  static DbCollection? _contactsCollection;

  // Remplacer par votre chaîne de connexion MongoDB Atlas
  static const String MONGO_URL =
      "mongodb+srv://<username>:<password>@cluster.xxxxx.mongodb.net/<dbname>?retryWrites=true&w=majority";
  static const String COLLECTION_NAME = "contacts";

  MongoDBHelper._init();

  Future<Db> get database async {
    if (_db != null && _db!.isConnected) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<DbCollection> get contactsCollection async {
    final db = await database;
    if (_contactsCollection == null) {
      _contactsCollection = db.collection(COLLECTION_NAME);
    }
    return _contactsCollection!;
  }

  Future<Db> _initDB() async {
    try {
      final db = await Db.create(MONGO_URL);
      await db.open();
      print('Connexion à MongoDB Atlas réussie');
      return db;
    } catch (e) {
      print('Erreur de connexion à MongoDB: $e');
      rethrow;
    }
  }

  Future<void> close() async {
    if (_db != null && _db!.isConnected) {
      await _db!.close();
      print('Connexion MongoDB fermée');
    }
  }

  Future<ObjectId> insertContact(Contact contact) async {
    try {
      final collection = await contactsCollection;
      final result = await collection.insertOne(contact.toMap());
      return result.id as ObjectId;
    } catch (e) {
      print('Erreur lors de l\'insertion: $e');
      rethrow;
    }
  }

  Future<List<Contact>> getAllContacts() async {
    try {
      final collection = await contactsCollection;
      final result = await collection.find().toList();
      return result.map((map) => Contact.fromMap(map)).toList();
    } catch (e) {
      print('Erreur lors de la récupération des contacts: $e');
      return [];
    }
  }

  Future<Contact?> getContactById(ObjectId id) async {
    try {
      final collection = await contactsCollection;
      final result = await collection.findOne(where.eq('_id', id));
      if (result != null) {
        return Contact.fromMap(result);
      }
      return null;
    } catch (e) {
      print('Erreur lors de la récupération du contact: $e');
      return null;
    }
  }

  Future<bool> updateContact(Contact contact) async {
    try {
      final collection = await contactsCollection;
      final result = await collection.updateOne(
        where.eq('_id', contact.id),
        modify
            .set('nom', contact.nom)
            .set('prenom', contact.prenom)
            .set('telephone', contact.telephone)
            .set('email', contact.email)
            .set('imagePath', contact.imagePath),
      );
      return result.isSuccess;
    } catch (e) {
      print('Erreur lors de la mise à jour: $e');
      return false;
    }
  }

  Future<bool> deleteContact(ObjectId id) async {
    try {
      final collection = await contactsCollection;
      final result = await collection.deleteOne(where.eq('_id', id));
      return result.isSuccess;
    } catch (e) {
      print('Erreur lors de la suppression: $e');
      return false;
    }
  }

  Future<List<Contact>> searchContacts(String query) async {
    try {
      final collection = await contactsCollection;
      final regex = RegExp(query, caseSensitive: false);
      final result = await collection
          .find(where
              .match('nom', query, caseInsensitive: true)
              .or(where.match('prenom', query, caseInsensitive: true))
              .or(where.match('telephone', query, caseInsensitive: true)))
          .toList();
      return result.map((map) => Contact.fromMap(map)).toList();
    } catch (e) {
      print('Erreur lors de la recherche: $e');
      return [];
    }
  }
}
