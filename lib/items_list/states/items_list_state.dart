part of '../cubits/items_list_cubit.dart';

abstract class ItemsListState {
  late List<List<CompleteItemModel>> items;
  late List<List<CompleteItemModel>> searchedList;
}

class InitialState extends ItemsListState {
  InitialState() {
    items = [];
    searchedList = [];
  }
}

class LoadingItemsState extends ItemsListState {
  LoadingItemsState(List<List<CompleteItemModel>> items) {
    this.items = items;
  }
}

class LoadedItemsState extends ItemsListState {
  LoadedItemsState(List<List<CompleteItemModel>> items) {
    this.items = items;
  }
}

class LoadedColors extends ItemsListState {
  LoadedColors(List<List<CompleteItemModel>> items) {
    this.items = items;
  }
}

class ItemsRearrangedState extends ItemsListState {
  ItemsRearrangedState(List<List<CompleteItemModel>> items) {
    this.items = items;
  }
}

class DeletedItemState extends ItemsListState {
  DeletedItemState(List<List<CompleteItemModel>> items) {
    this.items = items;
  }
}

class DeletedCategoryState extends ItemsListState {
  DeletedCategoryState(List<List<CompleteItemModel>> items) {
    this.items = items;
  }
}

class SearchedState extends ItemsListState {
  SearchedState(List<List<CompleteItemModel>> items,
      List<List<CompleteItemModel>> searchedList) {
    this.items = items;
    this.searchedList = searchedList;
  }
}

class AddedToFavorites extends ItemsListState {
  AddedToFavorites(List<List<CompleteItemModel>> items) {
    this.items = items;
  }
}

class ErrorState extends ItemsListState {
  final String error;

  ErrorState(List<List<CompleteItemModel>> items, this.error) {
    this.items = items;
  }
}

class AlreadyFavoriteErrorState extends ItemsListState {
  AlreadyFavoriteErrorState(List<List<CompleteItemModel>> items) {
    this.items = items;
  }
  // @override
  // bool operator == (Object other) {
  //   return false;
  // }
  //
  // @override
  // int get hashCode => items.hashCode;

}
