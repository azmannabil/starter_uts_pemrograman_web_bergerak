import 'dart:async';
import 'dart:convert';
import '../models/task.dart';

import 'package:shared_preferences/shared_preferences.dart';

/// Titik akses data tugas.
///
/// Starter memakai memori agar aplikasi dapat langsung dijalankan. Lengkapi
/// TODO 2 dengan SharedPreferences dan JSON; jangan memindahkan akses storage
/// ke widget.
class TaskStorage {
  TaskStorage({this.loadDelay = const Duration(milliseconds: 450)});

  static List<Task> _memory = <Task>[];
  static const String _storageKey = 'pratikum_task';
  final Duration loadDelay;

  Future<List<Task>> load({bool simulateError = false}) async {
    await Future<void>.delayed(loadDelay);
    if (simulateError) {
      throw const FormatException('Simulasi data tersimpan yang rusak.');
    }

    // TODO 2a: baca String JSON dari SharedPreferences lalu ubah menjadi
    // List<Task> dengan Task.fromJson. JSON rusak dapat menghasilkan
    // FormatException agar UI menampilkan state error.

    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? raw = preferences.getString(_storageKey);
    if (raw == null || raw.isEmpty) return <Task>[];

    try {
      final Object? decoded = jsonDecode(raw);
      if (decoded is! List<dynamic>) {
        throw const FormatException('Format daftar tugas tidak valid.');
      }
      return decoded.map((Object? item) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException('Format salah satu tugas tidak valid.');
        }
        return Task.fromJson(item);
      }).toList();
    } on FormatException {
      rethrow;
    } catch (_) {
      throw const FormatException('Data tugas tersimpan tidak dapat dibaca.');
    }
  }

  Future<void> save(List<Task> tasks) async {
    // TODO 2b: encode seluruh daftar sebagai JSON String dan tulis melalui
    // SharedPreferences. Periksa nilai bool yang dikembalikan setString.
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    final String encoded = jsonEncode(
      tasks.map((Task task) => task.toJson()).toList(),
    );

    final bool saved = await preferences.setString(_storageKey, encoded);

    final String? check = preferences.getString(_storageKey);

    if (!saved) {
      throw StateError('Daftar tugas gagal disimpan.');
    }
  }

  Future<void> clear() async {
    // TODO 2c: hapus key daftar tugas dari SharedPreferences.
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final bool removed = await preferences.remove(_storageKey);
    if (!removed && preferences.containsKey(_storageKey)) {
      throw StateError('Daftar tugas gagal dihapus.');
    }
  }

  /// Hanya untuk mengisolasi pengujian lokal.
  static void resetMemoryForTest() => _memory = <Task>[];
}
