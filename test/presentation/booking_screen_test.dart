import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:handy_man/data/models/service_provider.dart';
import 'package:handy_man/presentation/screens/booking/booking_screen.dart';
import 'package:handy_man/presentation/state/bookings_notifier.dart';

void main() {
  testWidgets('Booking form renders correctly with all fields', (WidgetTester tester) async {
    // 1. Mock Data එකක් හදාගන්නවා
    const mockProvider = ServiceProvider(
      id: 'p001',
      name: 'Kamal Perera',
      categoryId: 'plumbing',
      rating: 4.5,
      reviewCount: 10,
      completedJobs: 20,
      experienceYears: 5,
      hourlyRate: 2000,
      location: 'Colombo',
      isAvailable: true,
      description: 'Test Description',
      skills: ['Plumbing'],
    );

    // 2. SharedPreferences mock කරනවා (BookingsNotifier එකට ඕනේ නිසා)
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    // 3. Widget එක Pump (Load) කරනවා
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => BookingsNotifier(prefs)),
        ],
        child: const MaterialApp(
          home: BookingScreen(provider: mockProvider),
        ),
      ),
    );

    // 4. UI එකේ අදාළ දේවල් තියෙනවද කියලා Check කරනවා
    expect(find.text('Book Service'), findsOneWidget); // AppBar title
    expect(find.text('Full Name'), findsOneWidget); // Name field
    expect(find.text('Phone Number'), findsOneWidget); // Phone field
    // Scroll down to find the button
    await tester.drag(find.byType(ListView), const Offset(0, -1000));
    await tester.pumpAndSettle();
    
    expect(find.text('Confirm Booking'), findsOneWidget); // Submit button
  });
}
