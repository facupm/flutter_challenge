
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
      var orderedList = organizeItems(list);
      state.items = orderedList;
      emit(LoadedItemsState(orderedList));
    } catch (e){
      emit(ErrorState(state.items, e.toString()));
    }
  }

  List<List<ItemWithColorModel>> organizeItems(List<ItemWithColorModel> items) {
    if (items.isEmpty) {
      return [];
    }
    List<List<ItemWithColorModel>> list = [];
    List<ItemWithColorModel> insideList = [];
    var category = items[0].category;
    for (var item in items) {
      if (item.category != category) {
        list.add(insideList);
        insideList = <ItemWithColorModel>[];
        category = item.category;
      }
      insideList.add(item);
    }
    list.add(insideList);
    return list;
  }

  void rearrange(int categoryListIndex, int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    ItemWithColorModel item = state.items[categoryListIndex].removeAt(oldIndex);
    state.items[categoryListIndex].insert(newIndex, item);
    emit(ItemsRearrangedState(state.items));
  }
}
