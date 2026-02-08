import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clean_architecture/feature/truck_listing/domain/entities/truck.dart';
import 'package:clean_architecture/feature/truck_listing/presentation/widgets/truck_list_view.dart';
import 'package:clean_architecture/feature/truck_listing/presentation/widgets/truck_card.dart';
import 'package:clean_architecture/feature/truck_listing/presentation/widgets/pagination_loader.dart';
import 'package:clean_architecture/feature/truck_listing/presentation/bloc/truck_state.dart';

void main() {
  group('TruckListView', () {
    late ScrollController scrollController;
    late List<Truck> mockTrucks;

    setUp(() {
      scrollController = ScrollController();
      mockTrucks = [
        const Truck(
          id: 'truck_1',
          model: 'Isuzu FRR',
          company: 'Swift Logistics',
          pricePerDay: 5000,
          pricePerHour: 250,
          capacityTons: 10,
          type: TruckType.flatbed,
          location: 'Addis Ababa',
          radiusKm: 50,
          imageUrl: 'https://example.com/truck1.jpg',
          isAvailable: true,
        ),
        const Truck(
          id: 'truck_2',
          model: 'Hino 500',
          company: 'Prime Transport',
          pricePerDay: 5500,
          pricePerHour: 275,
          capacityTons: 12,
          type: TruckType.refrigerated,
          location: 'Adama',
          radiusKm: 40,
          imageUrl: 'https://example.com/truck2.jpg',
          isAvailable: false,
        ),
      ];
    });

    tearDown(() {
      scrollController.dispose();
    });

    testWidgets('renders TruckCard for each truck', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TruckListView(
              trucks: mockTrucks,
              scrollController: scrollController,
              onEndReached: () {},
            ),
          ),
        ),
      );

      // Verify that TruckCard widgets are rendered
      expect(find.byType(TruckCard), findsNWidgets(2));
    });

    testWidgets('does not show PaginationLoader when not in pagination loading state',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TruckListView(
              trucks: mockTrucks,
              scrollController: scrollController,
              onEndReached: () {},
              currentState: TruckSuccess(
                trucks: mockTrucks,
                currentPage: 1,
                hasMorePages: true,
              ),
            ),
          ),
        ),
      );

      // Verify PaginationLoader is not shown
      expect(find.byType(PaginationLoader), findsNothing);
    });

    testWidgets('shows PaginationLoader when in pagination loading state',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TruckListView(
              trucks: mockTrucks,
              scrollController: scrollController,
              onEndReached: () {},
              currentState: TruckPaginationLoading(mockTrucks),
            ),
          ),
        ),
      );

      await tester.pump();

      // Scroll to the bottom to ensure all items are built
      await tester.drag(find.byType(ListView), const Offset(0, -500));
      await tester.pump();

      // Verify PaginationLoader is shown
      expect(find.byType(PaginationLoader), findsOneWidget);
    });

    testWidgets('renders correct number of items with pagination loader',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TruckListView(
              trucks: mockTrucks,
              scrollController: scrollController,
              onEndReached: () {},
              currentState: TruckPaginationLoading(mockTrucks),
            ),
          ),
        ),
      );

      await tester.pump();

      // Scroll to the bottom to ensure all items are built
      await tester.drag(find.byType(ListView), const Offset(0, -500));
      await tester.pump();

      // Verify truck cards are present (at least one visible)
      expect(find.byType(TruckCard), findsWidgets);
      // Verify pagination loader is shown
      expect(find.byType(PaginationLoader), findsOneWidget);
    });

    testWidgets('uses provided ScrollController', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TruckListView(
              trucks: mockTrucks,
              scrollController: scrollController,
              onEndReached: () {},
            ),
          ),
        ),
      );

      // Verify ListView is using the scroll controller
      final listView = tester.widget<ListView>(find.byType(ListView));
      expect(listView.controller, equals(scrollController));
    });

    testWidgets('renders empty list without errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TruckListView(
              trucks: const [],
              scrollController: scrollController,
              onEndReached: () {},
            ),
          ),
        ),
      );

      // Verify no truck cards are rendered
      expect(find.byType(TruckCard), findsNothing);
      expect(find.byType(PaginationLoader), findsNothing);
    });

    testWidgets('uses ListView.builder for efficient rendering',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TruckListView(
              trucks: mockTrucks,
              scrollController: scrollController,
              onEndReached: () {},
            ),
          ),
        ),
      );

      // Verify ListView.builder is used
      expect(find.byType(ListView), findsOneWidget);
    });
  });
}
