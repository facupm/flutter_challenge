import 'package:flutter/material.dart';
import 'package:flutter_challege/create_items/screens/create_item_screen.dart';
import 'package:flutter_challege/switch_creation/screens/switch_creation_screen.dart';
import 'package:flutter_challege/utils/constants.dart';

import '../create_categories/screens/create_category_screen.dart';
import '../favorites_list/screens/favorites_list_screen.dart';
import '../items_list/screens/items_list_screen.dart';

class MenuDrawer extends StatelessWidget {
  // static void show(BuildContext context, {Key? key}) => showDialog<void>(
  //   context: context,
  //   useRootNavigator: false,
  //   barrierDismissible: false,
  //   builder: (_) => LoadingDialog(key: key),
  // ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  // static void hide(BuildContext context) => Navigator.pop(context);

  const MenuDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              decoration: const BoxDecoration(color: Colors.blue),
              child: Stack(children: const <Widget>[
                Positioned(
                    bottom: 12.0,
                    left: 16.0,
                    child: Text("Menu",
                        style: TextStyle(
                            color: backgroundColor,
                            fontSize: 30.0,
                            fontWeight: FontWeight.w500))),
              ])),
          ListTile(
            leading: buildLeading(Icons.list),
            title: buildTitle('Shopping List'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ItemsListScreen()),
              );
            },
          ),
          ListTile(
            leading: buildLeading(favoriteIcon),
            title: buildTitle('Favorites List'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesListScreen()),
              );
            },
          ),
          ListTile(
            leading: buildLeading(addIcon),
            title: buildTitle('Create elements'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SwitchCreationScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  buildLeading(IconData icon) {
    return Container(
        height: double.infinity,
        child: Icon(
          icon,
          size: 20,
        ));
  }

  buildTitle(String title) {
    return Transform.translate(
      offset: const Offset(-20, 0),
      child: Text(title, style: const TextStyle(fontSize: 15)),
    );
  }
}
