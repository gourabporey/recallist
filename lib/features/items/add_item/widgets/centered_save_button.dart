import 'package:flutter/material.dart';

const saveLabel = 'Save';

class CenteredSaveButton extends StatelessWidget {
  const CenteredSaveButton({super.key, required this.onSave});

  final void Function() onSave;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: onSave,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
        child: const Text(saveLabel, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
