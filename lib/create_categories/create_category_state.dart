
import 'dart:ui';

import 'package:equatable/equatable.dart';

abstract class CreateCategoryState extends Equatable {}

class InitialState extends CreateCategoryState {
  final Color color;
  InitialState(this.color);

  @override
  List<Object?> get props => throw UnimplementedError();
}

class ColorChange extends CreateCategoryState {
  final Color color;
  ColorChange(this.color);

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

}