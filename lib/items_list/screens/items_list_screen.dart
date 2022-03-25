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
                return Container();
              },
            ));
      }),
    );
  }

  Widget buildItemsList(ItemsListCubit listBloc) {
    List<List<ItemWithColorModel>> organizedItems = organizeItems(listBloc.state.items);

    return ListView.builder(
        itemCount: organizedItems.length,
        itemBuilder: (context, index) =>
            buildItemsByCategory(organizedItems[index], listBloc)
    );
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
      // print(item.name);
      insideList.add(item);
    }
    list.add(insideList);
    return list;
  }

  Widget buildItemsByCategory(List<ItemWithColorModel> organizedItem, ItemsListCubit listBloc) {
    var categoryName = organizedItem[0].category;
    // var categoryColor = await listBloc.getCategoryColor(categoryName);
    return BlocBuilder(
      bloc: listBloc,
      builder: (context, state) => ExpansionTile(
        title: Text(categoryName),
        // subtitle: Text('Trailing expansion arrow icon'),
        children: buildItemCards(organizedItem),
        backgroundColor: organizedItem[0].color,
        collapsedBackgroundColor: organizedItem[0].color,
      ),
    );
  }

  List<Widget> buildItemCards(List<ItemWithColorModel> organizedItem) {
    List<Widget> cardsList = [];
    for(var item in organizedItem){
      cardsList.add(buildItemCard(item));
    }
    return cardsList;
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



