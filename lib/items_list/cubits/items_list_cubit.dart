
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/item_with_category_color_model.dart';
import '../repositories/items_list_repository.dart';

part '../states/items_list_state.dart';

class ItemsListCubit extends Cubit<ItemsListState> {

  late final ItemsListRepository _itemsListRepository;

  ItemsListCubit(this._itemsListRepository) : super(InitialState());

  Future<void> getItems() async {
    try {
      emit(LoadingItemsState(state.items));
      var list = await _itemsListRepository.getItems();
      state.items = list;
      emit(LoadedItemsState(list));
    } catch (e){
      emit(ErrorState(state.items, e.toString()));
    }
  }

  // Future<void> getCategories() async {
  //   var categoryColors = await _itemsListRepository.getCategory(categoryName);
  //   emit(LoadedColors(items, categoryColors));
  //   return Color(int.parse(categoryJson["color"]));
  // }
}
