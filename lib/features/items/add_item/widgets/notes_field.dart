import 'package:flutter/material.dart';

class NotesField extends StatelessWidget {
  const NotesField({super.key, this.controller, this.onChanged});

  final TextEditingController? controller;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Notes (optional)',
        border: OutlineInputBorder(),
      ),
      maxLines: 4,
      onChanged: onChanged,
    );
  }
}
