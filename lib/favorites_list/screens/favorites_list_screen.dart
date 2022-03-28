import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/complete_item_model.dart';
import 'package:flutter_challege/widgets/menu_drawer.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../utils/show_custom_snackbar.dart';
import '../../widgets/form_field_tag.dart';
import '../cubits/favorites_list_cubit.dart';
import '../repositories/favorites_list_repository.dart';

class FavoritesListScreen extends StatelessWidget {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FavoritesListCubit>(
      create: (context) =>
          FavoritesListCubit(FavoritesListRepository())..getFavorites(),
      child: Builder(builder: (context) {
        final listBloc = BlocProvider.of<FavoritesListCubit>(context);
        return Scaffold(
            appBar: AppBar(
              title: const Text('Favorite List'),
            ),
            drawer: const MenuDrawer(),
            body: BlocBuilder(
              key: _formkey,
              bloc: listBloc,
              builder: (context, state) {
                if (state is LoadingFavoritesState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is ErrorState) {
                  CustomSnackBar(
                      "Something went wrong. Please try again: ${state.error}",
                      context);
                }
                if (state is RemovedToFavorites) {
                  CustomSnackBar(
                      "Item removed from favorites successfully", context);
                }
                if (listBloc.state.favorites.isEmpty) {
                  return buildEmptyList();
                }
                return buildFavoritesList(listBloc, listBloc.state.favorites);
              },
            ));
      }),
    );
  }

  Widget buildFavoritesList(FavoritesListCubit listBloc,
      List<List<CompleteItemModel>> organizedFavorites) {
    return BlocBuilder(
      bloc: listBloc,
      builder: (context, state) => ListView.builder(
          itemCount: organizedFavorites.length,
          itemBuilder: (context, index) => buildFavoritesByCategory(
              organizedFavorites[index], index, listBloc)),
    );
  }

  Widget buildFavoritesByCategory(List<CompleteItemModel> organizedItem,
      int categoryListIndex, FavoritesListCubit listBloc) {
    var categoryName = organizedItem[0].category;
    return BlocBuilder(
      bloc: listBloc,
      builder: (context, state) => ExpansionTile(
        title: FormFieldTag(name: categoryName),
        children: <Widget>[
          buildItemCards(organizedItem, categoryListIndex, listBloc)
        ],
        collapsedBackgroundColor: organizedItem[0].color,
        textColor: organizedItem[0].color,
        initiallyExpanded: true,
      ),
    );
  }

  Widget buildItemCards(List<CompleteItemModel> _favorites,
      int categoryListIndex, FavoritesListCubit listBloc) {
    return BlocBuilder(
      bloc: listBloc,
      builder: (context, state) => ReorderableListView(
        shrinkWrap: true,
        children: <Widget>[
          for (int index = 0; index < _favorites.length; index++)
            Slidable(
              key: Key('$index'),
              endActionPane: buildRemoveFavoriteActionPane(
                  listBloc, _favorites[index], index),
              child: buildItemCard(listBloc, _favorites[index], index),
            ),
        ],
        onReorder: (int oldIndex, int newIndex) {
          listBloc.rearrange(categoryListIndex, oldIndex, newIndex);
        },
      ),
    );
  }

  ActionPane buildRemoveFavoriteActionPane(
      FavoritesListCubit listBloc, CompleteItemModel favoriteItem, int index) {
    return ActionPane(
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
          onPressed: (context) =>
              listBloc.removeFromFavorites(favoriteItem, index),
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
          icon: Icons.heart_broken,
          label: 'Remove Favorite',
        ),
      ],
    );
  }

  Widget buildItemCard(
      FavoritesListCubit listBloc, CompleteItemModel favoriteItem, int index) {
    return ListTile(
      key: Key('item$index'),
      title: Text(favoriteItem.name),
      subtitle: Text(
        "Added on: ${getFormatedDate(favoriteItem.favoriteDate!)}",
        style: const TextStyle(color: Colors.grey),
      ),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(favoriteItem.imageUrl),
      ),
      trailing: Wrap(
        spacing: 12,
        children: [
          IconButton(
              onPressed: () =>
                  listBloc.removeFromFavorites(favoriteItem, index),
              icon: const Icon(
                Icons.favorite,
                color: Colors.redAccent,
              )),
          ReorderableDragStartListener(
            index: index,
            child: const Icon(Icons.drag_handle),
          ),
          // const Icon(Icons.drag_handle),
        ],
      ),
    );
  }

  Widget buildEmptyList() {
    return Center(
      child: SizedBox(
        height: 40,
        child: Column(
          children: const [
            Text('Looks like there are no favorites yet'),
            SizedBox(
              height: 5,
            ),
            Text('Add items to your favorites and come back to see them here!')
          ],
        ),
      ),
    );
  }

  String getFormatedDate(DateTime dateTime) {
    return "${dateTime.month}/${dateTime.day}/${dateTime.year}";
  }
}
