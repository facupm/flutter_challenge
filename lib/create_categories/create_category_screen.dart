import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_challege/create_items/create_item_cubit.dart';
import 'package:flutter_challege/create_items/exceptions/item_already_exists.dart';
import 'package:flutter_challege/widgets/loading_dialog.dart';
import 'package:flutter_challege/widgets/menu_drawer.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/custom_text_field.dart';
import 'create_category_cubit.dart';
import 'create_category_repository.dart';
import 'exceptions/category_already_exists.dart';

class CreateCategoryScreen extends StatefulWidget {
  final String title = 'Create Category';

  @override
  _CreateCategoryScreen createState() => _CreateCategoryScreen();
}

class _CreateCategoryScreen extends State<CreateCategoryScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  File? image;
  bool isLoading = false;
  Map<String, String>? args;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateCategoryCubit(CreateCategoryRepository()),
      child: Builder(builder: (context) {
        args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>?;
        Size size = MediaQuery.of(context).size;
        final formBloc = BlocProvider.of<CreateCategoryCubit>(context);
        return Scaffold(
          // backgroundColor: Constants.kPrimaryColor,
            appBar: AppBar(
              title: Text(widget.title),
            ),
            drawer: const MenuDrawer(),
            body: FormBlocListener<CreateCategoryCubit, String, Exception>(
                key: _formkey,
                onSubmitting: (context, state) {
                  LoadingDialog.show(context);
                },
                onSuccess: (context, state) {
                  LoadingDialog.hide(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Category created successfully"),
                    duration: Duration(seconds: 2),
                  ));
                },
                onFailure: (context, state) {
                  LoadingDialog.hide(context);
                  if(state.failureResponse is CategoryAlreadyExistsException){
                    formBloc.name.addFieldError("An item with this name already exists");
                  }else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Something went wrong. Please try again: ${state
                              .failureResponse!.toString()}"),
                      duration: Duration(seconds: 2),
                    ));
                  }
                },
                child: SingleChildScrollView(
                  // physics: const ClampingScrollPhysics(),
                  padding:
                  const EdgeInsets.only(top: 40.0, left: 24, right: 24),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10),
                      CustomTextField(
                        key: Key("nameField"),
                        bloc: formBloc.name,
                        isEnabled: !isLoading,
                        keyboard: TextInputType.name,
                        label: "Category name",
                        hint: 'Enter an item name',
                        // icon: Icon(Icons.email)
                      ),
                      !this.isLoading
                          ? SizedBox(
                        width: size.width * 0.8,
                        child: OutlinedButton(
                          onPressed: () {
                            formBloc.submit();
                          },
                          child: Text("Create"),
                          style: ButtonStyle(
                              foregroundColor:
                              MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor:
                              MaterialStateProperty.all<Color>(
                                  Colors.black87),
                              side: MaterialStateProperty.all<BorderSide>(
                                  BorderSide.none)),
                        ),
                      )
                          : CircularProgressIndicator(),
                    ],
                  ),
                )));
      }),
    );
  }
}
