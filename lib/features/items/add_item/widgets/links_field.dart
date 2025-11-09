import 'package:flutter/material.dart';

class LinksField extends StatelessWidget {
  const LinksField({super.key, this.controller, this.onChanged});

  final TextEditingController? controller;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Links (optional, comma-separated)',
        border: OutlineInputBorder(),
        helperText: 'e.g., https://example.com, https://docs.example.com',
      ),
      onChanged: onChanged,
    );
  }
}
