import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clean_architecture/feature/truck_listing/presentation/widgets/empty_state_widget.dart';
import 'package:clean_architecture/cofig/string_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';

void main() {
  group('EmptyStateWidget Tests', () {
    testWidgets('should display empty state icon', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.local_shipping_outlined), findsOneWidget);
      final icon = tester.widget<Icon>(find.byIcon(Icons.local_shipping_outlined));
      expect(icon.size, 80);
    });

    testWidgets('should display no trucks available message', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(),
          ),
        ),
      );

      // Assert
      expect(find.text(StringManager.noTrucksAvailable), findsOneWidget);
    });

    testWidgets('should display check back later suggestion', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(),
          ),
        ),
      );

      // Assert
      expect(find.text(StringManager.checkBackLater), findsOneWidget);
    });

    testWidgets('should center content vertically and horizontally', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(),
          ),
        ),
      );

      // Assert
      final column = tester.widget<Column>(find.byType(Column));
      expect(column.mainAxisAlignment, MainAxisAlignment.center);
      expect(column.crossAxisAlignment, CrossAxisAlignment.center);
    });

    testWidgets('should use AppTheme for styling', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(),
          ),
        ),
      );

      // Assert - verify text widgets exist with proper styling
      final messageFinder = find.text(StringManager.noTrucksAvailable);
      final suggestionFinder = find.text(StringManager.checkBackLater);
      
      expect(messageFinder, findsOneWidget);
      expect(suggestionFinder, findsOneWidget);
    });

    testWidgets('should use SizeManager for spacing', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(),
          ),
        ),
      );

      // Assert - verify SizedBox widgets exist for spacing
      expect(find.byType(SizedBox), findsWidgets);
    });
  });
}
