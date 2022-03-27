import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../models/complete_item_model.dart';

class FavoritesListRepository {
  final CollectionReference favoritesCollection =
  FirebaseFirestore.instance.collection('favorites');
  final CollectionReference categoriesCollection =
  FirebaseFirestore.instance.collection('categories');

  firebase_storage.FirebaseStorage firebaseStorage =
      firebase_storage.FirebaseStorage.instance;

  Future<List<CompleteItemModel>> getFavorites() async {
    List<CompleteItemModel> favorites = [];
    await favoritesCollection
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
        favorites.add(item);
      });
    });
    await setColorOnItem(favorites);
    return favorites;
  }

  Future<void> setColorOnItem(List<CompleteItemModel> favorites) async {
    if (favorites.isNotEmpty) {
      String categoryName = favorites[0].category;
      Color color = await getColorFromCategory(categoryName);
      for (var item in favorites) {
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
}
