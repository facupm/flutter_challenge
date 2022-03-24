
import 'package:equatable/equatable.dart';

import 'item_model.dart';

abstract class CreateItemState extends Equatable {}

class InitialState extends CreateItemState {
  @override
  List<Object> get props => [];
}

class CreatingState extends CreateItemState {
  @override
  List<Object> get props => [];
}

class CreatedState extends CreateItemState {
  CreatedState(this.item);

  final ItemModel item;

  @override
  List<Object> get props => [item];
}

class ErrorState extends CreateItemState {
  @override
  List<Object> get props => [];
}