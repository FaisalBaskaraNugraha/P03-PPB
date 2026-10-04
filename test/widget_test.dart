import 'package:flutter_test/flutter_test.dart';
import 'package:p03_lab_rental/main.dart';

void main() {
  testWidgets('Uji render utama aplikasi Lab Rental', (WidgetTester tester) async {
    // Ubah MyApp menjadi LabRentalApp
    await tester.pumpWidget(const LabRentalApp());

    // Memastikan widget utama berhasil dimuat tanpa crash
    expect(find.text('Inventaris Alat Lab'), findsOneWidget);
  });
}