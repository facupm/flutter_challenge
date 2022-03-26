import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/form_validators.dart';
import '../repositories/create_category_repository.dart';

part '../states/create_category_state.dart';

class CreateCategoryCubit extends Cubit<CreateCategoryState> {
  final CreateCategoryRepository _createCategoryRepository;

  CreateCategoryCubit(this._createCategoryRepository) : super(InitialState());

  void changeColor(Color newColor) {
    state.color = newColor;
    emit(ColorChangeState(state.name, newColor));
  }

  Future<void> submit() async {
    try {
      emit(CreatingState(state.name, state.color));


      if(FieldValidators.required(state.name) != null){
        emit(ErrorState(state.name, state.color!, "You must enter a name"));
        return;
      }
      if(FieldValidators.required(state.color) != null){
        emit(ErrorState(state.name, state.color, "You must select a color"));
        return;
      }

      await _createCategoryRepository.createCategory(
          state.name, state.color!.value);
      emit(CreatedSuccessfullyState());
    } on Exception catch (e) {
      emit(ErrorState(state.name, state.color!, e.toString()));
    }
  }

  void changeName(String? value) {
    var message = FieldValidators.required(value);
    if (message != null) {
      emit(NameErrorState(state.name, state.color!, message));
      return;
    }
    state.name = value!;
    emit(SuccessState(state.name, state.color));
  }
}
