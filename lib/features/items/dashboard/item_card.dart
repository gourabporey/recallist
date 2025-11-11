import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recallist/core/data/repositories/item_repository.dart';
import 'package:recallist/core/models/item.dart';
import 'package:recallist/core/service_locator.dart';
import 'package:recallist/core/services/notification_service.dart';
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
    final tags = item.tags ?? [];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(
            context,
          ).colorScheme.surfaceContainerHigh, // your border color
          width: 2,
        ),
        borderRadius: BorderRadius.circular(20), // optional rounded corners
      ),
      elevation: 1,
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
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TagsWidget(tags: tags),
                  tags.isNotEmpty
                      ? const SizedBox(height: 8)
                      : const SizedBox.shrink(),
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
            ],
          ),
        ),
      ),
    );
  }
}

class TagsWidget extends StatelessWidget {
  const TagsWidget({super.key, required this.tags});

  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return tags.isNotEmpty
        ? Wrap(
            spacing: 8,
            runSpacing: 4,
            children: tags
                .map(
                  (tag) => Chip(
                    label: Text(
                      tag.toUpperCase(),
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withAlpha(150),
                        fontWeight: FontWeight.w400,
                        fontSize: 9,
                      ),
                    ),
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                    // shadowColor: Colors.black26,
                    side: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.primaryFixedDim.withAlpha(80),
                      width: 1,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 0,
                    ),
                  ),
                )
                .toList(),
          )
        : const SizedBox.shrink();
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
    // Reschedule notifications when item is revised
    sl<NotificationService>().rescheduleNotifications();
  }

  @override
  Widget build(BuildContext context) {
    // add a border color to the button
    return ElevatedButton(
      onPressed: _handleRevise,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        shape: CircleBorder(),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary.withAlpha(50),
          width: 2,
        ),
      ),
      child: Icon(
        Icons.check,
        color: Theme.of(context).colorScheme.primary,
        size: 30,
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
