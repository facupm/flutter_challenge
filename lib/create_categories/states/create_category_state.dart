part of '../cubits/create_category_cubit.dart';

abstract class CreateCategoryState {
  late String name;
  late Color? color;
}

class InitialState extends CreateCategoryState {
  InitialState() {
    name = "";
    color = Colors.redAccent;
  }
}

class SuccessState extends CreateCategoryState {
  SuccessState(name, color) {
    this.name = name;
    this.color = color;
  }
}

class CreatingState extends CreateCategoryState {
  CreatingState(name, color) {
    this.name = name;
    this.color = color;
  }
}

class ColorChangeState extends CreateCategoryState {
  ColorChangeState(name, color) {
    this.name = name;
    this.color = color;
  }
}

class CreatedSuccessfullyState extends CreateCategoryState {
  CreatedSuccessfullyState() {
    name = "";
    color = Colors.redAccent;
  }
}

class ErrorState extends CreateCategoryState {
  final String error;

  ErrorState(String name, Color? color, this.error) {
    this.name = name;
    this.color = color;
  }
}

class NameErrorState extends CreateCategoryState {
  final String error;

  NameErrorState(String name, Color color, this.error) {
    this.name = name;
    this.color = color;
  }
}