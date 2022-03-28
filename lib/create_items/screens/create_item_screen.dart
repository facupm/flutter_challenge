import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challege/widgets/loading_dialog.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/show_custom_snackbar.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/form_field_tag.dart';
import '../cubits/create_item_cubit.dart';
import '../repositories/create_item_repository.dart';

class CreateItemScreen extends StatelessWidget {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateItemCubit>(
      create: (context) =>
          CreateItemCubit(CreateItemRepository())..getCategories(),
      child: Builder(builder: (context) {
        Size deviceSize = MediaQuery.of(context).size;
        final formBloc = BlocProvider.of<CreateItemCubit>(context);
        return BlocListener<CreateItemCubit, CreateItemState>(
            key: _formkey,
            listener: (context, state) => listenState(context, state),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 40.0, left: 24, right: 24),
              child: Column(
                children: <Widget>[
                  buildImagePicker(formBloc, context),
                  const SizedBox(height: 10),
                  buildNameField(formBloc),
                  const SizedBox(height: 20),
                  buildCategoryDropdown(formBloc),
                  const SizedBox(height: 20),
                  buildCreateButton(formBloc, deviceSize),
                ],
              ),
            ));
      }),
    );
  }

  void listenState(BuildContext context, CreateItemState state) {
    if (state is CreatedSuccessfullyState) {
      LoadingDialog.hide(context);
      CustomSnackBar("Item created successfully", context);
    }
    if (state is CreatingState) {
      LoadingDialog.show(context);
    }
    if (state is ErrorState) {
      LoadingDialog.hide(context);
      CustomSnackBar(
          "Something went wrong. Please try again: ${state.error}", context);
    }
  }

  Widget buildImagePicker(CreateItemCubit formBloc, BuildContext context) {
    return GestureDetector(
        onTap: () async {
          await pickImage(formBloc, context);
        },
        child: BlocBuilder<CreateItemCubit, CreateItemState>(
          bloc: formBloc,
          builder: (context, state) => ClipRRect(
            child: formBloc.state.image != null
                ? Image.file(formBloc.state.image!,
                    width: 136.0, height: 136.0, fit: BoxFit.cover)
                : const Image(
                    image: AssetImage('assets/images/add-image-icon.png'),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover),
          ),
        ));
  }

  Future pickImage(CreateItemCubit formBloc, BuildContext context) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      formBloc.changeImage(imageTemporary);
    } on PlatformException catch (e) {
      CustomSnackBar("Failed to pick image: $e", context);
    }
  }

  Widget buildNameField(CreateItemCubit formBloc) {
    return Wrap(
      children: [
        const FormFieldTag(name: "Name"),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: BlocBuilder(
            bloc: formBloc,
            builder: (context, state) => CustomTextField(
              key: const Key("nameField"),
              keyboard: TextInputType.name,
              label: "Enter a name",
              hint: 'Enter an item name',
              onChange: (value) => {formBloc.changeName(value)},
              error: state is NameErrorState ? state.error : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCategoryDropdown(CreateItemCubit formBloc) {
    return Wrap(
      children: [
        const FormFieldTag(name: "Category"),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: BlocBuilder(
            bloc: formBloc,
            builder: (context, state) => DropdownButtonFormField<String>(
              decoration: InputDecoration(
                  errorText: state is CategoryErrorState ? state.error : null,
                  labelText: "Select a category",
                  errorMaxLines: 2,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[400]!),
                    borderRadius: BorderRadius.circular(15),
                  )),
              items: state is CategoriesLoaded
                  ? getMenuItems(state.categories)
                  : getMenuItems(formBloc.state.categories),
              onChanged: (String? value) {
                formBloc.changeCategory(value);
              },
            ),
          ),
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> getMenuItems(List<String> categories) {
    List<DropdownMenuItem<String>> list = [];
    for (var category in categories) {
      list.add(DropdownMenuItem(child: Text(category), value: category));
    }
    return list.toList();
  }

  Widget buildCreateButton(CreateItemCubit formBloc, Size size) {
    return Wrap(
      children: [
        SizedBox(
          width: size.width * 0.8,
          child: OutlinedButton(
            onPressed: () {
              formBloc.submit();
            },
            child: const Text("Create"),
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.black87),
                side: MaterialStateProperty.all<BorderSide>(BorderSide.none)),
          ),
        )
      ],
    );
  }
}
