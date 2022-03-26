import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challege/items_list/models/item_with_category_color_model.dart';
import 'package:flutter_challege/widgets/menu_drawer.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../utils/show_custom_snackbar.dart';
import '../../widgets/form_field_tag.dart';
import '../cubits/items_list_cubit.dart';
import '../repositories/items_list_repository.dart';

class ItemsListScreen extends StatelessWidget {
  final String title = 'Shopping List';

  // const ItemsListScreen({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

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
                      "Something went wrong. Please try again: ${state.error}",
                      context);
                }
                if (listBloc.state.items.isEmpty) {
                  return buildEmptyList();
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

    return BlocBuilder(
      bloc: listBloc,
      builder: (context, state) => ListView.builder(
          itemCount: organizedItems.length,
          itemBuilder: (context, index) =>
              buildItemsByCategory(organizedItems[index], index, listBloc)),
    );
  }

  Widget buildItemsByCategory(List<ItemWithColorModel> organizedItem,
      int categoryListIndex, ItemsListCubit listBloc) {
    var categoryName = organizedItem[0].category;
    // var categoryColor = await listBloc.getCategoryColor(categoryName);
    return BlocBuilder(
      bloc: listBloc,
      builder: (context, state) => Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => deleteCategory(categoryName, listBloc),
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: ExpansionTile(
          title: FormFieldTag(name: categoryName),
          // subtitle: Text('Trailing expansion arrow icon'),
          children: <Widget>[
            buildItemCards(organizedItem, categoryListIndex, listBloc)
          ],
          // backgroundColor: Color.fromRGBO(organizedItem[0].color!.red,
          //     organizedItem[0].color!.green, organizedItem[0].color!.blue, 99),
          collapsedBackgroundColor: organizedItem[0].color,
          textColor: organizedItem[0].color,
          initiallyExpanded: true,
        ),
      ),
    );
  }

  Widget buildItemCards(List<ItemWithColorModel> _items, int categoryListIndex,
      ItemsListCubit listBloc) {
    return BlocBuilder(
      bloc: listBloc,
      builder: (context, state) => ReorderableListView(
        // scrollDirection: Axis.vertical,
        shrinkWrap: true,
        // physics: const NeverScrollableScrollPhysics(),
        // padding: const EdgeInsets.symmetric(horizontal: 40),
        children: <Widget>[
          for (int index = 0; index < _items.length; index++)
            Slidable(
              key: Key('$index'),
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) => deleteItem(_items[index], listBloc),
                    backgroundColor: const Color(0xFFFE4A49),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],
              ),
              child: ListTile(
                key: Key('item$index'),
                title: Text(_items[index].name),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(_items[index].imageUrl),
                ),
                trailing: const Icon(Icons.drag_handle),
              ),
            ),
        ],
        onReorder: (int oldIndex, int newIndex) {
          listBloc.rearrange(categoryListIndex, oldIndex, newIndex);
        },
      ),
    );
  }

  void deleteItem(ItemWithColorModel item, ItemsListCubit listBloc) {
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
}
