import 'package:flutter/material.dart';
import '../services/json_storage_service.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ThemeProvider extends ChangeNotifier {
  Color _primaryColor = Colors.blue;

  Color get primaryColor => _primaryColor;

  ThemeProvider({bool loadFromDisk = true}) {
    if (loadFromDisk) {
      loadTheme();
    }
  }

  void setPrimaryColor(Color newColor) {
    _primaryColor = newColor;
    notifyListeners();
    // Only save JSON if on mobile
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      JSONStorageService.saveJson('theme', {'primaryColor': newColor.value});
    }
  }

  Future<void> loadTheme() async {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      final json = await JSONStorageService.readJson('theme');
      if (json != null && json['primaryColor'] != null) {
        _primaryColor = Color(json['primaryColor']);
        notifyListeners();
      }
    }
  }
}
