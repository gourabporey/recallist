import 'package:flutter/material.dart';
import 'package:recallist/core/models/item.dart';

class RevisionTimeline extends StatelessWidget {
  const RevisionTimeline({super.key, required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    final timelineDates = _getTimelineDates();
    final nextRevision = item.getNextRevisionDate();
    final now = DateTime.now();

    if (timelineDates.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'No revisions yet',
            style: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: timelineDates.asMap().entries.map((entry) {
            final index = entry.key;
            final date = entry.value;
            final isPast = date.isBefore(now);
            final isNext =
                nextRevision != null && date.isAtSameMomentAs(nextRevision);

            return Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TimelineDot(date: date, isPast: isPast, isNext: isNext),
                if (index < timelineDates.length - 1)
                  Container(
                    width: 50,
                    height: 2,
                    margin: const EdgeInsets.only(top: 9),
                    color: isPast
                        ? Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.3)
                        : Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.2),
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  List<DateTime> _getTimelineDates() {
    final dates = <DateTime>[];
    final now = DateTime.now();
    final nextRevision = item.getNextRevisionDate();

    // Add creation date
    dates.add(item.createdDate);

    // Add all past revision dates
    for (final revision in item.revisions) {
      if (revision.isBefore(now)) {
        dates.add(revision);
      }
    }

    // Add next upcoming revision date if it exists
    if (nextRevision != null) {
      dates.add(nextRevision);
    }

    // Sort dates chronologically
    dates.sort();

    return dates;
  }
}

class _TimelineDot extends StatelessWidget {
  const _TimelineDot({
    required this.date,
    required this.isPast,
    required this.isNext,
  });

  final DateTime date;
  final bool isPast;
  final bool isNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dotColor = isNext
        ? Colors.green
        : (isPast
              ? theme.colorScheme.onSurface.withValues(alpha: 0.4)
              : theme.colorScheme.primary);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dotColor,
            border: Border.all(color: Colors.white, width: 1),
            boxShadow: [
              BoxShadow(
                color: dotColor.withValues(alpha: 0.2),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _formatDate(date),
          style: TextStyle(
            fontSize: 11,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final year = date.year.toString().substring(2);
    return '$day/$month/$year';
  }
}
