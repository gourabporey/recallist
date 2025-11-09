import 'package:flutter/material.dart';

class EditFieldModal extends StatefulWidget {
  const EditFieldModal({
    super.key,
    required this.fieldName,
    required this.initialValue,
    required this.onSave,
    this.isMultiline = false,
  });

  final String fieldName;
  final String initialValue;
  final Function(String) onSave;
  final bool isMultiline;

  @override
  State<EditFieldModal> createState() => _EditFieldModalState();
}

class _EditFieldModalState extends State<EditFieldModal> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _hasChanged = false;
  bool _hasSaved = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _focusNode = FocusNode();
    _controller.addListener(() {
      setState(() {
        _hasChanged = _controller.text != widget.initialValue;
      });
    });
    _focusNode.addListener(() {
      // Auto-save on blur if changed
      if (!_focusNode.hasFocus && _hasChanged && !_hasSaved) {
        _handleSave(autoClose: false);
      }
    });
    // Request focus after frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSave({bool autoClose = true}) {
    if (_hasChanged && !_hasSaved) {
      widget.onSave(_controller.text);
      setState(() {
        _hasSaved = true;
      });
    }
    if (autoClose) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Edit ${widget.fieldName}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            maxLines: widget.isMultiline ? 5 : 1,
            decoration: InputDecoration(
              hintText: 'Enter ${widget.fieldName.toLowerCase()}',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            onSubmitted: (_) => _handleSave(),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _hasChanged ? _handleSave : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
