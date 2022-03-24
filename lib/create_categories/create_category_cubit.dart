import 'dart:async';
import 'dart:io';

import 'package:flutter_challege/utils/form_validators.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import 'create_category_repository.dart';

class CreateCategoryCubit extends FormBloc<String, Exception> {

  final name = TextFieldBloc(
    name: "name",
    validators: [
      FieldValidators.required,
    ],
  );

  final CreateCategoryRepository _createCategoryRepository;
  CreateCategoryCubit(this._createCategoryRepository) {
    addFieldBloc(fieldBloc: name);
  }

  @override
  FutureOr<void> onSubmitting() async {
    try {
      await _createCategoryRepository.createCategory(name.value);
      name.clear();
      emitSuccess();
    } on Exception catch (e) {
      emitFailure(failureResponse: e);
    }
  }
}