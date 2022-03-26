import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challege/widgets/menu_drawer.dart';

import '../../create_categories/screens/create_category_screen.dart';
import '../../create_items/screens/create_item_screen.dart';
import '../cubits/switch_creation_cubit.dart';

class SwitchCreationScreen extends StatelessWidget {

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SwitchCreationCubit>(
      create: (context) => SwitchCreationCubit(),
      child: Builder(builder: (context) {
        final switchBloc = BlocProvider.of<SwitchCreationCubit>(context);
        return Scaffold(
            appBar: AppBar(
              title: Text(switchBloc.state.pageTitle),
              actions: [
                Switch(
                    value: switchBloc.state.itemScreen,
                    onChanged: (val) {
                      switchBloc.changeScreen();
                    }),
              ],
            ),
            drawer: const MenuDrawer(),
            body: BlocBuilder(
              key: _formkey,
              bloc: switchBloc,
              builder: (context, state) {
                if (switchBloc.state.itemScreen) {
                  return CreateItemScreen();
                } else {
                  return CreateCategoryScreen();
                }
              },
            ));
      }),
    );
  }
}
