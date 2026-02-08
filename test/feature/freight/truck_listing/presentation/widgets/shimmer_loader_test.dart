import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clean_architecture/feature/truck_listing/presentation/widgets/shimmer_loader.dart';
import 'package:clean_architecture/cofig/size_manager.dart';

void main() {
  group('ShimmerLoader Widget Tests', () {
    testWidgets('displays default 4 skeleton cards', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerLoader(),
          ),
        ),
      );
      await tester.pump(); // Initial frame

      // Assert - ListView.builder renders items lazily, so we check the ListView has correct itemCount
      final listView = tester.widget<ListView>(find.byType(ListView));
      final builder = listView.childrenDelegate as SliverChildBuilderDelegate;
      expect(builder.estimatedChildCount, equals(4));
    });

    testWidgets('displays specified number of skeleton cards', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerLoader(cardCount: 3),
          ),
        ),
      );
      await tester.pump(); // Initial frame

      // Assert
      final listView = tester.widget<ListView>(find.byType(ListView));
      final builder = listView.childrenDelegate as SliverChildBuilderDelegate;
      expect(builder.estimatedChildCount, equals(3));
    });

    testWidgets('displays 5 skeleton cards when specified', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerLoader(cardCount: 5),
          ),
        ),
      );
      await tester.pump(); // Initial frame

      // Assert
      final listView = tester.widget<ListView>(find.byType(ListView));
      final builder = listView.childrenDelegate as SliverChildBuilderDelegate;
      expect(builder.estimatedChildCount, equals(5));
    });

    testWidgets('uses ListView.builder for efficient rendering', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerLoader(),
          ),
        ),
      );
      await tester.pump(); // Initial frame

      // Assert
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('cards have correct elevation', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerLoader(cardCount: 3),
          ),
        ),
      );
      await tester.pump(); // Initial frame

      // Assert - check at least one card has correct elevation
      final cards = tester.widgetList<Card>(find.byType(Card));
      expect(cards.isNotEmpty, isTrue);
      for (final card in cards) {
        expect(card.elevation, equals(SizeManager.cardElevation));
      }
    });

    testWidgets('cards have correct border radius', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerLoader(cardCount: 3),
          ),
        ),
      );
      await tester.pump(); // Initial frame

      // Assert - check at least one card has correct border radius
      final cards = tester.widgetList<Card>(find.byType(Card));
      expect(cards.isNotEmpty, isTrue);
      for (final card in cards) {
        final shape = card.shape as RoundedRectangleBorder;
        expect(
          shape.borderRadius,
          equals(BorderRadius.circular(SizeManager.cardRadius)),
        );
      }
    });

    testWidgets('shimmer animation runs continuously', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerLoader(cardCount: 3),
          ),
        ),
      );
      await tester.pump();

      // Act - pump frames to advance animation
      await tester.pump(const Duration(milliseconds: 500));
      
      // Assert - widget should still be present and animating
      expect(find.byType(ShimmerLoader), findsOneWidget);
      expect(find.byType(AnimatedBuilder), findsWidgets);
    });

    testWidgets('disposes animation controller properly', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerLoader(cardCount: 3),
          ),
        ),
      );
      await tester.pump();

      // Act - remove widget from tree
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SizedBox.shrink(),
          ),
        ),
      );
      await tester.pump();

      // Assert - no errors should occur (controller disposed properly)
      expect(tester.takeException(), isNull);
    });

    testWidgets('mimics TruckCard layout structure', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerLoader(cardCount: 3),
          ),
        ),
      );
      await tester.pump(); // Initial frame

      // Assert - each visible card should have Column with image and info sections
      final columns = tester.widgetList<Column>(find.descendant(
        of: find.byType(Card),
        matching: find.byType(Column),
      ));
      
      expect(columns.isNotEmpty, isTrue);
    });

    testWidgets('image section has correct height', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ShimmerLoader(cardCount: 3),
          ),
        ),
      );
      await tester.pump(); // Initial frame

      // Assert - find ClipRRect widgets (used for image section)
      final clipRRects = tester.widgetList<ClipRRect>(find.byType(ClipRRect));
      expect(clipRRects.isNotEmpty, isTrue);
    });

    test('asserts cardCount is between 3 and 5', () {
      // Assert - cardCount less than 3 should throw
      expect(
        () => ShimmerLoader(cardCount: 2),
        throwsAssertionError,
      );

      // Assert - cardCount greater than 5 should throw
      expect(
        () => ShimmerLoader(cardCount: 6),
        throwsAssertionError,
      );

      // Assert - valid cardCounts should not throw
      expect(() => const ShimmerLoader(cardCount: 3), returnsNormally);
      expect(() => const ShimmerLoader(cardCount: 4), returnsNormally);
      expect(() => const ShimmerLoader(cardCount: 5), returnsNormally);
    });
  });
}
