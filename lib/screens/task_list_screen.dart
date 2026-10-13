import 'package:flutter/material.dart';

import '../data/task_storage.dart';
import '../models/task.dart';
import '../widgets/task_card.dart';
import 'task_detail_screen.dart';
import 'task_form_screen.dart';

/// Halaman utama dan contoh pengelolaan state lokal menggunakan setState.
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TaskStorage _storage = TaskStorage();
  List<Task> _tasks = <Task>[];
  bool _isLoading = true;
  String? _errorMessage;
  bool _simulateNextError = false;

  int get _completedCount => _tasks.where((Task task) => task.isDone).length;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final bool shouldSimulateError = _simulateNextError;
      _simulateNextError = false;
      final List<Task> loadedTasks = await _storage.load(
        simulateError: shouldSimulateError,
      );
      if (!mounted) return;
      setState(() {
        _tasks = loadedTasks;
        _isLoading = false;
      });
    } on FormatException catch (error) {
      if (!mounted) return;
      setState(() {
        _errorMessage = error.message;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Data tugas gagal dimuat. Coba lagi.';
        _isLoading = false;
      });
    }
  }

  Future<void> _addTask() async {
    final Task? newTask = await Navigator.push<Task>(
      context,
      MaterialPageRoute<Task>(
        builder: (BuildContext context) => const TaskFormScreen(),
      ),
    );

    if (newTask == null || !mounted) return;
    final List<Task> updatedTasks = <Task>[newTask, ..._tasks];
    setState(() => _tasks = updatedTasks);
    await _storage.save(updatedTasks);
  }

  Future<void> _openDetail(Task task) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => TaskDetailScreen(task: task),
      ),
    );
  }

  Future<void> _toggleTask(Task task) async {
    final List<Task> updatedTasks = _tasks
        .map((Task item) => item.id == task.id
            ? item.copyWith(isDone: !item.isDone)
            : item)
        .toList();
    setState(() => _tasks = updatedTasks);
    await _storage.save(updatedTasks);
  }

  Future<void> _clearTasks() async {
    await _storage.clear();
    if (!mounted) return;
    setState(() => _tasks = <Task>[]);
  }

  void _triggerLoadError() {
    _simulateNextError = true;
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tugas Praktikum'),
        actions: <Widget>[
          PopupMenuButton<String>(
            tooltip: 'Menu pengujian',
            onSelected: (String value) {
              if (value == 'error') _triggerLoadError();
              if (value == 'clear') _clearTasks();
            },
            itemBuilder: (BuildContext context) => const <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'error',
                child: Text('Simulasikan error saat memuat'),
              ),
              PopupMenuItem<String>(
                value: 'clear',
                child: Text('Hapus semua tugas'),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final int columns = constraints.maxWidth >= 700 ? 2 : 1;
            return Column(
              children: <Widget>[
                _SummaryCard(
                  total: _tasks.length,
                  completed: _completedCount,
                ),
                Expanded(
                  child: _buildTaskContent(columns),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('add-task-button'),
        onPressed: _addTask,
        icon: const Icon(Icons.add),
        label: const Text('Tambah tugas'),
      ),
    );
  }

  Widget _buildTaskContent(int columns) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(key: Key('loading-indicator')),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.cloud_off_outlined, size: 48),
              const SizedBox(height: 12),
              Text(_errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton.icon(
                key: const Key('retry-load-button'),
                onPressed: _loadTasks,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba lagi'),
              ),
            ],
          ),
        ),
      );
    }

    if (_tasks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.checklist_outlined, size: 56),
              const SizedBox(height: 12),
              Text('Belum ada tugas', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 6),
              const Text(
                'Tekan “Tambah tugas” untuk mencatat praktikum.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      key: const Key('task-grid'),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 12,
        mainAxisSpacing: 4,
        mainAxisExtent: 150,
      ),
      itemCount: _tasks.length,
      itemBuilder: (BuildContext context, int index) {
        final Task task = _tasks[index];
        return TaskCard(
          task: task,
          onTap: () => _openDetail(task),
          onToggle: () => _toggleTask(task),
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.total, required this.completed});

  final int total;
  final int completed;

  @override
  Widget build(BuildContext context) {
    final int pending = total - completed;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
              const CircleAvatar(child: Icon(Icons.assignment_outlined)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Ringkasan', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text('$total tugas · $pending belum selesai · $completed selesai'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
