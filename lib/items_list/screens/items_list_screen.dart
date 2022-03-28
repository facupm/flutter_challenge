import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/complete_item_model.dart';
import 'package:flutter_challege/widgets/menu_drawer.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../utils/constants.dart';
import '../../utils/show_custom_snackbar.dart';
import '../../widgets/form_field_tag.dart';
import '../cubits/items_list_cubit.dart';
import '../repositories/items_list_repository.dart';

class ItemsListScreen extends StatefulWidget {
  @override
  _ItemsListScreen createState() => _ItemsListScreen();
}

class _ItemsListScreen extends State<ItemsListScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  Icon customIcon = const Icon(searchIcon);
  Widget customSearchBar = const Text('Shopping List');

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ItemsListCubit>(
      create: (context) => ItemsListCubit(ItemsListRepository())..getItems(),
      child: Builder(builder: (context) {
        final listBloc = BlocProvider.of<ItemsListCubit>(context);
        return Scaffold(
            appBar: AppBar(
              title: customSearchBar,
              actions: [
                IconButton(
                  onPressed: () => onPressSearch(listBloc),
                  icon: customIcon,
                )
              ],
            ),
            drawer: const MenuDrawer(),
            body: BlocBuilder(
              key: _formkey,
              bloc: listBloc,
              builder: (context, state) {
                if (state is LoadingItemsState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is ErrorState) {
                  CustomSnackBar(
                      "$errorMessage ${state.error}",
                      context);
                }
                if (state is AddedToFavorites) {
                  CustomSnackBar(
                      "Item added to favorites successfully", context);
                }
                if (state is AlreadyFavoriteErrorState) {
                  CustomSnackBar("Item is already on favorites", context);
                }
                if (state is SearchedState &&
                    listBloc.state.searchedList.isEmpty) {
                  return buildEmptySearch();
                }
                if (state is SearchedState) {
                  return buildItemsList(listBloc, listBloc.state.searchedList);
                }
                return buildItemsList(listBloc, listBloc.state.items);
              },
            ));
      }),
    );
  }

  Widget buildItemsList(
      ItemsListCubit listBloc, List<List<CompleteItemModel>> organizedItems) {
    if (listBloc.state.items.isEmpty) {
      return buildEmptyList();
    }
    return BlocBuilder(
      bloc: listBloc,
      builder: (context, state) => ListView.builder(
          itemCount: organizedItems.length,
          itemBuilder: (context, index) =>
              buildItemsByCategory(organizedItems[index], index, listBloc)),
    );
  }

  Widget buildItemsByCategory(List<CompleteItemModel> organizedItem,
      int categoryListIndex, ItemsListCubit listBloc) {
    var categoryName = organizedItem[0].category;
    return BlocBuilder(
      bloc: listBloc,
      builder: (context, state) => Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => deleteCategory(categoryName, listBloc),
              backgroundColor: deleteColor,
              foregroundColor: backgroundColor,
              icon: deleteIcon,
              label: 'Delete',
            ),
          ],
        ),
        child: ExpansionTile(
          title: FormFieldTag(name: categoryName),
          children: <Widget>[
            buildItemCards(organizedItem, categoryListIndex, listBloc)
          ],
          collapsedBackgroundColor: organizedItem[0].color,
          textColor: organizedItem[0].color,
          initiallyExpanded: true,
        ),
      ),
    );
  }

  Widget buildItemCards(List<CompleteItemModel> _items, int categoryListIndex,
      ItemsListCubit listBloc) {
    return BlocBuilder(
      bloc: listBloc,
      builder: (context, state) => ReorderableListView(
        shrinkWrap: true,
        children: <Widget>[
          for (int index = 0; index < _items.length; index++)
            Slidable(
              key: Key('$index'),
              startActionPane:
                  buildAddToFavoriteActionPane(listBloc, _items[index], index),
              endActionPane:
                  buildRemoveItemActionPane(listBloc, _items[index], index),
              child: buildItemCard(listBloc, _items[index], index),
            ),
        ],
        onReorder: (int oldIndex, int newIndex) {
          listBloc.rearrange(categoryListIndex, oldIndex, newIndex);
        },
      ),
    );
  }

  Widget buildItemCard(
      ItemsListCubit listBloc, CompleteItemModel item, int index) {
    return ListTile(
      key: Key('item$index'),
      title: Text(item.name),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(item.imageUrl),
      ),
      trailing: Wrap(
        spacing: 12,
        children: [
          IconButton(
              onPressed: () => listBloc.addToFavorite(item, index),
              icon: item.isFavorite
                  ? const Icon(
                      favoriteIcon,
                      color: favoriteColor,
                    )
                  : const Icon(Icons.favorite_border)),
          ReorderableDragStartListener(
            index: index,
            child: const Icon(dragIcon),
          ),
        ],
      ),
    );
  }

  ActionPane buildRemoveItemActionPane(
      ItemsListCubit listBloc, CompleteItemModel item, int index) {
    return ActionPane(
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
          onPressed: (context) => deleteItem(item, listBloc),
          backgroundColor: deleteColor,
          foregroundColor: backgroundColor,
          icon: deleteIcon,
          label: 'Delete',
        ),
      ],
    );
  }

  ActionPane buildAddToFavoriteActionPane(
      ItemsListCubit listBloc, CompleteItemModel item, int index) {
    return ActionPane(
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
          onPressed: (context) => listBloc.addToFavorite(item, index),
          backgroundColor: favoriteColor,
          foregroundColor: backgroundColor,
          icon: favoriteIcon,
          label: 'Favorite',
        ),
      ],
    );
  }

  void deleteItem(CompleteItemModel item, ItemsListCubit listBloc) {
    showDialog(
        context: _formkey.currentContext!,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Delete Item'),
            content: const Text('Are you sure to delete this item?'),
            actions: [
              TextButton(
                  onPressed: () {
                    listBloc.deleteItem(item);
                    Navigator.of(_formkey.currentContext!).pop();
                  },
                  child: const Text('Yes')),
              TextButton(
                  onPressed: () {
                    Navigator.of(_formkey.currentContext!).pop();
                  },
                  child: const Text('No'))
            ],
          );
        });
  }

  void deleteCategory(String category, ItemsListCubit listBloc) {
    showDialog(
        context: _formkey.currentContext!,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Delete Category'),
            content: SizedBox(
              height: 40,
              child: Column(
                children: const [
                  Text('Are you sure to delete this category?'),
                  SizedBox(height: 5),
                  Text(
                    '(Every item on this category will be also deleted)',
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    listBloc.deleteCategory(category);
                    Navigator.of(_formkey.currentContext!).pop();
                  },
                  child: const Text('Yes')),
              TextButton(
                  onPressed: () {
                    Navigator.of(_formkey.currentContext!).pop();
                  },
                  child: const Text('No'))
            ],
          );
        });
  }

  Widget buildEmptyList() {
    return Center(
      child: SizedBox(
        height: 40,
        child: Column(
          children: const [
            Text('Looks like there are no elements yet'),
            SizedBox(
              height: 5,
            ),
            Text('Create items and come back to see them here!')
          ],
        ),
      ),
    );
  }

  Widget buildEmptySearch() {
    return Center(
      child: SizedBox(
        height: 40,
        child: Column(
          children: const [
            Text('Oh oh. No elements found'),
          ],
        ),
      ),
    );
  }

  onPressSearch(ItemsListCubit listBloc) {
    setState(() {
      if (customIcon.icon == searchIcon) {
        customIcon = const Icon(Icons.cancel);
        customSearchBar = ListTile(
          leading: const Icon(
            searchIcon,
            color: backgroundColor,
            size: 25,
          ),
          title: TextField(
            decoration: const InputDecoration(
              hintText: 'Search...',
              hintStyle: TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
              border: InputBorder.none,
            ),
            style: const TextStyle(
              color: backgroundColor,
            ),
            onChanged: (value) => {listBloc.search(value)},
          ),
        );
      } else {
        listBloc.closeSearch();
        customIcon = const Icon(searchIcon);
        customSearchBar = const Text('Shopping List');
      }
    });
  }
}
