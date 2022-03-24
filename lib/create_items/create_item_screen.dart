import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_challege/create_items/create_item_cubit.dart';
import 'package:flutter_challege/widgets/loading_dialog.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/custom_text_field.dart';
import 'create_item_repository.dart';

class CreateItemScreen extends StatefulWidget {
  final String title = 'Create Item';

  @override
  _CreateItemScreen createState() => _CreateItemScreen();
}

class _CreateItemScreen extends State<CreateItemScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  String? error;
  File? image;
  bool isLoading = false;
  Map<String, String>? args;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateItemCubit(CreateItemRepository()),
      child: Builder(builder: (context) {
        args = ModalRoute.of(context)!.settings.arguments as Map<String, String>?;
        Size size = MediaQuery.of(context).size;
        final formBloc = BlocProvider.of<CreateItemCubit>(context);
        return Scaffold(
            // backgroundColor: Constants.kPrimaryColor,
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: FormBlocListener<CreateItemCubit, String, Exception>(
                key: _formkey,
                onSubmitting: (context, state) {
                  LoadingDialog.show(context);
                },
                onSuccess: (context, state) {
                  LoadingDialog.hide(context);
                  const snackBar = SnackBar(
                    content: Text('Item created successfully'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: SingleChildScrollView(
                  // physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.only(top: 40.0, left: 24, right: 24),
                  child: Column(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                              onTap: () async {
                                if (!isLoading) {
                                  await pickImage();
                                }
                              },
                              child: Container(
                                  child: ClipRRect(
                                child: image != null
                                    ? Image.file(image!,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover)
                                    : const Image(
                                        image: AssetImage(
                                            'assets/images/add-image-icon.png'),
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover),
                              ))),
                        ],
                      ),
                      SizedBox(height: 10),
                      CustomTextField(
                          key: Key("nameField"),
                          bloc: formBloc.name,
                          isEnabled: !isLoading,
                          keyboard: TextInputType.name,
                          label: "Item name",
                          hint: 'Enter an item name',
                          // icon: Icon(Icons.email)
                      ),
                      CustomTextField(
                        key: Key("categoryField"),
                        bloc: formBloc.category,
                        isEnabled: !isLoading,
                        keyboard: TextInputType.name,
                        label: "Category",
                        hint: 'Enter a category',
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
                                    side: MaterialStateProperty.all<
                                        BorderSide>(BorderSide.none)),
                              ),
                            )
                          : CircularProgressIndicator(),
                    ],
                  ),
                )));
      }),
    );
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      setState(() {
        this.error = 'Failed to pick image: $e';
      });
    }
  }
}
