import 'package:hive/hive.dart';

part 'item.g.dart'; // generated file

@HiveType(typeId: 0)
class Item extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? notes;

  @HiveField(3)
  final List<String>? tags;

  @HiveField(4)
  final List<String>? links;

  @HiveField(5)
  final List<String>? images;

  @HiveField(6)
  final DateTime createdDate;

  @HiveField(7)
  final List<DateTime> revisions;

  @HiveField(8)
  final List<int> revisionPattern;

  Item({
    required this.id,
    required this.title,
    this.notes,
    this.tags,
    this.links,
    this.images,
    required this.createdDate,
    required this.revisions,
    required this.revisionPattern,
  });

  /// Calculate the next revision date based on the last revision and pattern
  DateTime? getNextRevisionDate() {
    if (revisions.isEmpty) {
      // If no revisions yet, first revision is after the first interval
      return createdDate.add(Duration(days: revisionPattern.first));
    }

    final lastRevision = revisions.last;
    final completedRevisions = revisions.length;

    // If all pattern intervals are completed, use the last interval
    if (completedRevisions >= revisionPattern.length) {
      final lastInterval = revisionPattern.last;
      return lastRevision.add(Duration(days: lastInterval));
    }

    // Otherwise, use the next interval in the pattern
    final nextInterval = revisionPattern[completedRevisions];
    return lastRevision.add(Duration(days: nextInterval));
  }

  /// Get the last revised date, or created date if no revisions
  DateTime getLastRevisedDate() {
    return revisions.isNotEmpty ? revisions.last : createdDate;
  }

  void markAsRevised() {
    revisions.add(DateTime.now());
  }

  List<DateTime> getAllRevisions() {
    return revisions;
  }
}
