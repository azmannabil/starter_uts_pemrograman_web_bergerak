import 'package:flutter/material.dart';

import '../models/task.dart';

/// Form siap digunakan. Validasi mengabaikan spasi di tepi.
class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _courseController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final Task task = Task(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      course: _courseController.text.trim(),
    );
    Navigator.pop(context, task);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Tugas')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            Text(
              'Isi informasi tugas praktikum.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 18),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    key: const Key('task-title-field'),
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Judul tugas',
                      hintText: 'Contoh: Membuat halaman profil',
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    validator: (String? value) =>
                        value == null || value.trim().isEmpty
                            ? 'Judul tugas wajib diisi.'
                            : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    key: const Key('task-course-field'),
                    controller: _courseController,
                    decoration: const InputDecoration(
                      labelText: 'Mata kuliah',
                      hintText: 'Contoh: Pemrograman Perangkat Bergerak',
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (String? value) =>
                        value == null || value.trim().isEmpty
                            ? 'Mata kuliah wajib diisi.'
                            : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            FilledButton.icon(
              key: const Key('save-task-button'),
              onPressed: _save,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Simpan tugas'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
          ],
        ),
      ),
    );
  }
}
