import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';

import '../exceptions/item_already_exists.dart';

class CreateItemRepository {
  final CollectionReference itemsCollection =
      FirebaseFirestore.instance.collection('items');
  final CollectionReference categoriesCollection =
  FirebaseFirestore.instance.collection('categories');
  firebase_storage.FirebaseStorage firebaseStorage =
      firebase_storage.FirebaseStorage.instance;

  Future<List<String>> getCategories() async{
    List<String> categoriesNames = [];
    await categoriesCollection
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        categoriesNames.add(doc["name"]);
      });
    });
    return categoriesNames;
  }

  Future<void> createItem(String name, String category, File? image) async {
    try {
      var item = await itemsCollection.doc(name).get();
      if(item.exists){
        throw ItemAlreadyExistsException();
      }
      String imageUrl = "";
      if (image != null) {
        String path =
            'images/${image.path.substring(image.path.lastIndexOf('/'), image.path.length)}';

        var storageReference = firebaseStorage.ref().child(path);
        TaskSnapshot snapshot = await storageReference.putFile(image);
        imageUrl = await snapshot.ref.getDownloadURL();
      }
      await itemsCollection.doc(name).set({
        'name': name,
        'category': category,
        'imageUrl': imageUrl,
        'isFavorite': false
      });
    } catch (e) {
      rethrow;
    }
  }
}
