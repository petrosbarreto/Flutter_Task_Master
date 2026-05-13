enum TaskPriority { low, medium, high }

enum TaskStatus { pending, inProgress, completed }

class TaskItem {
  const TaskItem({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    this.dueDate,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String userId;
  final String title;
  final String? description;
  final TaskPriority priority;
  final TaskStatus status;
  final DateTime? dueDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isCompleted => status == TaskStatus.completed;
  bool get isOverdue =>
      dueDate != null &&
      !isCompleted &&
      dueDate!.isBefore(DateTime.now());

  TaskItem copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    TaskPriority? priority,
    TaskStatus? status,
    DateTime? dueDate,
    bool clearDueDate = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskItem(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toInsertMap() {
    return {
      'user_id': userId,
      'title': title,
      'description': description,
      'priority': priority.name,
      'status': _statusToDatabase(status),
      'due_date': dueDate?.toIso8601String(),
    };
  }

  Map<String, dynamic> toUpdateMap() {
    return {
      'title': title,
      'description': description,
      'priority': priority.name,
      'status': _statusToDatabase(status),
      'due_date': dueDate?.toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  static TaskItem fromMap(Map<String, dynamic> map) {
    return TaskItem(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      title: (map['title'] as String?) ?? 'Sem titulo',
      description: map['description'] as String?,
      priority: _priorityFromValue(map['priority'] as String?),
      status: _statusFromValue(map['status'] as String?),
      dueDate: _parseDate(map['due_date'] as String?),
      createdAt: _parseDate(map['created_at'] as String?),
      updatedAt: _parseDate(map['updated_at'] as String?),
    );
  }

  static TaskPriority _priorityFromValue(String? value) {
    return TaskPriority.values.firstWhere(
      (priority) => priority.name == value,
      orElse: () => TaskPriority.medium,
    );
  }

  static TaskStatus _statusFromValue(String? value) {
    switch (value) {
      case 'in_progress':
        return TaskStatus.inProgress;
      case 'completed':
        return TaskStatus.completed;
      case 'pending':
      default:
        return TaskStatus.pending;
    }
  }

  static String _statusToDatabase(TaskStatus status) {
    switch (status) {
      case TaskStatus.inProgress:
        return 'in_progress';
      case TaskStatus.completed:
        return 'completed';
      case TaskStatus.pending:
        return 'pending';
    }
  }

  static DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    return DateTime.tryParse(value)?.toLocal();
  }
}
