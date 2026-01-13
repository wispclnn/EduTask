import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class AddEditTaskScreen extends StatefulWidget {
  final Task? task;
  const AddEditTaskScreen({super.key, this.task});

  @override
  State<AddEditTaskScreen> createState() => _AddEditTaskScreenState();
}

class _AddEditTaskScreenState extends State<AddEditTaskScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime deadline = DateTime.now().add(const Duration(days: 1));
  int difficulty = 3;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      titleController.text = widget.task!.title;
      descriptionController.text = widget.task!.description;
      deadline = widget.task!.deadline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task != null ? 'Edit Task' : 'Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Task Name'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Deadline: '),
                TextButton(
                  onPressed: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: deadline,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) setState(() => deadline = picked);
                  },
                  child: Text(
                    '${deadline.year}-${deadline.month}-${deadline.day}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (widget.task != null) {
                  widget.task!.title = titleController.text;
                  widget.task!.description = descriptionController.text;
                  widget.task!.deadline = deadline;
                } else {
                  TaskService.addTask(
                    Task(
                      title: titleController.text,
                      subject:
                          'General', // placeholder if you don’t have subject input yet
                      description: descriptionController.text,
                      deadline: deadline,
                    ),
                  );
                }
                Navigator.pop(context);
              },
              child: Text(widget.task != null ? 'Save Changes' : 'Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
