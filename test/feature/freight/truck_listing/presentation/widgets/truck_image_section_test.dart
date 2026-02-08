import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clean_architecture/feature/truck_listing/presentation/widgets/truck_image_section.dart';
import 'package:clean_architecture/cofig/string_manager.dart';
import 'package:clean_architecture/cofig/size_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';

void main() {
  group('TruckImageSection Widget Tests', () {
    testWidgets('displays available badge when truck is available',
        (WidgetTester tester) async {
      // Arrange
      const imageUrl = 'https://example.com/truck.jpg';
      const isAvailable = true;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TruckImageSection(
              imageUrl: imageUrl,
              isAvailable: isAvailable,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(StringManager.available), findsOneWidget);
      expect(find.text(StringManager.busy), findsNothing);
    });

    testWidgets('displays busy badge when truck is not available',
        (WidgetTester tester) async {
      // Arrange
      const imageUrl = 'https://example.com/truck.jpg';
      const isAvailable = false;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TruckImageSection(
              imageUrl: imageUrl,
              isAvailable: isAvailable,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(StringManager.busy), findsOneWidget);
      expect(find.text(StringManager.available), findsNothing);
    });

    testWidgets('displays ClipRRect with correct border radius',
        (WidgetTester tester) async {
      // Arrange
      const imageUrl = 'https://example.com/truck.jpg';
      const isAvailable = true;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TruckImageSection(
              imageUrl: imageUrl,
              isAvailable: isAvailable,
            ),
          ),
        ),
      );

      // Assert
      final clipRRect = tester.widget<ClipRRect>(find.byType(ClipRRect));
      expect(
        clipRRect.borderRadius,
        BorderRadius.circular(SizeManager.cardRadius),
      );
    });

    testWidgets('displays Stack with image and badge',
        (WidgetTester tester) async {
      // Arrange
      const imageUrl = 'https://example.com/truck.jpg';
      const isAvailable = true;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TruckImageSection(
              imageUrl: imageUrl,
              isAvailable: isAvailable,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(Positioned), findsOneWidget);
      // Verify the Stack contains both the image and the badge
      final stackFinder = find.descendant(
        of: find.byType(TruckImageSection),
        matching: find.byType(Stack),
      );
      expect(stackFinder, findsOneWidget);
    });

    testWidgets('badge has correct color for available truck',
        (WidgetTester tester) async {
      // Arrange
      const imageUrl = 'https://example.com/truck.jpg';
      const isAvailable = true;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TruckImageSection(
              imageUrl: imageUrl,
              isAvailable: isAvailable,
            ),
          ),
        ),
      );

      // Assert
      final container = tester.widget<Container>(
        find.ancestor(
          of: find.text(StringManager.available),
          matching: find.byType(Container),
        ).first,
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, AppColors.success);
    });

    testWidgets('badge has correct color for busy truck',
        (WidgetTester tester) async {
      // Arrange
      const imageUrl = 'https://example.com/truck.jpg';
      const isAvailable = false;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TruckImageSection(
              imageUrl: imageUrl,
              isAvailable: isAvailable,
            ),
          ),
        ),
      );

      // Assert
      final container = tester.widget<Container>(
        find.ancestor(
          of: find.text(StringManager.busy),
          matching: find.byType(Container),
        ).first,
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, AppColors.error);
    });

    testWidgets('image has correct height',
        (WidgetTester tester) async {
      // Arrange
      const imageUrl = 'https://example.com/truck.jpg';
      const isAvailable = true;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TruckImageSection(
              imageUrl: imageUrl,
              isAvailable: isAvailable,
            ),
          ),
        ),
      );

      // Assert
      final image = tester.widget<Image>(find.byType(Image));
      expect(image.height, SizeManager.imageHeight);
    });
  });
}
