import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/task.dart';
import 'json_storage_service.dart';

class TaskService {
  static List<Task> tasks = [];

  /// Load tasks from JSON (only on mobile)
  static Future<void> loadTasks() async {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      try {
        tasks = await JSONStorageService.loadTasks();
      } catch (e) {
        // Handle errors gracefully
        tasks = [];
        print('Error loading tasks: $e');
      }
    } else {
      tasks = []; // On PC/Web just start with empty list
    }
  }

  /// Add a task
  static Future<void> addTask(Task task) async {
    tasks.add(task);
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      await JSONStorageService.saveTasks(tasks);
    }
  }

  /// Update a task at index
  static Future<void> updateTask(int index, Task task) async {
    tasks[index] = task;
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      await JSONStorageService.saveTasks(tasks);
    }
  }

  /// Remove a task
  static Future<void> removeTask(Task task) async {
    tasks.remove(task);
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      await JSONStorageService.saveTasks(tasks);
    }
  }
}
