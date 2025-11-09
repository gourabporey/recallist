import 'package:flutter/material.dart';

const nameLabel = 'Name';
const descLabel = 'Description';

class ItemBasicDetails extends StatelessWidget {
  const ItemBasicDetails({
    super.key,
    required this.onTitleChange,
    required this.onDescriptionChange,
    required this.nameError,
    required this.descError,
  });

  final void Function(String) onTitleChange;
  final void Function(String) onDescriptionChange;
  final bool nameError;
  final bool descError;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: nameLabel,
            border: const OutlineInputBorder(),
            errorText: nameError ? 'Name cannot be empty' : null,
          ),
          onChanged: onTitleChange,
        ),

        const SizedBox(height: 12),

        TextField(
          decoration: InputDecoration(
            labelText: descLabel,
            border: OutlineInputBorder(),
            errorText: descError ? 'Description cannot be empty' : null,
          ),
          maxLines: 2,
          onChanged: onDescriptionChange,
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
