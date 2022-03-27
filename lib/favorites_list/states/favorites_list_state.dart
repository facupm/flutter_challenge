part of '../cubits/favorites_list_cubit.dart';

abstract class FavoritesListState {
  late List<List<CompleteItemModel>> favorites;
}

class InitialState extends FavoritesListState {
  InitialState() {
    favorites = [];
  }
}

class LoadingFavoritesState extends FavoritesListState {
  LoadingFavoritesState(List<List<CompleteItemModel>> favorites) {
    this.favorites = favorites;
  }
}

class LoadedFavoritesState extends FavoritesListState {
  LoadedFavoritesState(List<List<CompleteItemModel>> favorites) {
    this.favorites = favorites;
  }
}

class RemovedToFavorites extends FavoritesListState {
  RemovedToFavorites(List<List<CompleteItemModel>> favorites) {
    this.favorites = favorites;
  }
}

class FavoritesRearrangedState extends FavoritesListState {
  FavoritesRearrangedState(List<List<CompleteItemModel>> favorites) {
    this.favorites = favorites;
  }
}

class ErrorState extends FavoritesListState {
  final String error;

  ErrorState(List<List<CompleteItemModel>> favorites, this.error) {
    this.favorites = favorites;
  }
}