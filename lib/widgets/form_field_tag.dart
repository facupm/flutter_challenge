import 'package:flutter/material.dart';

class FormFieldTag extends StatelessWidget {

  const FormFieldTag({
    Key? key,
    required this.name
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Text(
          name,
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.left),
    );
  }
}
