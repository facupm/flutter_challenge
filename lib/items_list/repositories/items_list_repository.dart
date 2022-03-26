import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_challege/items_list/models/complete_item_model.dart';

class ItemsListRepository {
  final CollectionReference itemsCollection =
      FirebaseFirestore.instance.collection('items');
  final CollectionReference categoriesCollection =
      FirebaseFirestore.instance.collection('categories');

  firebase_storage.FirebaseStorage firebaseStorage =
      firebase_storage.FirebaseStorage.instance;

  Future<List<CompleteItemModel>> getItems() async {
    List<CompleteItemModel> items = [];
    await itemsCollection
        .orderBy('category', descending: false)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        var item = CompleteItemModel(
          name: doc["name"],
          category: doc["category"],
          imageUrl: doc["imageUrl"],
          isFavorite: doc["isFavorite"],
        );
        items.add(item);
      });
    });
    await setColorOnItem(items);
    return items;
  }

  Future<DocumentSnapshot<Object?>> getCategory(String categoryName) async {
    return await itemsCollection.doc(categoryName).get();
  }

  Future<void> setColorOnItem(List<CompleteItemModel> items) async {
    if (items.isNotEmpty) {
      String categoryName = items[0].category;
      Color color = await getColorFromCategory(categoryName);
      for (var item in items) {
        if (item.category != categoryName) {
          categoryName = item.category;
          color = await getColorFromCategory(categoryName);
        }
        item.color = color;
      }
    }
  }

  Future<Color> getColorFromCategory(String category) async {
    int color = 0;
    await categoriesCollection
        .doc(category)
        .get()
        .then((doc) => color = doc["color"]);
    return Color(color);
  }

  Future<void> deleteItem(String name, String imageUrl) async {
    await itemsCollection.doc(name).delete();
    await firebaseStorage.refFromURL(imageUrl).delete();
  }

  Future<void> deleteCategory(String categoryName) async {
    await categoriesCollection.doc(categoryName).delete();
  }

  Future<void> addToFavorite(String name) async {
    await itemsCollection.doc(name).update({'isFavorite': true});
  }
}
