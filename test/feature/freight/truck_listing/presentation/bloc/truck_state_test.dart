import 'package:flutter_test/flutter_test.dart';
import 'package:clean_architecture/feature/truck_listing/domain/entities/truck.dart';
import 'package:clean_architecture/feature/truck_listing/presentation/bloc/truck_state.dart';

void main() {
  group('TruckState', () {
    group('TruckInitial', () {
      test('should extend TruckState', () {
        expect(TruckInitial(), isA<TruckState>());
      });

      test('should support value equality', () {
        expect(TruckInitial(), equals(TruckInitial()));
      });

      test('should have empty props', () {
        expect(TruckInitial().props, isEmpty);
      });
    });

    group('TruckLoading', () {
      test('should extend TruckState', () {
        expect(TruckLoading(), isA<TruckState>());
      });

      test('should support value equality', () {
        expect(TruckLoading(), equals(TruckLoading()));
      });

      test('should have empty props', () {
        expect(TruckLoading().props, isEmpty);
      });
    });

    group('TruckSuccess', () {
      final truck1 = Truck(
        id: '1',
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
      );

      final truck2 = Truck(
        id: '2',
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
      );

      test('should extend TruckState', () {
        final state = TruckSuccess(
          trucks: [truck1],
          currentPage: 1,
          hasMorePages: true,
        );
        expect(state, isA<TruckState>());
      });

      test('should support value equality', () {
        final state1 = TruckSuccess(
          trucks: [truck1],
          currentPage: 1,
          hasMorePages: true,
        );
        final state2 = TruckSuccess(
          trucks: [truck1],
          currentPage: 1,
          hasMorePages: true,
        );
        expect(state1, equals(state2));
      });

      test('should have correct props', () {
        final state = TruckSuccess(
          trucks: [truck1],
          currentPage: 1,
          hasMorePages: true,
        );
        expect(state.props, equals([[truck1], 1, true]));
      });

      test('should not be equal when trucks differ', () {
        final state1 = TruckSuccess(
          trucks: [truck1],
          currentPage: 1,
          hasMorePages: true,
        );
        final state2 = TruckSuccess(
          trucks: [truck2],
          currentPage: 1,
          hasMorePages: true,
        );
        expect(state1, isNot(equals(state2)));
      });

      test('should not be equal when currentPage differs', () {
        final state1 = TruckSuccess(
          trucks: [truck1],
          currentPage: 1,
          hasMorePages: true,
        );
        final state2 = TruckSuccess(
          trucks: [truck1],
          currentPage: 2,
          hasMorePages: true,
        );
        expect(state1, isNot(equals(state2)));
      });

      test('should not be equal when hasMorePages differs', () {
        final state1 = TruckSuccess(
          trucks: [truck1],
          currentPage: 1,
          hasMorePages: true,
        );
        final state2 = TruckSuccess(
          trucks: [truck1],
          currentPage: 1,
          hasMorePages: false,
        );
        expect(state1, isNot(equals(state2)));
      });

      group('copyWith', () {
        test('should return same state when no parameters provided', () {
          final state = TruckSuccess(
            trucks: [truck1],
            currentPage: 1,
            hasMorePages: true,
          );
          final copied = state.copyWith();
          expect(copied, equals(state));
        });

        test('should update trucks when provided', () {
          final state = TruckSuccess(
            trucks: [truck1],
            currentPage: 1,
            hasMorePages: true,
          );
          final copied = state.copyWith(trucks: [truck2]);
          expect(copied.trucks, equals([truck2]));
          expect(copied.currentPage, equals(1));
          expect(copied.hasMorePages, equals(true));
        });

        test('should update currentPage when provided', () {
          final state = TruckSuccess(
            trucks: [truck1],
            currentPage: 1,
            hasMorePages: true,
          );
          final copied = state.copyWith(currentPage: 2);
          expect(copied.trucks, equals([truck1]));
          expect(copied.currentPage, equals(2));
          expect(copied.hasMorePages, equals(true));
        });

        test('should update hasMorePages when provided', () {
          final state = TruckSuccess(
            trucks: [truck1],
            currentPage: 1,
            hasMorePages: true,
          );
          final copied = state.copyWith(hasMorePages: false);
          expect(copied.trucks, equals([truck1]));
          expect(copied.currentPage, equals(1));
          expect(copied.hasMorePages, equals(false));
        });

        test('should update multiple properties when provided', () {
          final state = TruckSuccess(
            trucks: [truck1],
            currentPage: 1,
            hasMorePages: true,
          );
          final copied = state.copyWith(
            trucks: [truck1, truck2],
            currentPage: 2,
            hasMorePages: false,
          );
          expect(copied.trucks, equals([truck1, truck2]));
          expect(copied.currentPage, equals(2));
          expect(copied.hasMorePages, equals(false));
        });
      });
    });

    group('TruckError', () {
      test('should extend TruckState', () {
        final state = TruckError('Error message');
        expect(state, isA<TruckState>());
      });

      test('should support value equality', () {
        final state1 = TruckError('Error message');
        final state2 = TruckError('Error message');
        expect(state1, equals(state2));
      });

      test('should have correct props', () {
        final state = TruckError('Error message');
        expect(state.props, equals(['Error message']));
      });

      test('should not be equal when message differs', () {
        final state1 = TruckError('Error 1');
        final state2 = TruckError('Error 2');
        expect(state1, isNot(equals(state2)));
      });
    });

    group('TruckPaginationLoading', () {
      final truck1 = Truck(
        id: '1',
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
      );

      test('should extend TruckState', () {
        final state = TruckPaginationLoading([truck1]);
        expect(state, isA<TruckState>());
      });

      test('should support value equality', () {
        final state1 = TruckPaginationLoading([truck1]);
        final state2 = TruckPaginationLoading([truck1]);
        expect(state1, equals(state2));
      });

      test('should have correct props', () {
        final state = TruckPaginationLoading([truck1]);
        expect(state.props, equals([[truck1]]));
      });

      test('should not be equal when currentTrucks differ', () {
        final truck2 = Truck(
          id: '2',
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
        );
        final state1 = TruckPaginationLoading([truck1]);
        final state2 = TruckPaginationLoading([truck2]);
        expect(state1, isNot(equals(state2)));
      });
    });

    group('TruckPaginationError', () {
      final truck1 = Truck(
        id: '1',
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
      );

      test('should extend TruckState', () {
        final state = TruckPaginationError([truck1], 'Error message');
        expect(state, isA<TruckState>());
      });

      test('should support value equality', () {
        final state1 = TruckPaginationError([truck1], 'Error message');
        final state2 = TruckPaginationError([truck1], 'Error message');
        expect(state1, equals(state2));
      });

      test('should have correct props', () {
        final state = TruckPaginationError([truck1], 'Error message');
        expect(state.props, equals([[truck1], 'Error message']));
      });

      test('should not be equal when currentTrucks differ', () {
        final truck2 = Truck(
          id: '2',
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
        );
        final state1 = TruckPaginationError([truck1], 'Error message');
        final state2 = TruckPaginationError([truck2], 'Error message');
        expect(state1, isNot(equals(state2)));
      });

      test('should not be equal when message differs', () {
        final state1 = TruckPaginationError([truck1], 'Error 1');
        final state2 = TruckPaginationError([truck1], 'Error 2');
        expect(state1, isNot(equals(state2)));
      });
    });
  });
}
