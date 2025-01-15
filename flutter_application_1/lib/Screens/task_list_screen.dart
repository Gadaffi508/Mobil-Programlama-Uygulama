// task_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';

class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Görevler'),
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: appState.tasks.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(
                      appState.tasks[index]['task'],
                      style: TextStyle(
                        decoration: appState.tasks[index]['isCompleted']
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    leading: Checkbox(
                      value: appState.tasks[index]['isCompleted'],
                      onChanged: (value) => appState.toggleTaskCompletion(index),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => appState.removeTask(index),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    final task = await showDialog<String>(
                      context: context,
                      builder: (context) => _TaskInputDialog(),
                    );
                    if (task != null && task.isNotEmpty) {
                      appState.addTask(task);
                    }
                  },
                  child: Text('Görev Ekle'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TaskInputDialog extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Yeni Görev'),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(hintText: 'Görev adı'),
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
