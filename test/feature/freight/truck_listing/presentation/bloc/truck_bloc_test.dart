import 'package:clean_architecture/core/error/failure.dart';
import 'package:clean_architecture/feature/truck_listing/data/repositories/truck_repository_impl.dart';
import 'package:clean_architecture/feature/truck_listing/domain/entities/truck.dart';
import 'package:clean_architecture/feature/truck_listing/domain/usecases/get_trucks_usecase.dart';
import 'package:clean_architecture/feature/truck_listing/presentation/bloc/truck_bloc.dart';
import 'package:clean_architecture/feature/truck_listing/presentation/bloc/truck_event.dart';
import 'package:clean_architecture/feature/truck_listing/presentation/bloc/truck_state.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

// Test double for GetTrucksUseCase
class FakeGetTrucksUseCase implements GetTrucksUseCase {
  Either<Failure, List<Truck>>? _resultToReturn;
  int? _lastPageCalled;

  void setResultToReturn(Either<Failure, List<Truck>> result) {
    _resultToReturn = result;
  }

  int? get lastPageCalled => _lastPageCalled;

  @override
  Future<Either<Failure, List<Truck>>> call(int page) async {
    _lastPageCalled = page;
    return _resultToReturn ?? Right([]);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late TruckBloc bloc;
  late FakeGetTrucksUseCase fakeUseCase;

  setUp(() {
    fakeUseCase = FakeGetTrucksUseCase();
    bloc = TruckBloc(fakeUseCase);
  });

  tearDown(() {
    bloc.close();
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

  group('TruckBloc', () {
    test('initial state should be TruckInitial', () {
      expect(bloc.state, isA<TruckInitial>());
    });

    group('FetchInitialTrucks', () {
      test('should emit [TruckLoading, TruckSuccess] when use case returns success with 10 trucks', () async {
        // Arrange
        final testTrucks = createTestTrucks(10);
        fakeUseCase.setResultToReturn(Right(testTrucks));

        // Act
        bloc.add(FetchInitialTrucks());

        // Assert
        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<TruckLoading>(),
            isA<TruckSuccess>()
                .having((s) => s.trucks, 'trucks', testTrucks)
                .having((s) => s.currentPage, 'currentPage', 1)
                .having((s) => s.hasMorePages, 'hasMorePages', true),
          ]),
        );
        expect(fakeUseCase.lastPageCalled, equals(1));
      });

      test('should emit [TruckLoading, TruckSuccess] with hasMorePages=false when use case returns less than 10 trucks', () async {
        // Arrange
        final testTrucks = createTestTrucks(5);
        fakeUseCase.setResultToReturn(Right(testTrucks));

        // Act
        bloc.add(FetchInitialTrucks());

        // Assert
        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<TruckLoading>(),
            isA<TruckSuccess>()
                .having((s) => s.trucks, 'trucks', testTrucks)
                .having((s) => s.currentPage, 'currentPage', 1)
                .having((s) => s.hasMorePages, 'hasMorePages', false),
          ]),
        );
        expect(fakeUseCase.lastPageCalled, equals(1));
      });

      test('should emit [TruckLoading, TruckSuccess] with hasMorePages=false when use case returns empty list', () async {
        // Arrange
        fakeUseCase.setResultToReturn(const Right([]));

        // Act
        bloc.add(FetchInitialTrucks());

        // Assert
        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<TruckLoading>(),
            isA<TruckSuccess>()
                .having((s) => s.trucks, 'trucks', isEmpty)
                .having((s) => s.currentPage, 'currentPage', 1)
                .having((s) => s.hasMorePages, 'hasMorePages', false),
          ]),
        );
        expect(fakeUseCase.lastPageCalled, equals(1));
      });

      test('should emit [TruckLoading, TruckError] when use case returns NetworkFailure', () async {
        // Arrange
        const errorMessage = 'Network connection error';
        fakeUseCase.setResultToReturn(Left(NetworkFailure(errorMessage)));

        // Act
        bloc.add(FetchInitialTrucks());

        // Assert
        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<TruckLoading>(),
            isA<TruckError>().having((s) => s.message, 'message', errorMessage),
          ]),
        );
        expect(fakeUseCase.lastPageCalled, equals(1));
      });

      test('should emit [TruckLoading, TruckError] when use case returns UnexpectedFailure', () async {
        // Arrange
        const errorMessage = 'An unexpected error occurred';
        fakeUseCase.setResultToReturn(Left(UnexpectedFailure(errorMessage)));

        // Act
        bloc.add(FetchInitialTrucks());

        // Assert
        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<TruckLoading>(),
            isA<TruckError>().having((s) => s.message, 'message', errorMessage),
          ]),
        );
        expect(fakeUseCase.lastPageCalled, equals(1));
      });
    });

    group('RefreshTrucks', () {
      test('should emit [TruckLoading, TruckSuccess] and reset to page 1', () async {
        // Arrange
        final initialTrucks = createTestTrucks(10);
        final refreshedTrucks = createTestTrucks(10, startIndex: 100);
        
        // First load initial trucks
        fakeUseCase.setResultToReturn(Right(initialTrucks));
        bloc.add(FetchInitialTrucks());
        await bloc.stream.first;
        await bloc.stream.first;

        // Now refresh
        fakeUseCase.setResultToReturn(Right(refreshedTrucks));

        // Act
        bloc.add(RefreshTrucks());

        // Assert
        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<TruckLoading>(),
            isA<TruckSuccess>()
                .having((s) => s.trucks, 'trucks', refreshedTrucks)
                .having((s) => s.currentPage, 'currentPage', 1)
                .having((s) => s.hasMorePages, 'hasMorePages', true),
          ]),
        );
        expect(fakeUseCase.lastPageCalled, equals(1));
      });

      test('should emit [TruckLoading, TruckError] when refresh fails', () async {
        // Arrange
        const errorMessage = 'Failed to refresh';
        fakeUseCase.setResultToReturn(Left(NetworkFailure(errorMessage)));

        // Act
        bloc.add(RefreshTrucks());

        // Assert
        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<TruckLoading>(),
            isA<TruckError>().having((s) => s.message, 'message', errorMessage),
          ]),
        );
        expect(fakeUseCase.lastPageCalled, equals(1));
      });
    });

    group('FetchNextPage', () {
      test('should emit [TruckPaginationLoading, TruckSuccess] and append trucks when hasMorePages is true', () async {
        // Arrange
        final initialTrucks = createTestTrucks(10);
        final nextPageTrucks = createTestTrucks(10, startIndex: 10);
        
        // First load initial trucks
        fakeUseCase.setResultToReturn(Right(initialTrucks));
        bloc.add(FetchInitialTrucks());
        await bloc.stream.first;
        await bloc.stream.first;

        // Now fetch next page
        fakeUseCase.setResultToReturn(Right(nextPageTrucks));

        // Act
        bloc.add(FetchNextPage());

        // Assert
        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<TruckPaginationLoading>()
                .having((s) => s.currentTrucks, 'currentTrucks', initialTrucks),
            isA<TruckSuccess>()
                .having((s) => s.trucks.length, 'trucks.length', 20)
                .having((s) => s.trucks, 'trucks', [...initialTrucks, ...nextPageTrucks])
                .having((s) => s.currentPage, 'currentPage', 2)
                .having((s) => s.hasMorePages, 'hasMorePages', true),
          ]),
        );
        expect(fakeUseCase.lastPageCalled, equals(2));
      });

      test('should set hasMorePages to false when next page returns less than 10 trucks', () async {
        // Arrange
        final initialTrucks = createTestTrucks(10);
        final nextPageTrucks = createTestTrucks(5, startIndex: 10);
        
        // First load initial trucks
        fakeUseCase.setResultToReturn(Right(initialTrucks));
        bloc.add(FetchInitialTrucks());
        await bloc.stream.first;
        await bloc.stream.first;

        // Now fetch next page
        fakeUseCase.setResultToReturn(Right(nextPageTrucks));

        // Act
        bloc.add(FetchNextPage());

        // Assert
        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<TruckPaginationLoading>(),
            isA<TruckSuccess>()
                .having((s) => s.trucks.length, 'trucks.length', 15)
                .having((s) => s.currentPage, 'currentPage', 2)
                .having((s) => s.hasMorePages, 'hasMorePages', false),
          ]),
        );
        expect(fakeUseCase.lastPageCalled, equals(2));
      });

      test('should emit [TruckPaginationLoading, TruckPaginationError] when pagination fails', () async {
        // Arrange
        final initialTrucks = createTestTrucks(10);
        const errorMessage = 'Failed to load more trucks';
        
        // First load initial trucks
        fakeUseCase.setResultToReturn(Right(initialTrucks));
        bloc.add(FetchInitialTrucks());
        await bloc.stream.first;
        await bloc.stream.first;

        // Now fail next page
        fakeUseCase.setResultToReturn(Left(NetworkFailure(errorMessage)));

        // Act
        bloc.add(FetchNextPage());

        // Assert
        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<TruckPaginationLoading>()
                .having((s) => s.currentTrucks, 'currentTrucks', initialTrucks),
            isA<TruckPaginationError>()
                .having((s) => s.currentTrucks, 'currentTrucks', initialTrucks)
                .having((s) => s.message, 'message', errorMessage),
          ]),
        );
        expect(fakeUseCase.lastPageCalled, equals(2));
      });

      test('should not emit any state when hasMorePages is false', () async {
        // Arrange
        final initialTrucks = createTestTrucks(5); // Less than 10, so hasMorePages will be false
        
        // First load initial trucks
        fakeUseCase.setResultToReturn(Right(initialTrucks));
        bloc.add(FetchInitialTrucks());
        await bloc.stream.first;
        await bloc.stream.first;

        // Act
        bloc.add(FetchNextPage());

        // Assert
        // Wait a bit to ensure no state is emitted
        await Future.delayed(const Duration(milliseconds: 100));
        
        // The state should still be TruckSuccess with hasMorePages=false
        expect(bloc.state, isA<TruckSuccess>());
        final state = bloc.state as TruckSuccess;
        expect(state.hasMorePages, false);
        expect(state.trucks, initialTrucks);
        expect(state.currentPage, 1);
      });

      test('should not emit any state when current state is not TruckSuccess', () async {
        // Arrange - bloc is in TruckInitial state

        // Act
        bloc.add(FetchNextPage());

        // Assert
        // Wait a bit to ensure no state is emitted
        await Future.delayed(const Duration(milliseconds: 100));
        
        // The state should still be TruckInitial
        expect(bloc.state, isA<TruckInitial>());
      });

      test('should not emit any state when current state is TruckError', () async {
        // Arrange
        fakeUseCase.setResultToReturn(Left(NetworkFailure('Error')));
        bloc.add(FetchInitialTrucks());
        await bloc.stream.first;
        await bloc.stream.first;

        // Act
        bloc.add(FetchNextPage());

        // Assert
        // Wait a bit to ensure no state is emitted
        await Future.delayed(const Duration(milliseconds: 100));
        
        // The state should still be TruckError
        expect(bloc.state, isA<TruckError>());
      });
    });

    group('Multiple pagination', () {
      test('should correctly handle multiple pagination requests', () async {
        // Arrange
        final page1Trucks = createTestTrucks(10, startIndex: 0);
        final page2Trucks = createTestTrucks(10, startIndex: 10);
        final page3Trucks = createTestTrucks(10, startIndex: 20);
        
        // Load page 1
        fakeUseCase.setResultToReturn(Right(page1Trucks));
        bloc.add(FetchInitialTrucks());
        await bloc.stream.first;
        await bloc.stream.first;

        // Load page 2
        fakeUseCase.setResultToReturn(Right(page2Trucks));
        bloc.add(FetchNextPage());
        await bloc.stream.first;
        await bloc.stream.first;

        // Load page 3
        fakeUseCase.setResultToReturn(Right(page3Trucks));
        bloc.add(FetchNextPage());

        // Assert
        await expectLater(
          bloc.stream,
          emitsInOrder([
            isA<TruckPaginationLoading>(),
            isA<TruckSuccess>()
                .having((s) => s.trucks.length, 'trucks.length', 30)
                .having((s) => s.currentPage, 'currentPage', 3)
                .having((s) => s.hasMorePages, 'hasMorePages', true),
          ]),
        );
        expect(fakeUseCase.lastPageCalled, equals(3));
      });
    });
  });
}
