import 'package:flutter/foundation.dart';

/// Mixin adalah cara Dart untuk berbagi perilaku (behavior) antar-class
/// tanpa menggunakan hirarki pewarisan (inheritance) tunggal.
mixin Loggable {
  /// Method ini bisa digunakan oleh class apa pun yang memasang `with Loggable`
  void logAction(String action) {
    // Mengambil timestamp waktu saat ini dan mengubahnya ke format teks ISO-8601
    final timestamp = DateTime.now().toIso8601String();
    
    // debugPrint menangani pencetakan log di lingkungan Flutter
    // tanpa memicu peringatan Linter 'avoid_print'
    debugPrint('LOG [$timestamp]:$action');
  }
}