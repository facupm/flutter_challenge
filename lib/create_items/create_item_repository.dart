import 'package:cloud_firestore/cloud_firestore.dart';

import 'item_model.dart';

class CreateItemRepository {
  final CollectionReference itemsCollection =
      FirebaseFirestore.instance.collection('items');

  Future<void> createItem(String name, String category, String imageUrl) async {
    try {
      print("creating");
      await itemsCollection.doc(name).set({
        'name': name,
        'category': category,
        'imageUrl': imageUrl
      });
    } catch (e) {
      rethrow;
    }
  }
}
