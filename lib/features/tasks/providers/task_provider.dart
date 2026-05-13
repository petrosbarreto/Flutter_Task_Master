import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_master/config/supabase_config.dart';
import 'package:task_master/core/services/supabase_service.dart';
import 'package:task_master/features/tasks/models/task_item.dart';

class TaskProvider extends ChangeNotifier {
  TaskProvider(this._service);

  final SupabaseService _service;

  String? _userId;
  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;
  TaskStatus? _filter;
  List<TaskItem> _tasks = const [];

  List<TaskItem> get tasks {
    if (_filter == null) {
      return _tasks;
    }
    return _tasks.where((task) => task.status == _filter).toList();
  }

  List<TaskItem> get allTasks => _tasks;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;
  TaskStatus? get filter => _filter;
  int get completedCount =>
      _tasks.where((task) => task.status == TaskStatus.completed).length;
  int get pendingCount =>
      _tasks.where((task) => task.status != TaskStatus.completed).length;
  int get overdueCount => _tasks.where((task) => task.isOverdue).length;

  void handleAuthChanged(User? user) {
    final nextUserId = user?.id;
    if (_userId == nextUserId) {
      return;
    }
    _userId = nextUserId;

    if (_userId == null) {
      _tasks = const [];
      _errorMessage = null;
      notifyListeners();
      return;
    }

    loadTasks();
  }

  Future<void> loadTasks() async {
    if (_userId == null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _service.client
          .from(SupabaseTables.tasks)
          .select()
          .eq('user_id', _userId!)
          .order('due_date', ascending: true)
          .order('created_at', ascending: false);

      _tasks = response
          .map<TaskItem>((item) => TaskItem.fromMap(item))
          .toList(growable: false);
    } catch (error) {
      _errorMessage = 'Nao foi possivel carregar as tarefas.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setFilter(TaskStatus? status) {
    _filter = status;
    notifyListeners();
  }

  Future<String?> saveTask({
    TaskItem? existingTask,
    required String title,
    String? description,
    required TaskPriority priority,
    required DateTime? dueDate,
    TaskStatus status = TaskStatus.pending,
  }) async {
    if (_userId == null) {
      return 'Voce precisa estar autenticado para salvar tarefas.';
    }

    _isSaving = true;
    notifyListeners();

    try {
      if (existingTask == null) {
        final newTask = TaskItem(
          id: '',
          userId: _userId!,
          title: title,
          description: _normalizeDescription(description),
          priority: priority,
          status: status,
          dueDate: dueDate,
          createdAt: null,
          updatedAt: null,
        );

        await _service.client
            .from(SupabaseTables.tasks)
            .insert(newTask.toInsertMap());
      } else {
        final updatedTask = existingTask.copyWith(
          title: title,
          description: _normalizeDescription(description),
          priority: priority,
          status: status,
          dueDate: dueDate,
          clearDueDate: dueDate == null,
        );

        await _service.client
            .from(SupabaseTables.tasks)
            .update(updatedTask.toUpdateMap())
            .eq('id', existingTask.id)
            .eq('user_id', _userId!);
      }

      await loadTasks();
      return null;
    } catch (error) {
      return 'Nao foi possivel salvar a tarefa.';
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<String?> updateStatus(TaskItem task, TaskStatus status) async {
    if (_userId == null) {
      return 'Voce precisa estar autenticado.';
    }

    try {
      await _service.client
          .from(SupabaseTables.tasks)
          .update({
            'status': _statusToDatabase(status),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', task.id)
          .eq('user_id', _userId!);

      _tasks = _tasks
          .map((item) => item.id == task.id ? item.copyWith(status: status) : item)
          .toList(growable: false);
      notifyListeners();
      return null;
    } catch (error) {
      return 'Nao foi possivel atualizar o status.';
    }
  }

  Future<String?> deleteTask(TaskItem task) async {
    if (_userId == null) {
      return 'Voce precisa estar autenticado.';
    }

    try {
      await _service.client
          .from(SupabaseTables.tasks)
          .delete()
          .eq('id', task.id)
          .eq('user_id', _userId!);
      _tasks = _tasks.where((item) => item.id != task.id).toList(growable: false);
      notifyListeners();
      return null;
    } catch (error) {
      return 'Nao foi possivel excluir a tarefa.';
    }
  }

  String? _normalizeDescription(String? value) {
    if (value == null) {
      return null;
    }
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  String _statusToDatabase(TaskStatus status) {
    switch (status) {
      case TaskStatus.inProgress:
        return 'in_progress';
      case TaskStatus.completed:
        return 'completed';
      case TaskStatus.pending:
        return 'pending';
    }
  }
}
