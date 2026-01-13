import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/task.dart';

class JSONStorageService {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> _localFile(String filename) async {
    final path = await _localPath;
    return File('$path/$filename.json');
  }

  // Tasks
  static Future<void> saveTasks(List<Task> tasks) async {
    final file = await _localFile('tasks');
    final jsonList = tasks.map((t) => t.toJson()).toList();
    await file.writeAsString(json.encode(jsonList));
  }

  static Future<List<Task>> loadTasks() async {
    try {
      final file = await _localFile('tasks');
      if (!await file.exists()) return [];
      final contents = await file.readAsString();
      final List<dynamic> jsonList = json.decode(contents);
      return jsonList.map((e) => Task.fromJson(e)).toList();
    } catch (e) {
      print('Error loading tasks: $e');
      return [];
    }
  }

  // Theme
  static Future<void> saveJson(
    String filename,
    Map<String, dynamic> jsonMap,
  ) async {
    final file = await _localFile(filename);
    await file.writeAsString(json.encode(jsonMap));
  }

  static Future<Map<String, dynamic>?> readJson(String filename) async {
    try {
      final file = await _localFile(filename);
      if (!await file.exists()) return null;
      final contents = await file.readAsString();
      return json.decode(contents) as Map<String, dynamic>;
    } catch (e) {
      print('Error reading JSON: $e');
      return null;
    }
  }
}
