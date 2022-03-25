import 'package:flutter/material.dart';
import 'package:flutter_challege/create_items/screens/create_item_screen.dart';

import '../create_categories/screens/create_category_screen.dart';

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
          decoration: const BoxDecoration(
              color: Colors.lightBlueAccent),
          child: Stack(children: const <Widget>[
            Positioned(
                bottom: 12.0,
                left: 16.0,
                child: Text("Flutter Step-by-Step",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500))),
          ])),
          ListTile(
            title: const Text('Create item'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateItemScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('Create category'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateCategoryScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
