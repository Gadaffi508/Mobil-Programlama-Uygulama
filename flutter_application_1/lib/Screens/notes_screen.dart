// notes_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';

class NotesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notlar'),
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: appState.notes.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(appState.notes[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => appState.removeNote(index),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    final note = await showDialog<String>(
                      context: context,
                      builder: (context) => _NoteInputDialog(),
                    );
                    if (note != null && note.isNotEmpty) {
                      appState.addNote(note);
                    }
                  },
                  child: Text('Not Ekle'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _NoteInputDialog extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Yeni Not'),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(hintText: 'Not'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('İptal'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _controller.text),
          child: Text('Ekle'),
        ),
      ],
    );
  }
}
