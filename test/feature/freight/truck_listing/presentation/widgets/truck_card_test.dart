import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clean_architecture/feature/truck_listing/domain/entities/truck.dart';
import 'package:clean_architecture/feature/truck_listing/presentation/widgets/truck_card.dart';
import 'package:clean_architecture/feature/truck_listing/presentation/widgets/truck_image_section.dart';
import 'package:clean_architecture/feature/truck_listing/presentation/widgets/truck_info_section.dart';
import 'package:clean_architecture/cofig/string_manager.dart';

void main() {
  group('TruckCard Widget Tests', () {
    // Helper function to create a test truck
    Truck createTestTruck({bool isAvailable = true}) {
      return Truck(
        id: 'test_truck_1',
        model: 'Isuzu FRR',
        company: 'Swift Logistics',
        pricePerDay: 5000,
        pricePerHour: 250,
        capacityTons: 10.0,
        type: TruckType.flatbed,
        location: 'Addis Ababa',
        radiusKm: 50,
        imageUrl: 'https://example.com/truck.jpg',
        isAvailable: isAvailable,
      );
    }

    // Helper function to wrap widget in MaterialApp for testing
    Widget createTestWidget(Widget child) {
      return MaterialApp(
        home: Scaffold(
          body: child,
        ),
      );
    }

    testWidgets('displays truck information correctly', (WidgetTester tester) async {
      // Arrange
      final truck = createTestTruck();

      // Act
      await tester.pumpWidget(createTestWidget(TruckCard(truck: truck)));

      // Assert
      expect(find.text('Isuzu FRR'), findsOneWidget);
      expect(find.text('Swift Logistics'), findsOneWidget);
      expect(find.textContaining('ETB 5000'), findsOneWidget);
      expect(find.textContaining('ETB 250'), findsOneWidget);
      expect(find.textContaining('10.0 ${StringManager.tons}'), findsOneWidget);
      expect(find.textContaining('Addis Ababa'), findsOneWidget);
      expect(find.textContaining('50km radius'), findsOneWidget);
    });

    testWidgets('displays "Available" badge when truck is available', (WidgetTester tester) async {
      // Arrange
      final truck = createTestTruck(isAvailable: true);

      // Act
      await tester.pumpWidget(createTestWidget(TruckCard(truck: truck)));

      // Assert
      expect(find.text(StringManager.available), findsOneWidget);
      expect(find.text(StringManager.busy), findsNothing);
    });

    testWidgets('displays "Busy" badge when truck is not available', (WidgetTester tester) async {
      // Arrange
      final truck = createTestTruck(isAvailable: false);

      // Act
      await tester.pumpWidget(createTestWidget(TruckCard(truck: truck)));

      // Assert
      expect(find.text(StringManager.busy), findsOneWidget);
      expect(find.text(StringManager.available), findsNothing);
    });

    testWidgets('displays "Request Truck" button when truck is available', (WidgetTester tester) async {
      // Arrange
      final truck = createTestTruck(isAvailable: true);

      // Act
      await tester.pumpWidget(createTestWidget(TruckCard(truck: truck)));

      // Assert
      expect(find.text(StringManager.requestTruck), findsOneWidget);
      expect(find.text(StringManager.notifyWhenFree), findsNothing);
    });

    testWidgets('displays "Notify When Free" button when truck is busy', (WidgetTester tester) async {
      // Arrange
      final truck = createTestTruck(isAvailable: false);

      // Act
      await tester.pumpWidget(createTestWidget(TruckCard(truck: truck)));

      // Assert
      expect(find.text(StringManager.notifyWhenFree), findsOneWidget);
      expect(find.text(StringManager.requestTruck), findsNothing);
    });

    testWidgets('always displays "View Details" button', (WidgetTester tester) async {
      // Arrange
      final availableTruck = createTestTruck(isAvailable: true);
      final busyTruck = createTestTruck(isAvailable: false);

      // Act & Assert - Available truck
      await tester.pumpWidget(createTestWidget(TruckCard(truck: availableTruck)));
      expect(find.text(StringManager.viewDetails), findsOneWidget);

      // Act & Assert - Busy truck
      await tester.pumpWidget(createTestWidget(TruckCard(truck: busyTruck)));
      expect(find.text(StringManager.viewDetails), findsOneWidget);
    });

    testWidgets('contains TruckImageSection and TruckInfoSection', (WidgetTester tester) async {
      // Arrange
      final truck = createTestTruck();

      // Act
      await tester.pumpWidget(createTestWidget(TruckCard(truck: truck)));

      // Assert
      expect(find.byType(TruckImageSection), findsOneWidget);
      expect(find.byType(TruckInfoSection), findsOneWidget);
    });

    testWidgets('wraps content in Card widget', (WidgetTester tester) async {
      // Arrange
      final truck = createTestTruck();

      // Act
      await tester.pumpWidget(createTestWidget(TruckCard(truck: truck)));

      // Assert
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('wraps content in InkWell for tap feedback', (WidgetTester tester) async {
      // Arrange
      final truck = createTestTruck();

      // Act
      await tester.pumpWidget(createTestWidget(TruckCard(truck: truck)));

      // Assert - Check that InkWell exists (there will be multiple due to buttons)
      expect(find.byType(InkWell), findsWidgets);
    });

    testWidgets('calls onTap callback when tapped', (WidgetTester tester) async {
      // Arrange
      final truck = createTestTruck();
      bool tapped = false;
      void onTap() {
        tapped = true;
      }

      // Act
      await tester.pumpWidget(createTestWidget(TruckCard(truck: truck, onTap: onTap)));
      // Tap on the card itself (find by TruckCard type)
      await tester.tap(find.byType(TruckCard));
      await tester.pumpAndSettle();

      // Assert
      expect(tapped, isTrue);
    });

    testWidgets('does not throw when onTap is null', (WidgetTester tester) async {
      // Arrange
      final truck = createTestTruck();

      // Act & Assert
      await tester.pumpWidget(createTestWidget(TruckCard(truck: truck)));
      await tester.tap(find.byType(TruckCard));
      await tester.pumpAndSettle();
      // No exception should be thrown
    });
  });
}
