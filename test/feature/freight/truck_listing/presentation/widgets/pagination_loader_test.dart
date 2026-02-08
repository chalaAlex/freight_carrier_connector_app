import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clean_architecture/feature/truck_listing/presentation/widgets/pagination_loader.dart';
import 'package:clean_architecture/cofig/size_manager.dart';

void main() {
  group('PaginationLoader Widget Tests', () {
    testWidgets('should display CircularProgressIndicator', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PaginationLoader(),
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should have correct height from SizeManager', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PaginationLoader(),
          ),
        ),
      );

      // Assert
      final container = tester.widget<Container>(
        find.ancestor(
          of: find.byType(CircularProgressIndicator),
          matching: find.byType(Container),
        ),
      );
      expect(container.constraints?.maxHeight, SizeManager.paginationLoaderHeight);
    });

    testWidgets('should center the progress indicator', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PaginationLoader(),
          ),
        ),
      );

      // Assert
      final container = tester.widget<Container>(
        find.ancestor(
          of: find.byType(CircularProgressIndicator),
          matching: find.byType(Container),
        ),
      );
      expect(container.alignment, Alignment.center);
    });

    testWidgets('should have padding from SizeManager', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PaginationLoader(),
          ),
        ),
      );

      // Assert
      final container = tester.widget<Container>(
        find.ancestor(
          of: find.byType(CircularProgressIndicator),
          matching: find.byType(Container),
        ),
      );
      expect(container.padding, const EdgeInsets.all(SizeManager.s16));
    });
  });
}
