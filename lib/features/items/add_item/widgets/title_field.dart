import 'package:flutter/material.dart';

class TitleField extends StatelessWidget {
  const TitleField({
    super.key,
    this.controller,
    this.onChanged,
    this.errorText,
  });

  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: 'Title',
        border: const OutlineInputBorder(),
        errorText: errorText,
      ),
      onChanged: onChanged,
    );
  }
}

