import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challege/items_list/models/item_with_category_color_model.dart';
import 'package:flutter_challege/widgets/menu_drawer.dart';

import '../../utils/show_custom_snackbar.dart';
import '../cubits/items_list_cubit.dart';
import '../repositories/items_list_repository.dart';

class ItemsListScreen extends StatelessWidget {
  final String title = 'Create Item';

  const ItemsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ItemsListCubit>(
      create: (context) => ItemsListCubit(ItemsListRepository())..getItems(),
      child: Builder(builder: (context) {
        final listBloc = BlocProvider.of<ItemsListCubit>(context);
        return Scaffold(
            // backgroundColor: Constants.kPrimaryColor,
            appBar: AppBar(title: Text(title)),
            drawer: const MenuDrawer(),
            body: BlocBuilder(
              bloc: listBloc,
              builder: (context, state) {
                if (state is LoadingItemsState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is ErrorState) {
                  CustomSnackBar(
                      "Something went wrong. Please try again: ${state.error}",
                      context);
                }
                if (state is LoadedItemsState) {
                  return buildItemsList(listBloc);
                }
                return buildItemsList(listBloc);
              },
            ));
      }),
    );
  }

  Widget buildItemsList(ItemsListCubit listBloc) {
    List<List<ItemWithColorModel>> organizedItems = listBloc.state.items;

    return ListView.builder(
        itemCount: organizedItems.length,
        itemBuilder: (context, index) =>
            buildItemsByCategory(organizedItems[index], index, listBloc)
    );
  }

  Widget buildItemsByCategory(List<ItemWithColorModel> organizedItem, int categoryListIndex, ItemsListCubit listBloc) {
    var categoryName = organizedItem[0].category;
    // var categoryColor = await listBloc.getCategoryColor(categoryName);
    return BlocBuilder(
      bloc: listBloc,
      builder: (context, state) => ExpansionTile(
        title: Text(categoryName),
        // subtitle: Text('Trailing expansion arrow icon'),
        children: <Widget>[buildItemCards(organizedItem, categoryListIndex, listBloc)],
        // backgroundColor: organizedItem[0].color,
        collapsedBackgroundColor: organizedItem[0].color,
        initiallyExpanded: true,
      ),
    );
  }

  Widget buildItemCards(List<ItemWithColorModel> _items, int categoryListIndex, ItemsListCubit listBloc){
    return BlocBuilder(
      bloc: listBloc,
      builder: (context, state) => ReorderableListView(
        // scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        // padding: const EdgeInsets.symmetric(horizontal: 40),
        children: <Widget>[
          for (int index = 0; index < _items.length; index++)
            ListTile(
              key: Key('item$index'),
              title: Text(_items[index].name),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(_items[index].imageUrl),
              ),
              trailing: const Icon(Icons.drag_handle),
            ),
        ],
        onReorder: (int oldIndex, int newIndex) {
          listBloc.rearrange(categoryListIndex, oldIndex, newIndex);
        },
      ),
    );
  }

  buildItemCard(ItemWithColorModel organizedItem) {
    return Card(
      child: ListTile(
        title: Text(organizedItem.name),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(organizedItem.imageUrl),
        ),
      ),
    );
  }
}



