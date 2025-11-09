import 'package:flutter/material.dart';

class RevisionPatternSelector extends StatefulWidget {
  const RevisionPatternSelector({
    super.key,
    required this.onChanged,
    this.initialValue,
  });

  final void Function(List<int>) onChanged;
  final List<int>? initialValue;

  static const List<int> defaultPattern = [1, 7, 30, 90, 180];

  @override
  State<RevisionPatternSelector> createState() =>
      _RevisionPatternSelectorState();
}

class _RevisionPatternSelectorState extends State<RevisionPatternSelector> {
  late String _selectedValue;

  @override
  void initState() {
    super.initState();
    final pattern =
        widget.initialValue ?? RevisionPatternSelector.defaultPattern;
    _selectedValue = pattern.join('-');
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: 'Revision Pattern',
        border: OutlineInputBorder(),
        helperText: 'Days between revisions',
      ),
      initialValue: _selectedValue,
      items: const [
        DropdownMenuItem(
          value: '1-7-30-90-180',
          child: Text('1-7-30-90-180 (default)'),
        ),
        DropdownMenuItem(
          value: '1-3-7-14-30',
          child: Text('1-3-7-14-30 (aggressive)'),
        ),
        DropdownMenuItem(
          value: '7-30-90-180-365',
          child: Text('7-30-90-180-365 (spaced)'),
        ),
      ],
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedValue = value;
          });
          final patternList = value
              .split('-')
              .map((e) => int.parse(e.trim()))
              .toList();
          widget.onChanged(patternList);
        }
      },
    );
  }
}
