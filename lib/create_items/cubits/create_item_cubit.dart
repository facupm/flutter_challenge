import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challege/utils/form_validators.dart';

import '../repositories/create_item_repository.dart';

part '../states/create_item_state.dart';

class CreateItemCubit extends Cubit<CreateItemState> {
  // File? image;

  late final CreateItemRepository _createItemRepository;
  late final FieldValidators validators;

  CreateItemCubit(this._createItemRepository) : super(InitialState());

  Future<void> getCategories() async {
    List<String> list = await _createItemRepository.getCategories();
    state.categories = list;
    emit(CategoriesLoaded(
        state.image, state.name, list, state.selectedCategory));
  }

  void changeCategory(String? newCategory) {
    var message = FieldValidators.required(newCategory);
    if (message != null) {
      emit(CategoryErrorState(state.image, state.name, state.categories,
          state.selectedCategory, message));
      return;
    }
    state.selectedCategory = newCategory!;
    emit(
        CategoryLoaded(state.image, state.name, state.categories, newCategory));
  }

  void changeImage(File imageTemporary) {
    var message = FieldValidators.required(imageTemporary);
    if (message != null) {
      emit(ImageErrorState(state.image, state.name, state.categories,
          state.selectedCategory, message));
      return;
    }
    state.image = imageTemporary;
    emit(SuccessState(
        imageTemporary, state.name, state.categories, state.selectedCategory));
  }

  void changeName(String? value) {
    var message = FieldValidators.required(value);
    if (message != null) {
      emit(NameErrorState(state.image, state.name, state.categories,
          state.selectedCategory, message));
      return;
    }
    state.name = value!;
    emit(SuccessState(
        state.image, state.name, state.categories, state.selectedCategory));
  }

  Future<void> submit() async {
    try {
      emit(CreatingState(
          state.image, state.name, state.categories, state.selectedCategory));

      if(FieldValidators.required(state.image) != null){
        emit(ErrorState(state.image, state.name, state.categories,
            state.selectedCategory, 'You must select an image'));
        return;
      }
      if(FieldValidators.required(state.name) != null){
        emit(ErrorState(state.image, state.name, state.categories,
            state.selectedCategory, 'You must enter a name'));
        return;
      }
      if(FieldValidators.required(state.selectedCategory) != null){
        emit(ErrorState(state.image, state.name, state.categories,
            state.selectedCategory, 'You must select a category'));
        return;
      }

      await _createItemRepository.createItem(
          state.name, state.selectedCategory, state.image);
      state.name = "";
      state.selectedCategory = "";
      // category.clear();
      state.image = null;
      emit(CreatedSuccessfullyState());
    } on Exception catch (e) {
      emit(ErrorState(state.image, state.name, state.categories,
          state.selectedCategory, e.toString()));
    }
  }
}
