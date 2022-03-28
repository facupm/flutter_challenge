import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/complete_item_model.dart';
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
    } catch (e) {
      emit(ErrorState(state.items, e.toString()));
    }
  }

  List<List<CompleteItemModel>> organizeItems(List<CompleteItemModel> items) {
    if (items.isEmpty) {
      return [];
    }
    List<List<CompleteItemModel>> list = [];
    List<CompleteItemModel> insideList = [];
    var category = items[0].category;
    for (var item in items) {
      if (item.category != category) {
        list.add(insideList);
        insideList = <CompleteItemModel>[];
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
    CompleteItemModel item = state.items[categoryListIndex].removeAt(oldIndex);
    state.items[categoryListIndex].insert(newIndex, item);
    emit(ItemsRearrangedState(state.items));
  }

  Future<void> deleteItem(CompleteItemModel item) async {
    try{
      emit(LoadingItemsState(state.items));
      var categoryIndex = 0;
      var itemIndex = 0;
      for (var list in state.items) {
        if (list[0].category == item.category) {
          for (var itemInList in list) {
            if (itemInList.name == item.name) {
              break;
            }
            itemIndex++;
          }
          break;
        }
        categoryIndex++;
      }
      state.items[categoryIndex].removeAt(itemIndex);
      state.items.removeWhere((element) => element.isEmpty);
      await _itemsListRepository.deleteItem(item.name, item.imageUrl);
      emit(DeletedItemState(state.items));
    }catch (e){
      emit(ErrorState(state.items, e.toString()));
    }
  }

  Future<void> deleteCategory(String categoryName) async {
    try{
      emit(LoadingItemsState(state.items));
      var categoryItems = [];
      var index = 0;
      for (var list in state.items) {
        if (list[0].category == categoryName) {
          categoryItems = list;
          break;
        }
        index++;
      }
      for (var item in categoryItems) {
        await _itemsListRepository.deleteItem(item.name, item.imageUrl);
      }
      state.items.removeAt(index);
      await _itemsListRepository.deleteCategory(categoryName);
      emit(DeletedCategoryState(state.items));
    }catch (e){
      emit(ErrorState(state.items, e.toString()));
    }
  }

  search(String value) {
    if (value != "") {
      List<List<CompleteItemModel>> categoriesList = [];
      for (var list in state.items) {
        if (list[0].category == value) {
          categoriesList.add(list);
          continue;
        } else {
          List<CompleteItemModel> itemList = [];
          for (var itemInList in list) {
            if (itemInList.name == value) {
              itemList.add(itemInList);
              break;
            }
          }
          if (itemList.isNotEmpty) {
            categoriesList.add(itemList);
          }
        }
      }
      state.searchedList = categoriesList;
    }
    emit(SearchedState(state.items, state.searchedList));
  }

  void closeSearch() {
    emit(LoadedItemsState(state.items));
  }

  Future<void> addToFavorite(CompleteItemModel item, int index) async {
    if (item.isFavorite) {
      emit(AlreadyFavoriteErrorState(state.items));
    } else {
      try {
        await _itemsListRepository.addToFavorite(item.name);
        for(var categories in state.items){
          if(categories[0].category == item.category){
            categories[index].isFavorite = true;
            break;
          }
        }
        emit(AddedToFavorites(state.items));
      } catch (e) {
        emit(ErrorState(state.items, e.toString()));
      }
    }
  }
}
