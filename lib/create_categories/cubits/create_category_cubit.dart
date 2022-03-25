// import 'dart:async';
// import 'dart:io';
// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_challege/utils/form_validators.dart';
// import 'package:flutter_form_bloc/flutter_form_bloc.dart';
//
// import 'create_category_repository.dart';
// import 'create_category_state.dart';
//
// class CreateCategoryCubit extends FormBloc<String, Exception> {
//
//   final name = TextFieldBloc(
//     name: "name",
//     validators: [
//       FieldValidators.required,
//     ],
//   );
//
//   Color color = Colors.redAccent;
//
//   void changeColor(Color newColor){
//     color = newColor;
//     emitUpdatingFields();
//   }
//
//   final CreateCategoryRepository _createCategoryRepository;
//   CreateCategoryCubit(this._createCategoryRepository) {
//     addFieldBloc(fieldBloc: name);
//   }
//
//   @override
//   FutureOr<void> onSubmitting() async {
//     try {
//       await _createCategoryRepository.createCategory(name.value, color.toString());
//       name.clear();
//       color = Colors.redAccent;
//       emitSuccess();
//     } on Exception catch (e) {
//       emitFailure(failureResponse: e);
//     }
//   }
// }