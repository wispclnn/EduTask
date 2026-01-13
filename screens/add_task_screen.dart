import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final titleController = TextEditingController();
  final subjectController = TextEditingController();
  int difficulty = 3;
  DateTime deadline = DateTime.now().add(const Duration(days: 1));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Task Title'),
            ),
            TextField(
              controller: subjectController,
              decoration: const InputDecoration(labelText: 'Subject'),
            ),
            const SizedBox(height: 12),
            DropdownButton<int>(
              value: difficulty,
              items: const [
                DropdownMenuItem(value: 1, child: Text('Easy')),
                DropdownMenuItem(value: 3, child: Text('Medium')),
                DropdownMenuItem(value: 5, child: Text('Hard')),
              ],
              onChanged: (v) => setState(() => difficulty = v!),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                TaskService.addTask(
                  Task(
                    title: titleController.text,
                    subject: subjectController.text,
                    deadline: deadline,
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text('Save Task'),
            ),
          ],
        ),
      ),
    );
  }
}
