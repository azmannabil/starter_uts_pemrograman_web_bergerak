import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uts_praktikum_starter/app/tugas_app.dart';
import 'package:uts_praktikum_starter/data/task_storage.dart';

void main() {
  setUp(() => TaskStorage.resetMemoryForTest());

  testWidgets('menampilkan keadaan kosong setelah data selesai dimuat',
      (WidgetTester tester) async {
    await tester.pumpWidget(const TugasApp());
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.text('Belum ada tugas'), findsOneWidget);
    expect(find.byKey(const Key('add-task-button')), findsOneWidget);
  });

  testWidgets('error pemuatan menyediakan aksi coba lagi',
      (WidgetTester tester) async {
    await tester.pumpWidget(const TugasApp());
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Menu pengujian'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Simulasikan error saat memuat'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.text('Coba lagi'), findsOneWidget);
    await tester.tap(find.byKey(const Key('retry-load-button')));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();
    expect(find.text('Belum ada tugas'), findsOneWidget);
  });
}
