import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clean_architecture/feature/truck_listing/presentation/widgets/error_retry_widget.dart';
import 'package:clean_architecture/cofig/string_manager.dart';
import 'package:clean_architecture/core/colors/app_colors.dart';

void main() {
  group('ErrorRetryWidget Tests', () {
    const testMessage = 'Test error message';

    testWidgets('should display error icon', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorRetryWidget(
              message: testMessage,
              onRetry: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      final icon = tester.widget<Icon>(find.byIcon(Icons.error_outline));
      expect(icon.color, AppColors.error);
      expect(icon.size, 64);
    });

    testWidgets('should display error message', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorRetryWidget(
              message: testMessage,
              onRetry: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(testMessage), findsOneWidget);
    });

    testWidgets('should display retry button with correct text', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorRetryWidget(
              message: testMessage,
              onRetry: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(StringManager.retry), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should call onRetry when retry button is tapped', (tester) async {
      // Arrange
      bool retryWasCalled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorRetryWidget(
              message: testMessage,
              onRetry: () {
                retryWasCalled = true;
              },
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      // Assert
      expect(retryWasCalled, true);
    });

    testWidgets('should center content vertically and horizontally', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ErrorRetryWidget(
              message: testMessage,
              onRetry: () {},
            ),
          ),
        ),
      );

      // Assert
      final column = tester.widget<Column>(find.byType(Column));
      expect(column.mainAxisAlignment, MainAxisAlignment.center);
      expect(column.crossAxisAlignment, CrossAxisAlignment.center);
    });
  });
}
