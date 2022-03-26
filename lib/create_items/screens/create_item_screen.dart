import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challege/widgets/loading_dialog.dart';
import 'package:flutter_challege/widgets/menu_drawer.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets/custom_text_field.dart';
import '../../widgets/form_field_tag.dart';
import '../cubits/create_item_cubit.dart';
import '../repositories/create_item_repository.dart';

class CreateItemScreen extends StatefulWidget {
  final String title = 'Create Item';

  @override
  _CreateItemScreen createState() => _CreateItemScreen();
}

class _CreateItemScreen extends State<CreateItemScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  // String? error;
  // File? image;
  // bool isLoading = false;
  Map<String, String>? args;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateItemCubit>(
      create: (context) =>
          CreateItemCubit(CreateItemRepository())..getCategories(),
      child: Builder(builder: (context) {
        args =
            ModalRoute.of(context)!.settings.arguments as Map<String, String>?;
        Size size = MediaQuery.of(context).size;
        final formBloc = BlocProvider.of<CreateItemCubit>(context);
        return BlocListener<CreateItemCubit, CreateItemState>(
            key: _formkey,
            listener: (context, state) {
              if (state is CreatedSuccessfullyState) {
                LoadingDialog.hide(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Item created successfully"),
                  duration: Duration(seconds: 2),
                ));
              }
              if (state is CreatingState) {
                LoadingDialog.show(context);
              }
              if (state is ErrorState) {
                LoadingDialog.hide(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      "Something went wrong. Please try again: ${state.error}"),
                  duration: Duration(seconds: 2),
                ));
                // }
              }
            },
            child: SingleChildScrollView(
              // physics: const ClampingScrollPhysics(),
              padding:
              const EdgeInsets.only(top: 40.0, left: 24, right: 24),
              child: Column(
                children: <Widget>[
                  GestureDetector(
                      onTap: () async {
                        await pickImage(formBloc);
                      },
                      child: BlocBuilder<CreateItemCubit, CreateItemState>(
                        bloc: formBloc,
                        builder: (context, state) => ClipRRect(
                          child: formBloc.state.image != null
                              ? Image.file(formBloc.state.image!,
                              width: 136.0,
                              height: 136.0,
                              fit: BoxFit.cover)
                              : const Image(
                              image: AssetImage(
                                  'assets/images/add-image-icon.png'),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover),
                        ),
                      )),
                  SizedBox(height: 10),
                  FormFieldTag(name: "Name"),
                  BlocBuilder(
                    bloc: formBloc,
                    builder: (context, state) => CustomTextField(
                      key: Key("nameField"),
                      // bloc: formBloc.name,
                      // isEnabled: !isLoading,
                      keyboard: TextInputType.name,
                      label: "Enter a name",
                      hint: 'Enter an item name',
                      onChange: (value) => {formBloc.changeName(value)},
                      error: state is NameErrorState ? state.error : null,
                      // icon: Icon(Icons.email)
                    ),
                  ),
                  SizedBox(height: 20),
                  FormFieldTag(name: "Category"),
                  BlocBuilder(
                    bloc: formBloc,
                    builder: (context, state) =>
                        DropdownButtonFormField<String>(
                          // value: state is CategoryLoaded ? state.selectedCategory : formBloc.state.selectedCategory,
                          // value: "b",
                          decoration: InputDecoration(
                              errorText: state is CategoryErrorState
                                  ? state.error
                                  : null,
                              labelText: "Select a category",
                              errorMaxLines: 2,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 16),
                              border: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.grey[400]!),
                                borderRadius: BorderRadius.circular(15),
                              )),
                          // items: getMenuItems(["a", "b"]),
                          items: state is CategoriesLoaded ? getMenuItems(state.categories) : getMenuItems(formBloc.state.categories),
                          onChanged: (String? value) {
                            formBloc.changeCategory(value);
                          },
                        ),
                  ),
                  SizedBox(height: 20),
                  // !isLoading ?
                  SizedBox(
                    width: size.width * 0.8,
                    child: OutlinedButton(
                      onPressed: () {
                        formBloc.submit();
                      },
                      child: Text("Create"),
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.black87),
                          side: MaterialStateProperty.all<BorderSide>(
                              BorderSide.none)),
                    ),
                  )
                  // : CircularProgressIndicator(),
                ],
              ),
            ));
      }),
    );
  }

  Future pickImage(CreateItemCubit formBloc) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      formBloc.changeImage(imageTemporary);
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to pick image: $e"),
        duration: Duration(seconds: 2),
      ));
    }
  }

  List<DropdownMenuItem<String>> getMenuItems(List<String> categories) {
    List<DropdownMenuItem<String>> list = [];
    int cont = 0;
    for (var category in categories) {
      cont++;
      list.add(DropdownMenuItem(child: Text(category), value: category));
    }
    return list.toList();
  }
}
