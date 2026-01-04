import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geocamera_app/main.dart'; // Sesuaikan nama package Anda

void main() {
  // Skenario 1: Cek Tampilan Awal
  testWidgets('Cek elemen UI awal aplikasi', (WidgetTester tester) async {
    // 1. Build aplikasi virtual (Pump Widget)
    await tester.pumpWidget(const MyApp());

    // 2. Cek apakah judul AppBar muncul
    expect(find.text('GeoCamera Praktikum'), findsOneWidget);

    // 3. Cek apakah teks default lokasi muncul
    expect(find.text('Lokasi belum diambil'), findsOneWidget);

    // 4. Cek apakah tombol kamera ada (menggunakan Icon)
    expect(find.byIcon(Icons.camera_alt), findsOneWidget);

    // Catatan: Kita tidak menekan tombol kamera di sini karena
    // akan memicu pemanggilan Native Hardware yang akan error di lingkungan test virtual.
  });
}

