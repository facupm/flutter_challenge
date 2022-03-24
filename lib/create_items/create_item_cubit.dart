import 'dart:async';
import 'dart:io';

import 'package:flutter_challege/create_items/item_model.dart';
import 'package:flutter_challege/utils/form_validators.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import 'create_item_repository.dart';
import 'exceptions/empty_image.dart';

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

  // final imageUrl = TextFieldBloc(
  //   name: "imageUrl",
  //   validators: [
  //     // FieldValidators.required,
  //   ],
  // );

  File? image;

  final CreateItemRepository _createItemRepository;
  CreateItemCubit(this._createItemRepository) {
    addFieldBlocs(fieldBlocs: [name, category]);
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
      if(image==null){
        throw Exception("la imagen no puede");
      }
      await _createItemRepository.createItem(name.value, category.value, image);
      name.clear();
      category.clear();
      image = null;
      emitSuccess();
    } on Exception catch (e) {
      emitFailure(failureResponse: e);
    }
  }
}