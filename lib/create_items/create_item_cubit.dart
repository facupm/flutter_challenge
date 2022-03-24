import 'dart:async';

import 'package:flutter_challege/create_items/item_model.dart';
import 'package:flutter_challege/utils/form_validators.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import 'create_item_repository.dart';

class CreateItemCubit extends FormBloc<String, Exception> {

  final name = TextFieldBloc(
    name: "name",
    validators: [
      FieldValidators.required,
    ],
  );

  final category = TextFieldBloc(
    name: "category",
    validators: [
      FieldValidators.required,
    ],
  );

  final imageUrl = TextFieldBloc(
    name: "imageUrl",
    validators: [
      // FieldValidators.required,
    ],
  );

  final CreateItemRepository _createItemRepository;
  CreateItemCubit(this._createItemRepository) {
    addFieldBlocs(fieldBlocs: [name, category, imageUrl]);
  }

  void createItem(ItemModel item) async {
    // try {
    //   emit(CreatingState());
    //   await repository.createItem(item);
    //   emit(CreatedState(item));
    // } catch (e) {
    //   emit(ErrorState());
    // }
  }

  @override
  FutureOr<void> onSubmitting() async {
    try {
      print("submiting");
      print(name.value);
      await _createItemRepository.createItem(name.value, category.value, imageUrl.value);
      name.clear();
      category.clear();
      imageUrl.clear();
      emitSuccess();
    } catch (e) {
      rethrow;
    }
  }
}