import 'package:flutter/material.dart';
import 'package:recallist/core/data/repositories/item_repository.dart';
import 'package:recallist/core/models/item.dart';
import 'package:recallist/core/service_locator.dart';
import 'package:recallist/core/services/notification_service.dart';
import 'package:recallist/features/items/add_item/widgets/centered_save_button.dart';
import 'package:recallist/features/items/add_item/widgets/item_header.dart';
import 'package:recallist/features/items/add_item/widgets/links_field.dart';
import 'package:recallist/features/items/add_item/widgets/notes_field.dart';
import 'package:recallist/features/items/add_item/widgets/revision_pattern_selector.dart';
import 'package:recallist/features/items/add_item/widgets/tags_field.dart';
import 'package:recallist/features/items/add_item/widgets/title_field.dart';

class AddItemSheet extends StatefulWidget {
  const AddItemSheet({super.key});

  @override
  State<AddItemSheet> createState() => _AddItemSheetState();
}

class _AddItemSheetState extends State<AddItemSheet> {
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  final _tagsController = TextEditingController();
  final _linksController = TextEditingController();

  String? _titleError;
  List<int> _revisionPattern = RevisionPatternSelector.defaultPattern;

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    _tagsController.dispose();
    _linksController.dispose();
    super.dispose();
  }

  List<String> _strToList(String str) {
    return str
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  void _onSave() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      setState(() {
        _titleError = 'Title is required';
      });
      return;
    }

    setState(() {
      _titleError = null;
    });

    // Parse tags
    final tags = _tagsController.text.trim().isEmpty
        ? null
        : _strToList(_tagsController.text);

    // Parse links
    final links = _linksController.text.trim().isEmpty
        ? null
        : _strToList(_linksController.text);

    // Create new item
    final item = Item(
      id: 0, // Will be auto-generated
      title: title,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      tags: tags?.isEmpty ?? true ? null : tags,
      links: links?.isEmpty ?? true ? null : links,
      images: null, // TODO: Implement image picker in future
      createdDate: DateTime.now(),
      revisions: [],
      revisionPattern: _revisionPattern,
    );

    // Save to repository
    try {
      await sl<ItemRepository>().addItem(item);
      // Reschedule notifications when new item is added
      sl<NotificationService>().rescheduleNotifications();
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving item: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ItemHeader(),
            const SizedBox(height: 16),
            TitleField(
              controller: _titleController,
              onChanged: (value) {
                setState(() {
                  _titleError = null;
                });
              },
              errorText: _titleError,
            ),
            const SizedBox(height: 12),
            NotesField(controller: _notesController),
            const SizedBox(height: 12),
            TagsField(controller: _tagsController),
            const SizedBox(height: 12),
            LinksField(controller: _linksController),
            const SizedBox(height: 12),
            RevisionPatternSelector(
              onChanged: (pattern) {
                setState(() {
                  _revisionPattern = pattern;
                });
              },
            ),
            const SizedBox(height: 16),
            CenteredSaveButton(onSave: _onSave),
          ],
        ),
      ),
    );
  }
}
