import 'dart:ui';

class CompleteItemModel {
  CompleteItemModel({
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.isFavorite,
    this.favoriteDate,
  });

  final String name;
  final String category;
  final String imageUrl;
  late final Color? color;
  late bool isFavorite;
  late DateTime? favoriteDate;
}