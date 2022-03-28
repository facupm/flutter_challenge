import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_challege/widgets/loading_dialog.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

import '../../utils/show_custom_snackbar.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/form_field_tag.dart';
import '../cubits/create_category_cubit.dart';
import '../repositories/create_category_repository.dart';

class CreateCategoryScreen extends StatelessWidget {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateCategoryCubit(CreateCategoryRepository()),
      child: Builder(builder: (context) {
        Size deviceSize = MediaQuery.of(context).size;
        final formBloc = BlocProvider.of<CreateCategoryCubit>(context);
        return BlocListener<CreateCategoryCubit, CreateCategoryState>(
            key: _formkey,
            listener: (context, state) => listenState(context, state),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 40.0, left: 24, right: 24),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 10),
                  buildNameField(formBloc),
                  const SizedBox(height: 10),
                  buildColorPicker(formBloc),
                  const SizedBox(height: 20),
                  buildCreateButton(formBloc, deviceSize),
                ],
              ),
            ));
      }),
    );
  }

  void listenState(BuildContext context, CreateCategoryState state) {
    if (state is CreatingState) {
      LoadingDialog.show(context);
    }
    if (state is CreatedSuccessfullyState) {
      LoadingDialog.hide(context);
      CustomSnackBar("Category created successfully", context);
    }
    if (state is ErrorState) {
      LoadingDialog.hide(context);
      CustomSnackBar(
          "Something went wrong. Please try again: ${state.error}", context);
    }
  }

  Widget buildNameField(CreateCategoryCubit formBloc) {
    return Wrap(
      children: [
        const FormFieldTag(name: "Name"),
        BlocBuilder(
          bloc: formBloc,
          builder: (context, state) => CustomTextField(
            key: const Key("nameField"),
            // bloc: formBloc.name,
            // isEnabled: !isLoading,
            keyboard: TextInputType.name,
            label: "Category name",
            hint: 'Enter a category name',
            onChange: (value) => {formBloc.changeName(value)},
            error: state is NameErrorState ? state.error : null,
            // icon: Icon(Icons.email)
          ),
        )
      ],
    );
  }

  Widget buildColorPicker(CreateCategoryCubit formBloc) {
    return Wrap(
      children: [
        const FormFieldTag(name: "Color"),
        BlocBuilder(
            bloc: formBloc,
            builder: (context, state) => buildDefaultColors(formBloc)),
        BlocBuilder(
          bloc: formBloc,
          builder: (context, state) =>
              buildCustomColorPicker(formBloc, context),
        ),
      ],
    );
  }

  Widget buildDefaultColors(CreateCategoryCubit formBloc) {
    return MaterialColorPicker(
      onMainColorChange: (ColorSwatch? color) {
        // formBloc.color = Color(color!.value);
        formBloc.changeColor(Color(color!.value));
      },
      allowShades: false,
      selectedColor: formBloc.state.color,
      circleSize: 40,
      elevation: 5,
      colors: const [
        Colors.redAccent,
        Colors.deepOrangeAccent,
        // Colors.orangeAccent,
        Colors.amberAccent,
        // Colors.yellowAccent,
        Colors.limeAccent,
        Colors.lightGreenAccent,
        Colors.greenAccent,
        // Colors.cyanAccent,
        Colors.lightBlueAccent,
        Colors.blueAccent,
        Colors.indigoAccent,
        Colors.deepPurpleAccent,
        Colors.purpleAccent,
        Colors.pinkAccent,
      ],
    );
  }

  Widget buildCustomColorPicker(
      CreateCategoryCubit formBloc, BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return buildColorDialog(formBloc, context);
            },
          );
        },
        child: CircleColor(
          circleSize: 40,
          color: formBloc.state.color!,
          elevation: 5,
          iconSelected: Icons.add,
          isSelected: true,
        ),
      ),
    );
  }

  Widget buildColorDialog(CreateCategoryCubit formBloc, BuildContext context) {
    return AlertDialog(
      title: const Text('Choose a color'),
      content: SingleChildScrollView(
        child: ColorPicker(
          enableAlpha: false,
          portraitOnly: true,
          pickerColor: formBloc.state.color!,
          onColorChanged: (Color color) {
            formBloc.changeColor(color);
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Done'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget buildCreateButton(CreateCategoryCubit formBloc, Size size) {
    return SizedBox(
      width: size.width * 0.8,
      child: OutlinedButton(
        onPressed: () {
          formBloc.submit();
        },
        child: const Text("Create"),
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.black87),
            side: MaterialStateProperty.all<BorderSide>(BorderSide.none)),
      ),
    );
  }
}
