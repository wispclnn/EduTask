import 'package:flutter/material.dart';
import '../models/task.dart';
import 'package:intl/intl.dart';

class CalendarWidget extends StatelessWidget {
  final List<Task> tasks;
  final DateTime displayMonth;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final Function(DateTime)? onDayTap;
  final Color dayBorderColor;

  const CalendarWidget({
    super.key,
    required this.tasks,
    required this.displayMonth,
    required this.onPrev,
    required this.onNext,
    this.onDayTap,
    this.dayBorderColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    int daysInMonth = DateTime(
      displayMonth.year,
      displayMonth.month + 1,
      0,
    ).day;

    return Column(
      children: [
        // Month header with arrows
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(onPressed: onPrev, icon: const Icon(Icons.arrow_left)),
              Text(
                DateFormat('MMMM yyyy').format(displayMonth),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: onNext,
                icon: const Icon(Icons.arrow_right),
              ),
            ],
          ),
        ),
        // Weekday headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            Text('Sun'),
            Text('Mon'),
            Text('Tue'),
            Text('Wed'),
            Text('Thu'),
            Text('Fri'),
            Text('Sat'),
          ],
        ),
        const SizedBox(height: 8),
        // Days grid
        Expanded(
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
            ),
            itemCount: daysInMonth,
            itemBuilder: (context, index) {
              final day = DateTime(
                displayMonth.year,
                displayMonth.month,
                index + 1,
              );
              bool hasTask = tasks.any(
                (t) =>
                    t.deadline.year == day.year &&
                    t.deadline.month == day.month &&
                    t.deadline.day == day.day,
              );

              return GestureDetector(
                onTap: () {
                  if (onDayTap != null) onDayTap!(day);
                },
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(255, 41, 41, 41),
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text('${day.day}'),
                      if (hasTask)
                        Positioned(
                          bottom: 4,
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
