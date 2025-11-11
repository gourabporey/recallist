import 'package:flutter/material.dart';

class DatePickerField extends StatefulWidget {
  final DateTime? initialDate;
  final Function(DateTime?) onDateChanged;

  const DatePickerField({
    super.key,
    this.initialDate,
    required this.onDateChanged,
  });

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  late DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now(); // default: today
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().add(Duration(days: -10)),
      lastDate: DateTime.now().add(Duration(days: 180)),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
      widget.onDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickDate(context),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Date',
          border: OutlineInputBorder(),
        ),
        child: Text(
          _selectedDate != null
              ? '${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}'
              : 'No date selected',
        ),
      ),
    );
  }
}
