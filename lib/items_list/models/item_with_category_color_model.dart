import 'dart:ui';

class ItemWithColorModel {
  ItemWithColorModel({
    required this.name,
    required this.category,
    required this.imageUrl,
    // this.color,
  });

  final String name;
  final String category;
  final String imageUrl;
  late final Color? color;
}