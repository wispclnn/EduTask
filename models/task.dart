class Task {
  String title;
  String subject;
  String description; // new
  DateTime deadline;

  bool completed;

  Task({
    required this.title,
    required this.subject,
    this.description = '',
    required this.deadline,

    this.completed = false,
  });
  Map<String, dynamic> toJson() => {
    'title': title,
    'subject': subject,
    'description': description,
    'deadline': deadline.toIso8601String(),
    'completed': completed,
  };

  // Create Task object from JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'] as String,
      subject: json['subject'] as String,
      description: json['description'] as String? ?? '',
      deadline: DateTime.parse(json['deadline'] as String),
      completed: json['completed'] as bool? ?? false,
    );
  }
}
