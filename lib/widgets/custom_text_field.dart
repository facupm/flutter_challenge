import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key? key,
    required this.label,
    required this.hint,
    required this.bloc,
    required this.isEnabled,
    this.icon,
    this.keyboard,
  }) : super(key: key);

  final String label;
  final String hint;
  final TextFieldBloc bloc;
  final TextInputType? keyboard;
  final Icon? icon;
  final bool isEnabled;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    bool _hasIcon = widget.icon != null;
    // bool _usesBloc = (widget.bloc) != null;
    // bool _hasSuffixWidget = (widget.suffixWidget) != null;
    return TextFieldBlocBuilder(
      // maxLines: widget.maxLines,
      // minLines: widget.minLines,
      // obscureText: widget.obscureText,
      // readOnly: widget.readOnly,
      // focusNode: widget.readOnly ? new AlwaysDisabledFocusNode() : null,
      isEnabled: widget.isEnabled,
      textFieldBloc: widget.bloc,
      keyboardType: widget.keyboard,
      padding: EdgeInsets.all(12.0),
      // suffixButton: widget.suffixIcon,
      decoration: InputDecoration(
          labelText: widget.label,
          isDense: !kIsWeb,
          errorMaxLines: 2,
          hintText: widget.hint,
          // fillColor: textFieldColor,
          // suffixIcon: _hasSuffixWidget ? widget.suffixWidget : null,
          prefixIcon: _hasIcon
              ? Padding(
                  padding:
                      const EdgeInsetsDirectional.only(start: 16.0, end: 10.0),
                  child: widget.icon,
                )
              : null,
          contentPadding: EdgeInsets.symmetric(
              vertical: 16, horizontal: _hasIcon ? 16 : 30),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(15),
          )),
    );
  }
}
