import 'package:flutter/material.dart';
import 'screens/equipment_list_screen.dart';

/// Fungsi utama (entry point) yang pertama kali dijalankan saat aplikasi Flutter dinyalakan
void main() {
  runApp(const LabRentalApp());
}

/// Root Widget aplikasi Flutter
class LabRentalApp extends StatelessWidget {
  const LabRentalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab Rental App',
      
      // Menghilangkan banner tulisan "DEBUG" di pojok kanan atas emulator
      debugShowCheckedModeBanner: false,
      
      // Mengatur tema warna global aplikasi menggunakan Material Design 3
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      
      // Menentukan Layar 1 (EquipmentListScreen) sebagai layar pertama yang tampil
      home: const EquipmentListScreen(),
    );
  }
}