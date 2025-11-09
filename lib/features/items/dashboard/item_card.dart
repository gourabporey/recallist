import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recallist/core/data/repositories/item_repository.dart';
import 'package:recallist/core/models/item.dart';
import 'package:recallist/core/service_locator.dart';
import 'package:recallist/features/items/detail/item_detail_screen.dart';

String _formatDate(DateTime date) {
  return DateFormat('MMM d, y').format(date);
}

class ItemCard extends StatelessWidget {
  const ItemCard({super.key, required this.item, required this.onItemUpdated});

  final Item item;
  final Future<void> Function() onItemUpdated;

  @override
  Widget build(BuildContext context) {
    final lastRevised = item.getLastRevisedDate();
    final nextRevision = item.getNextRevisionDate();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItemDetailScreen(
                item: item,
                onItemUpdated: onItemUpdated,
                onItemDeleted: onItemUpdated,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RevisedDateCard(date: lastRevised),
                      const SizedBox(height: 4),
                      RevisionDateCard(date: nextRevision),
                    ],
                  ),
                  ReviseButton(item: item, onRevise: onItemUpdated),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReviseButton extends StatelessWidget {
  const ReviseButton({super.key, required this.item, required this.onRevise});

  final Future<void> Function() onRevise;
  final Item item;

  Future<void> _handleRevise() async {
    final updatedRevisions = List<DateTime>.from(item.revisions)
      ..add(DateTime.now());

    final updatedItem = item.copyWith(revisions: updatedRevisions);
    await sl<ItemRepository>().updateItem(updatedItem);
    await onRevise();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      onPressed: _handleRevise,
      icon: Icon(
        Icons.check,
        size: 30,
        color: Theme.of(context).colorScheme.primary,
      ),
      label: Text(
        'Revise',
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}

class RevisionDateCard extends StatelessWidget {
  const RevisionDateCard({super.key, required this.date});

  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.schedule, size: 16, color: Colors.blue),
        const SizedBox(width: 4),
        Text(
          date != null
              ? 'Next revision: ${_formatDate(date!)}'
              : 'No revision scheduled',
          style: TextStyle(
            fontSize: 14,
            color: date != null ? Colors.blue : Colors.grey,
          ),
        ),
        const SizedBox(width: 20),
      ],
    );
  }
}

class RevisedDateCard extends StatelessWidget {
  const RevisedDateCard({super.key, required this.date});

  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.history, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          'Last revised: ${_formatDate(date!)}',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}
