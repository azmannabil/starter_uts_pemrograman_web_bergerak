# Starter UTS Praktikum — Tugas Praktikum

Starter Flutter untuk soal praktikum UTS Pemrograman Perangkat Bergerak 2026/2027. Proyek ini sengaja menjadi titik awal: jalankan dan pahami alur yang sudah tersedia, lalu lengkapi requirement pada naskah soal. Baca naskah ujian sebagai sumber requirement; README ini hanya petunjuk menjalankan starter.

## Menjalankan aplikasi

1. Ekstrak folder starter ke lokasi kerja lokal.
2. Buka folder `starter-praktikum` di VS Code atau Android Studio.
3. Pastikan Flutter SDK tersedia dan perangkat Android/emulator aktif.
4. Jalankan dari terminal pada folder proyek:

   ```sh
   flutter pub get
   flutter run
   ```

5. Untuk memeriksa kualitas kode dan tes dasar:

   ```sh
   flutter analyze
   flutter test
   ```

Dependency `shared_preferences` sudah dicantumkan pada `pubspec.yaml`; jangan menambahkan dependency atau mengganti struktur dasar proyek tanpa alasan teknis.

## Peta kode

- `lib/models/task.dart`: model `Task` dan titik serialisasi JSON.
- `lib/data/task_storage.dart`: batas akses data; saat ini memakai memori agar starter langsung bisa dicoba.
- `lib/screens/task_list_screen.dart`: state halaman daftar, ringkasan, loading/error/empty state, serta layout responsif.
- `lib/screens/task_form_screen.dart`: validasi input dan hasil `Navigator.pop`.
- `lib/screens/task_detail_screen.dart`: tampilan detail.
- `lib/widgets/task_card.dart`: komponen kartu tugas.
- `test/starter_test.dart`: contoh widget test untuk kondisi awal dan pemulihan dari error.

## Hal yang sengaja belum selesai

Cari komentar `TODO` pada model dan data layer. Lengkapi serialisasi `Task` dan penyimpanan/pembacaan JSON melalui `SharedPreferences`, termasuk kondisi data kosong atau tidak valid. Pastikan data bertahan setelah aplikasi ditutup dan dibuka kembali. Periksa kembali kriteria penerimaan dan bukti yang diminta pada naskah soal.

Menu titik tiga menyediakan simulasi error pemuatan dan hapus data untuk membantu pengujian. Hapus menu simulasi jika instruksi soal meminta hasil final tanpa kontrol pengujian.

## Batas starter

Starter tidak berisi jawaban teori, panduan penyelesaian ujian, ataupun implementasi persistence final. Kerjakan ujian secara individu sesuai aturan di naskah. Jangan menyalin starter ini sebagai pengganti bukti kerja sendiri.
