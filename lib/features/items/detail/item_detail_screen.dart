import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recallist/core/data/repositories/item_repository.dart';
import 'package:recallist/core/models/item.dart';
import 'package:recallist/core/service_locator.dart';
import 'package:recallist/core/services/notification_service.dart';
import 'package:recallist/features/items/detail/widgets/edit_field_modal.dart';
import 'package:recallist/features/items/detail/widgets/revision_timeline.dart';

class ItemDetailScreen extends StatefulWidget {
  const ItemDetailScreen({
    super.key,
    required this.item,
    required this.onItemUpdated,
    required this.onItemDeleted,
  });

  final Item item;
  final VoidCallback onItemUpdated;
  final VoidCallback onItemDeleted;

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  late Item _currentItem;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _currentItem = widget.item;
  }

  @override
  void didUpdateWidget(ItemDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update current item if the widget's item changed
    if (oldWidget.item.id != widget.item.id ||
        oldWidget.item.revisions.length != widget.item.revisions.length) {
      _currentItem = widget.item;
    }
  }

  Future<void> _updateItem(Item updatedItem) async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      await sl<ItemRepository>().updateItem(updatedItem);
      setState(() {
        _currentItem = updatedItem;
        _isSaving = false;
      });
      widget.onItemUpdated();
      // Reschedule notifications when item is updated
      sl<NotificationService>().rescheduleNotifications();
    } catch (e) {
      setState(() {
        _isSaving = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating item: $e')));
      }
    }
  }

  Future<void> _deleteItem() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text(
          'Are you sure you want to delete this item? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await sl<ItemRepository>().deleteItem(_currentItem.id);
        // Reschedule notifications when item is deleted
        sl<NotificationService>().rescheduleNotifications();
        if (mounted) {
          widget.onItemDeleted();
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error deleting item: $e')));
        }
      }
    }
  }

  Future<void> _markAsRevised() async {
    final updatedRevisions = List<DateTime>.from(_currentItem.revisions)
      ..add(DateTime.now());

    final updatedItem = _currentItem.copyWith(revisions: updatedRevisions);
    await _updateItem(updatedItem);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item marked as revised'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showEditModal({
    required String fieldName,
    required String currentValue,
    required Function(String) onSave,
    bool isMultiline = false,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditFieldModal(
        fieldName: fieldName,
        initialValue: currentValue,
        onSave: onSave,
        isMultiline: isMultiline,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          _currentItem.title,
          style: TextStyle(color: Color.fromARGB(255, 41, 22, 46)),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'revise') {
                _markAsRevised();
              } else if (value == 'delete') {
                _deleteItem();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'revise',
                child: Row(
                  children: [
                    Icon(Icons.check, size: 20),
                    SizedBox(width: 8),
                    Text('Mark as Revised'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 20, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Section
            _EditableField(
              label: 'Title',
              value: _currentItem.title,
              icon: Icons.edit,
              onTap: () {
                _showEditModal(
                  fieldName: 'Title',
                  currentValue: _currentItem.title,
                  onSave: (newValue) {
                    if (newValue.trim().isNotEmpty) {
                      _updateItem(
                        _currentItem.copyWith(title: newValue.trim()),
                      );
                    }
                  },
                );
              },
            ),
            const SizedBox(height: 24),

            // Notes Section
            _EditableField(
              label: 'Description',
              value: _currentItem.notes ?? 'No description',
              icon: Icons.edit,
              isMultiline: true,
              onTap: () {
                _showEditModal(
                  fieldName: 'Description',
                  currentValue: _currentItem.notes ?? '',
                  isMultiline: true,
                  onSave: (newValue) {
                    _updateItem(
                      _currentItem.copyWith(
                        notes: newValue.trim().isEmpty ? null : newValue.trim(),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 24),

            // Tags Section
            _EditableField(
              label: 'Tags',
              value: _currentItem.tags?.join(', ') ?? 'No tags',
              icon: Icons.edit,
              onTap: () {
                _showEditModal(
                  fieldName: 'Tags',
                  currentValue: _currentItem.tags?.join(', ') ?? '',
                  onSave: (newValue) {
                    final tags = newValue.trim().isEmpty
                        ? null
                        : newValue
                              .split(',')
                              .map((e) => e.trim())
                              .where((e) => e.isNotEmpty)
                              .toList();
                    _updateItem(_currentItem.copyWith(tags: tags));
                  },
                );
              },
            ),
            const SizedBox(height: 24),

            // Links Section
            if (_currentItem.links != null &&
                _currentItem.links!.isNotEmpty) ...[
              Text(
                'Links',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 8),
              ..._currentItem.links!.map(
                (link) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.link,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          link,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Revision Timeline
            Text(
              'Revision Timeline',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),
            RevisionTimeline(item: _currentItem),
            const SizedBox(height: 24),

            // Revision Info
            _RevisionInfo(item: _currentItem),
          ],
        ),
      ),
    );
  }
}

class _EditableField extends StatelessWidget {
  const _EditableField({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
    this.isMultiline = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;
  final bool isMultiline;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPlaceholder = value == 'No description' || value == 'No tags';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            IconButton(
              icon: Icon(icon, size: 24, color: theme.colorScheme.primary),
              onPressed: onTap,
              tooltip: 'Edit $label',
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: isPlaceholder
                  ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                  : theme.colorScheme.onSurface,
            ),
            maxLines: isMultiline ? null : 3,
            overflow: isMultiline
                ? TextOverflow.visible
                : TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _RevisionInfo extends StatelessWidget {
  const _RevisionInfo({required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lastRevised = item.getLastRevisedDate();
    final nextRevision = item.getNextRevisionDate();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.history,
              size: 16,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 8),
            Text(
              'Last revised: ${_formatDate(lastRevised)}',
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.schedule,
              size: 16,
              color: nextRevision != null
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 8),
            Text(
              nextRevision != null
                  ? 'Next revision: ${_formatDate(nextRevision)}'
                  : 'No revision scheduled',
              style: TextStyle(
                fontSize: 14,
                color: nextRevision != null
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final formatter = DateFormat('MMM d, yyyy');
    return formatter.format(date);
  }
}
