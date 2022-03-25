import 'dart:async';
import 'dart:io';

import 'package:flutter_challege/create_items/item_model.dart';
import 'package:flutter_challege/utils/form_validators.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import 'create_item_repository.dart';
import 'exceptions/empty_image.dart';

class CreateItemCubit extends FormBloc<String, Exception> {


  File? image;

  final CreateItemRepository _createItemRepository;

  final name = TextFieldBloc(
    name: "name",
    validators: [
      FieldValidators.required,
    ],
  );

  final category = SelectFieldBloc(
    items: [""],
    validators: [FieldBlocValidators.required],
  );

  CreateItemCubit(this._createItemRepository) {
    addFieldBlocs(fieldBlocs: [name, category]);
  }

  Future<void> getCategories() async {
    emitLoading();
    category.updateItems(await _createItemRepository.getCategories());
    emitLoaded();
  }

  @override
  FutureOr<void> onSubmitting() async {
    try {
      if(image==null){
        throw EmptyImageException();
      }
      await _createItemRepository.createItem(name.value, category.value!, image);
      name.clear();
      category.clear();
      image = null;
      emitSuccess();
    } on Exception catch (e) {
      emitFailure(failureResponse: e);
    }
  }
}