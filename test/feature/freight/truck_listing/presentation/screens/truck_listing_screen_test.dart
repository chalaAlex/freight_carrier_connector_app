import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clean_architecture/feature/truck_listing/presentation/screens/truck_listing_screen.dart';
import 'package:clean_architecture/feature/truck_listing/presentation/bloc/truck_bloc.dart';
import 'package:clean_architecture/feature/truck_listing/presentation/bloc/truck_event.dart';
import 'package:clean_architecture/feature/truck_listing/presentation/bloc/truck_state.dart';
import 'package:clean_architecture/feature/truck_listing/domain/entities/truck.dart';
import 'package:clean_architecture/feature/truck_listing/domain/usecases/get_trucks_usecase.dart';
import 'package:clean_architecture/feature/truck_listing/data/repositories/truck_repository_impl.dart';
import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/cofig/string_manager.dart';
import 'package:dartz/dartz.dart';
import 'package:clean_architecture/feature/truck_listing/presentation/widgets/shimmer_loader.dart';
import 'package:clean_architecture/feature/truck_listing/presentation/widgets/error_retry_widget.dart';
import 'package:clean_architecture/feature/truck_listing/presentation/widgets/empty_state_widget.dart';
import 'package:clean_architecture/feature/truck_listing/presentation/widgets/truck_list_view.dart';

// Fake GetTrucksUseCase for testing
class FakeGetTrucksUseCase implements GetTrucksUseCase {
  Either<Failure, List<Truck>>? _resultToReturn;
  final List<int> pagesRequested = [];

  void setResultToReturn(Either<Failure, List<Truck>> result) {
    _resultToReturn = result;
  }

  @override
  Future<Either<Failure, List<Truck>>> call(int page) async {
    pagesRequested.add(page);
    // Add a small delay to simulate async operation
    await Future.delayed(Duration.zero);
    return _resultToReturn ?? Right([]);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late FakeGetTrucksUseCase fakeUseCase;
  late TruckBloc truckBloc;

  setUp(() {
    fakeUseCase = FakeGetTrucksUseCase();
    truckBloc = TruckBloc(fakeUseCase);
  });

  tearDown(() {
    truckBloc.close();
  });

  // Helper function to create test trucks
  List<Truck> createTestTrucks(int count, {int startIndex = 0}) {
    return List.generate(
      count,
      (index) => Truck(
        id: 'truck_${startIndex + index}',
        model: 'Test Truck ${startIndex + index}',
        company: 'Test Company',
        pricePerDay: 5000.0,
        pricePerHour: 250.0,
        capacityTons: 5.0,
        type: TruckType.flatbed,
        location: 'Test Location',
        radiusKm: 30.0,
        imageUrl: 'https://example.com/truck_${startIndex + index}.jpg',
        isAvailable: true,
      ),
    );
  }

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<TruckBloc>.value(
        value: truckBloc,
        child: const TruckListingScreen(),
      ),
    );
  }

  group('TruckListingScreen', () {
    testWidgets('should display app bar with correct title', (tester) async {
      // Arrange
      fakeUseCase.setResultToReturn(Right([]));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Assert
      expect(find.text(StringManager.truckListingTitle), findsOneWidget);
    });

    testWidgets('should display search bar', (tester) async {
      // Arrange
      fakeUseCase.setResultToReturn(Right([]));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Assert
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('should display filter chips', (tester) async {
      // Arrange
      fakeUseCase.setResultToReturn(Right([]));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Assert
      expect(find.text(StringManager.filterAll), findsOneWidget);
      expect(find.text(StringManager.filterAvailable), findsOneWidget);
      expect(find.text(StringManager.filterRefrigerated), findsOneWidget);
    });

    testWidgets('should display floating action button', (tester) async {
      // Arrange
      fakeUseCase.setResultToReturn(Right([]));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      // Assert
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.text(StringManager.postFreight), findsOneWidget);
    });

    testWidgets('should display ShimmerLoader when state is TruckInitial',
        (tester) async {
      // Arrange
      fakeUseCase.setResultToReturn(Right([]));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert - Before the first pump, should show shimmer
      expect(find.byType(ShimmerLoader), findsOneWidget);
    });

    testWidgets('should display ShimmerLoader when state is TruckLoading',
        (tester) async {
      // Arrange
      fakeUseCase.setResultToReturn(Right([]));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      // Don't pump to completion, so we stay in loading state
      await tester.pump(Duration.zero);

      // Assert
      expect(find.byType(ShimmerLoader), findsOneWidget);
    });

    testWidgets('should display ErrorRetryWidget when state is TruckError',
        (tester) async {
      // Arrange
      const errorMessage = 'Network error';
      fakeUseCase.setResultToReturn(Left(NetworkFailure(errorMessage)));

      // Act
      await tester.runAsync(() async {
        await tester.pumpWidget(createWidgetUnderTest());
        // Wait for the async operation to complete
        await Future.delayed(const Duration(milliseconds: 100));
      });
      await tester.pump(); // Rebuild with new state

      // Assert
      expect(find.byType(ErrorRetryWidget), findsOneWidget);
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('should display EmptyStateWidget when trucks list is empty',
        (tester) async {
      // Arrange
      fakeUseCase.setResultToReturn(const Right([]));

      // Act
      await tester.runAsync(() async {
        await tester.pumpWidget(createWidgetUnderTest());
        // Wait for the async operation to complete
        await Future.delayed(const Duration(milliseconds: 100));
      });
      await tester.pump(); // Rebuild with new state

      // Assert
      expect(find.byType(EmptyStateWidget), findsOneWidget);
    });

    testWidgets('should display TruckListView when trucks are available',
        (tester) async {
      // Arrange
      final trucks = createTestTrucks(5);
      fakeUseCase.setResultToReturn(Right(trucks));

      // Act
      await tester.runAsync(() async {
        await tester.pumpWidget(createWidgetUnderTest());
        // Wait for the async operation to complete
        await Future.delayed(const Duration(milliseconds: 100));
      });
      await tester.pump(); // Rebuild with new state

      // Assert
      expect(find.byType(TruckListView), findsOneWidget);
      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    testWidgets('should update filter selection when chip is tapped',
        (tester) async {
      // Arrange
      fakeUseCase.setResultToReturn(Right([]));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();
      await tester.tap(find.text(StringManager.filterAvailable));
      await tester.pump();

      // Assert
      final filterChip = tester.widget<FilterChip>(
        find.widgetWithText(FilterChip, StringManager.filterAvailable),
      );
      expect(filterChip.selected, isTrue);
    });
  });
}
