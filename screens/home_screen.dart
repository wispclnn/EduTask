// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/task_service.dart';
import '../models/task.dart';
import '../widgets/calendar_widget.dart';
import '../theme_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime displayMonth = DateTime(DateTime.now().year, DateTime.now().month);
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  bool showSuggestions = false;

  //for search suggestions
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  void previousMonth() {
    setState(() {
      displayMonth = DateTime(displayMonth.year, displayMonth.month - 1);
    });
  }

  void nextMonth() {
    setState(() {
      displayMonth = DateTime(displayMonth.year, displayMonth.month + 1);
    });
  }

  // Popup for individual task
  Future<void> showTaskPopup(Task task) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(task.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${task.description}'),
            const SizedBox(height: 8),
            Text(
              'Deadline: ${DateFormat('MMM dd, yyyy').format(task.deadline)}',
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // Popup for tasks on a specific day in calendar
  void showDayTasksPopup(DateTime day) {
    List<Task> dayTasks = TaskService.tasks
        .where(
          (t) =>
              t.deadline.year == day.year &&
              t.deadline.month == day.month &&
              t.deadline.day == day.day,
        )
        .toList();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Tasks on ${DateFormat('MMM dd, yyyy').format(day)}'),
        content: dayTasks.isNotEmpty
            ? SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: dayTasks.length,
                  itemBuilder: (context, index) {
                    Task task = dayTasks[index];
                    return ListTile(
                      title: Text(task.title),
                      subtitle: Text(task.description),
                      onTap: () => showTaskPopup(task),
                    );
                  },
                ),
              )
            : const Text('No task deadlines on this day'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // Show search suggestions overlay
  void showOverlay(List<Task> results) {
    _overlayEntry?.remove();
    if (results.isEmpty) return;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: 200,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: const Offset(0, 50), // Below the search box
          showWhenUnlinked: false,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: results.length,
              itemBuilder: (context, index) {
                Task task = results[index];
                return ListTile(
                  title: Text(
                    task.title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Deadline: ${DateFormat('MMM dd, yyyy').format(task.deadline)}',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  onTap: () async {
                    _overlayEntry?.remove();
                    _overlayEntry = null;
                    searchQuery = '';
                    searchController.clear();
                    await showTaskPopup(task);
                  },
                );
              },
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    Color backgroundColor = themeProvider.primaryColor.withOpacity(0.1);

    List<Task> tasks = TaskService.tasks;
    tasks.sort((a, b) => a.deadline.compareTo(b.deadline));

    // Filter tasks for live search suggestions
    List<Task> searchResults = searchQuery.isEmpty
        ? []
        : tasks
              .where(
                (t) =>
                    t.title.toLowerCase().startsWith(searchQuery.toLowerCase()),
              )
              .toList();

    if (searchQuery.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showOverlay(searchResults);
      });
    } else {
      hideOverlay();
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('EduTask'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          CompositedTransformTarget(
            link: _layerLink,
            child: SizedBox(
              width: 200,
              height: 45,
              child: TextField(
                controller: searchController,
                onChanged: (val) => setState(() => searchQuery = val),
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: const TextStyle(color: Colors.black54),
                  prefixIcon: const Icon(Icons.search, color: Colors.black),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 8,
                  ),
                ),
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      // hamburger menu
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: double.infinity,
                height: 450,
                padding: const EdgeInsets.all(16),
                child: tasks.isNotEmpty
                    ? ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          Task task = tasks[index];
                          return ListTile(
                            title: Text(task.title),
                            subtitle: Text(
                              'Deadline: ${DateFormat('MMM dd').format(task.deadline)}',
                            ),
                            onTap: () => showTaskPopup(task),
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                          'No tasks yet',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
              ),
            ),
          ),
          // Calendar
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 450,
                width: 450,
                child: CalendarWidget(
                  tasks: tasks,
                  displayMonth: displayMonth,
                  onPrev: () => setState(
                    () => displayMonth = DateTime(
                      displayMonth.year,
                      displayMonth.month - 1,
                    ),
                  ),
                  onNext: () => setState(
                    () => displayMonth = DateTime(
                      displayMonth.year,
                      displayMonth.month + 1,
                    ),
                  ),
                  onDayTap: showDayTasksPopup,
                  dayBorderColor: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
