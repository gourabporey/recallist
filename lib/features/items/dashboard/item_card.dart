import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recallist/core/models/item.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({super.key, required this.item});

  final Item item;

  String _formatDate(DateTime date) {
    return DateFormat('MMM d, y').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final lastRevised = item.getLastRevisedDate();
    final nextRevision = item.getNextRevisionDate();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.history, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Last revised: ${_formatDate(lastRevised)}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.schedule, size: 16, color: Colors.blue),
                const SizedBox(width: 4),
                Text(
                  nextRevision != null
                      ? 'Next revision: ${_formatDate(nextRevision)}'
                      : 'No revision scheduled',
                  style: TextStyle(
                    fontSize: 14,
                    color: nextRevision != null ? Colors.blue : Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
