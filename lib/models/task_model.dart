class TaskModel {
  final String title;
  final String? subtitle;
  final DateTime createdAt;
  bool isCompleted;

  TaskModel({
    required this.title,
    this.subtitle,
    required this.createdAt,
    this.isCompleted = false,
  });
}
