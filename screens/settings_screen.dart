import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    Color backgroundColor = themeProvider.primaryColor.withOpacity(0.1);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(title: const Text('Settings')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(child: Text('Menu')),
            ListTile(
              title: const Text('Home'),
              onTap: () => Navigator.pushReplacementNamed(context, '/home'),
            ),
            ListTile(
              title: const Text('Tasks'),
              onTap: () => Navigator.pushReplacementNamed(context, '/tasks'),
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () => Navigator.pushReplacementNamed(context, '/settings'),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Select Theme Color:'),
          const SizedBox(height: 12),
          Row(
            children: [
              GestureDetector(
                onTap: () => themeProvider.setPrimaryColor(
                  const Color.fromARGB(255, 125, 184, 233),
                ),
                child: Container(
                  width: 40,
                  height: 40,
                  color: const Color.fromARGB(255, 105, 186, 253),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => themeProvider.setPrimaryColor(
                  const Color.fromARGB(255, 159, 235, 161),
                ),
                child: Container(width: 40, height: 40, color: Colors.green),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => themeProvider.setPrimaryColor(
                  const Color.fromARGB(255, 158, 31, 22),
                ),
                child: Container(
                  width: 40,
                  height: 40,
                  color: const Color.fromARGB(255, 163, 19, 9),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => themeProvider.setPrimaryColor(
                  const Color.fromARGB(255, 66, 28, 63),
                ),
                child: Container(
                  width: 40,
                  height: 40,
                  color: const Color.fromARGB(255, 88, 7, 88),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => themeProvider.setPrimaryColor(
                  const Color.fromARGB(255, 184, 124, 35),
                ),
                child: Container(
                  width: 40,
                  height: 40,
                  color: const Color.fromARGB(255, 228, 150, 7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
