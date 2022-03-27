import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/complete_item_model.dart';
import '../repositories/favorites_list_repository.dart';

part '../states/favorites_list_state.dart';

class FavoritesListCubit extends Cubit<FavoritesListState> {
  late final FavoritesListRepository _favoritesListRepository;

  FavoritesListCubit(this._favoritesListRepository) : super(InitialState());

  Future<void> getFavorites() async {
    try {
      emit(LoadingFavoritesState(state.favorites));
      var list = await _favoritesListRepository.getFavorites();
      var orderedList = organizeFavorites(list);
      state.favorites = orderedList;
      emit(LoadedFavoritesState(orderedList));
    } catch (e) {
      emit(ErrorState(state.favorites, e.toString()));
    }
  }

  List<List<CompleteItemModel>> organizeFavorites(List<CompleteItemModel> items) {
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
    CompleteItemModel item = state.favorites[categoryListIndex].removeAt(oldIndex);
    state.favorites[categoryListIndex].insert(newIndex, item);
    emit(ItemsRearrangedState(state.favorites));
  }

  removeFromFavorites(CompleteItemModel favorite) {}
}
