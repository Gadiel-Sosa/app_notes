import 'package:app_notes/models/notes_model.dart';
import 'package:app_notes/services/database_helper.dart';
import 'package:flutter/material.dart';

class ViewNoteScreen extends StatefulWidget {
  final Note note;
  // ignore: use_key_in_widget_constructors
  ViewNoteScreen({required this.note});

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  String _formatDateTime(String dateTime) {
    final DateTime dt = DateTime.parse(dateTime);
    final now = DateTime.now();

    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return 'Today ${dt.hour.toString().padLeft(2, '0')}: ${dt.minute.toString().padLeft(0, '0')}';
    }
    return '${dt.day}/${dt.month}/${dt.year}, ${dt.hour.toString().padLeft(2, '0')}: ${dt.minute.toString().padLeft(0, '0')}';
  }

  @override
  State<ViewNoteScreen> createState() => _ViewNoteScreenState();
}

class _ViewNoteScreenState extends State<ViewNoteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(int.parse(widget.note.color)),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {},
            icon: Icon(Icons.edit, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
