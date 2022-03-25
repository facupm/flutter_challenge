part of '../cubits/items_list_cubit.dart';

abstract class ItemsListState {
  late List<ItemWithColorModel> items;
}

class InitialState extends ItemsListState {
  InitialState() {
    items = [];
  }
}

class LoadingItemsState extends ItemsListState {
  LoadingItemsState(List<ItemWithColorModel> items) {
    this.items = items;
  }
}

class LoadedItemsState extends ItemsListState {
  LoadedItemsState(List<ItemWithColorModel> items) {
    this.items = items;
  }
}

class LoadedColors extends ItemsListState {
  LoadedColors(List<ItemWithColorModel> items) {
    this.items = items;
  }
}

class ErrorState extends ItemsListState {
  final String error;

  ErrorState(List<ItemWithColorModel> items, this.error) {
    this.items = items;
  }
}
