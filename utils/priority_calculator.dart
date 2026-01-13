import '../models/task.dart';

int calculatePriority(Task task) {
  final daysLeft = task.deadline.difference(DateTime.now()).inDays;
  return (10 - daysLeft.clamp(0, 10));
}
