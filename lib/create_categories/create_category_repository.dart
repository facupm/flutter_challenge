import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'exceptions/category_already_exists.dart';

class CreateCategoryRepository {
  final CollectionReference itemsCollection =
  FirebaseFirestore.instance.collection('categories');

  Future<void> createCategory(String name) async {
    try {
      var item = await itemsCollection.doc(name).get();
      if(item.exists){
        throw CategoryAlreadyExistsException();
      }
      await itemsCollection.doc(name).set({
        'name': name
      });
    } catch (e) {
      rethrow;
    }
  }
}
