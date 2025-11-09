import 'package:flutter/material.dart';
import 'package:recallist/core/models/item.dart';
import 'package:recallist/features/items/dashboard/item_card.dart';

class ItemsTabView extends StatelessWidget {
  const ItemsTabView({
    super.key,
    required this.items,
    required this.onItemUpdated,
    required this.emptyMessage,
  });

  final List<Item> items;
  final Future<void> Function() onItemUpdated;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emptyMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onItemUpdated,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ItemCard(item: items[index], onItemUpdated: onItemUpdated);
        },
      ),
    );
  }
}
