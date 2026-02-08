import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clean_architecture/feature/truck_listing/domain/entities/truck.dart';
import 'package:clean_architecture/feature/truck_listing/presentation/widgets/truck_info_section.dart';
import 'package:clean_architecture/cofig/string_manager.dart';
import 'package:clean_architecture/core/theme/app_theme.dart';

void main() {
  group('TruckInfoSection Widget Tests', () {
    // Helper function to create a test truck
    Truck createTestTruck({
      bool isAvailable = true,
      TruckType type = TruckType.flatbed,
    }) {
      return Truck(
        id: 'test-1',
        model: 'Isuzu FRR',
        company: 'Swift Logistics',
        pricePerDay: 5000,
        pricePerHour: 250,
        capacityTons: 10.0,
        type: type,
        location: 'Addis Ababa',
        radiusKm: 50,
        imageUrl: 'https://example.com/truck.jpg',
        isAvailable: isAvailable,
      );
    }

    // Helper function to wrap widget with MaterialApp for testing
    Widget createTestWidget(Widget child) {
      return MaterialApp(
        theme: TAppTheme.lightTheme,
        home: Scaffold(
          body: child,
        ),
      );
    }

    testWidgets('displays truck model name', (WidgetTester tester) async {
      final truck = createTestTruck();

      await tester.pumpWidget(createTestWidget(TruckInfoSection(truck: truck)));

      expect(find.text('Isuzu FRR'), findsOneWidget);
    });

    testWidgets('displays company name', (WidgetTester tester) async {
      final truck = createTestTruck();

      await tester.pumpWidget(createTestWidget(TruckInfoSection(truck: truck)));

      expect(find.text('Swift Logistics'), findsOneWidget);
    });

    testWidgets('displays pricing information correctly', (WidgetTester tester) async {
      final truck = createTestTruck();

      await tester.pumpWidget(createTestWidget(TruckInfoSection(truck: truck)));

      expect(
        find.text('ETB 5000 ${StringManager.pricePerDay} • ETB 250 ${StringManager.pricePerHour}'),
        findsOneWidget,
      );
    });

    testWidgets('displays capacity with tons label', (WidgetTester tester) async {
      final truck = createTestTruck();

      await tester.pumpWidget(createTestWidget(TruckInfoSection(truck: truck)));

      expect(find.text('10.0 ${StringManager.tons}'), findsOneWidget);
    });

    testWidgets('displays truck type for flatbed', (WidgetTester tester) async {
      final truck = createTestTruck(type: TruckType.flatbed);

      await tester.pumpWidget(createTestWidget(TruckInfoSection(truck: truck)));

      expect(find.text('Flatbed'), findsOneWidget);
      expect(find.byIcon(Icons.local_shipping), findsOneWidget);
    });

    testWidgets('displays truck type for refrigerated', (WidgetTester tester) async {
      final truck = createTestTruck(type: TruckType.refrigerated);

      await tester.pumpWidget(createTestWidget(TruckInfoSection(truck: truck)));

      expect(find.text('Refrigerated'), findsOneWidget);
      expect(find.byIcon(Icons.ac_unit), findsOneWidget);
    });

    testWidgets('displays truck type for dry van', (WidgetTester tester) async {
      final truck = createTestTruck(type: TruckType.dryVan);

      await tester.pumpWidget(createTestWidget(TruckInfoSection(truck: truck)));

      expect(find.text('Dry Van'), findsOneWidget);
      expect(find.byIcon(Icons.inventory_2), findsOneWidget);
    });

    testWidgets('displays location with radius', (WidgetTester tester) async {
      final truck = createTestTruck();

      await tester.pumpWidget(createTestWidget(TruckInfoSection(truck: truck)));

      expect(find.text('Addis Ababa • 50km radius'), findsOneWidget);
      expect(find.byIcon(Icons.location_on), findsOneWidget);
    });

    testWidgets('displays "Request Truck" button when truck is available', (WidgetTester tester) async {
      final truck = createTestTruck(isAvailable: true);

      await tester.pumpWidget(createTestWidget(TruckInfoSection(truck: truck)));

      expect(find.text(StringManager.requestTruck), findsOneWidget);
      expect(find.text(StringManager.notifyWhenFree), findsNothing);
    });

    testWidgets('displays "Notify When Free" button when truck is busy', (WidgetTester tester) async {
      final truck = createTestTruck(isAvailable: false);

      await tester.pumpWidget(createTestWidget(TruckInfoSection(truck: truck)));

      expect(find.text(StringManager.notifyWhenFree), findsOneWidget);
      expect(find.text(StringManager.requestTruck), findsNothing);
    });

    testWidgets('always displays "View Details" button', (WidgetTester tester) async {
      final truck = createTestTruck();

      await tester.pumpWidget(createTestWidget(TruckInfoSection(truck: truck)));

      expect(find.text(StringManager.viewDetails), findsOneWidget);
    });

    testWidgets('displays all required icons', (WidgetTester tester) async {
      final truck = createTestTruck();

      await tester.pumpWidget(createTestWidget(TruckInfoSection(truck: truck)));

      // Capacity icon
      expect(find.byIcon(Icons.scale), findsOneWidget);
      // Location icon
      expect(find.byIcon(Icons.location_on), findsOneWidget);
      // Type icon (flatbed)
      expect(find.byIcon(Icons.local_shipping), findsOneWidget);
    });

    testWidgets('buttons are tappable', (WidgetTester tester) async {
      final truck = createTestTruck();

      await tester.pumpWidget(createTestWidget(TruckInfoSection(truck: truck)));

      // Find and tap the Request Truck button
      final requestButton = find.text(StringManager.requestTruck);
      expect(requestButton, findsOneWidget);
      await tester.tap(requestButton);
      await tester.pump();

      // Find and tap the View Details button
      final viewDetailsButton = find.text(StringManager.viewDetails);
      expect(viewDetailsButton, findsOneWidget);
      await tester.tap(viewDetailsButton);
      await tester.pump();

      // No errors should occur
    });
  });
}
