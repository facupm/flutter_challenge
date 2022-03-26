part of '../cubits/items_list_cubit.dart';

abstract class ItemsListState {
  late List<List<ItemWithColorModel>> items;
  late List<List<ItemWithColorModel>> searchedList;
}

class InitialState extends ItemsListState {
  InitialState() {
    items = [];
    searchedList = [];
  }
}

class LoadingItemsState extends ItemsListState {
  LoadingItemsState(List<List<ItemWithColorModel>> items) {
    this.items = items;
  }
}

class LoadedItemsState extends ItemsListState {
  LoadedItemsState(List<List<ItemWithColorModel>> items) {
    this.items = items;
  }
}

class LoadedColors extends ItemsListState {
  LoadedColors(List<List<ItemWithColorModel>> items) {
    this.items = items;
  }
}

class ItemsRearrangedState extends ItemsListState {
  ItemsRearrangedState(List<List<ItemWithColorModel>> items) {
    this.items = items;
  }
}

class DeletedItemState extends ItemsListState {
  DeletedItemState(List<List<ItemWithColorModel>> items) {
    this.items = items;
  }
}

class DeletedCategoryState extends ItemsListState {
  DeletedCategoryState(List<List<ItemWithColorModel>> items) {
    this.items = items;
  }
}

class SearchedState extends ItemsListState {
  SearchedState(List<List<ItemWithColorModel>> items,
      List<List<ItemWithColorModel>> searchedList) {
    this.items = items;
    this.searchedList = searchedList;
  }
}

class ErrorState extends ItemsListState {
  final String error;

  ErrorState(List<List<ItemWithColorModel>> items, this.error) {
    this.items = items;
  }
}
