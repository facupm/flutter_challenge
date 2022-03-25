part of '../cubits/create_item_cubit.dart';

abstract class CreateItemState {
  File? image;
  late String name;
  late List<String> categories;
  late String selectedCategory;
}

class InitialState extends CreateItemState {
  InitialState() {
    image = null;
    name = "";
    categories = [];
    selectedCategory = "";
  }

  @override
  List<Object> get props => [];
}

class CreatingState extends CreateItemState {
  CreatingState(File? image, String name, List<String> categories,
      String selectedCategory) {
    this.image = image;
    this.name = name;
    this.categories = categories;
    this.selectedCategory = selectedCategory;
  }

  @override
  List<Object> get props => [];
}

class CreatedSuccessfullyState extends CreateItemState {
  CreatedSuccessfullyState() {
    image = null;
    name = "";
    categories = [];
    selectedCategory = "";
  }
}

class SuccessState extends CreateItemState {
  SuccessState(File? image, String name, List<String> categories,
      String selectedCategory) {
    this.image = image;
    this.name = name;
    this.categories = categories;
    this.selectedCategory = selectedCategory;
  }
}

class CategoryLoaded extends CreateItemState {
  CategoryLoaded(File? image, String name, List<String> categories,
      String selectedCategory) {
    this.image = image;
    this.name = name;
    this.categories = categories;
    this.selectedCategory = selectedCategory;
  }
}

class CategoriesLoaded extends CreateItemState {
  CategoriesLoaded(File? image, String name, List<String> categories,
      String selectedCategory) {
    this.image = image;
    this.name = name;
    this.categories = categories;
    this.selectedCategory = selectedCategory;
  }
}

class ErrorState extends CreateItemState {
  final String error;

  ErrorState(File? image, String name, List<String> categories,
      String selectedCategory, this.error) {
    this.image = image;
    this.name = name;
    this.categories = categories;
    this.selectedCategory = selectedCategory;
  }
}

class CategoryErrorState extends CreateItemState {
  final String error;

  CategoryErrorState(File? image, String name, List<String> categories,
      String selectedCategory, this.error) {
    this.image = image;
    this.name = name;
    this.categories = categories;
    this.selectedCategory = selectedCategory;
  }
}

class ImageErrorState extends CreateItemState {
  final String error;

  ImageErrorState(File? image, String name, List<String> categories,
      String selectedCategory, this.error) {
    this.image = image;
    this.name = name;
    this.categories = categories;
    this.selectedCategory = selectedCategory;
  }
}

class NameErrorState extends CreateItemState {
  final String error;

  NameErrorState(File? image, String name, List<String> categories,
      String selectedCategory, this.error) {
    this.image = image;
    this.name = name;
    this.categories = categories;
    this.selectedCategory = selectedCategory;
  }
}
