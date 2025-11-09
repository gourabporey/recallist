import 'package:flutter/material.dart';
import 'package:recallist/features/items/add_item/add_item_sheet.dart';

class AddItemButton extends StatelessWidget {
  const AddItemButton({super.key, this.onItemAdded});

  final VoidCallback? onItemAdded;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (context) => const AddItemSheet(),
        ).then((_) {
          // Refresh the dashboard when the sheet is closed
          if (context.mounted && onItemAdded != null) {
            onItemAdded!();
          }
        });
      },
      child: const Icon(Icons.add),
    );
  }
}
