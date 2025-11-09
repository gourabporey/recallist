import 'package:flutter/material.dart';

class TagsField extends StatelessWidget {
  const TagsField({super.key, this.controller, this.onChanged});

  final TextEditingController? controller;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Tags (optional, comma-separated)',
        border: OutlineInputBorder(),
        helperText: 'e.g., math, physics, chemistry',
      ),
      onChanged: onChanged,
    );
  }
}
