import 'package:flutter_test/flutter_test.dart';
import 'package:clean_architecture/feature/truck_listing/presentation/bloc/truck_event.dart';

void main() {
  group('TruckEvent', () {
    group('FetchInitialTrucks', () {
      test('should extend TruckEvent', () {
        expect(FetchInitialTrucks(), isA<TruckEvent>());
      });

      test('should support value equality', () {
        expect(FetchInitialTrucks(), equals(FetchInitialTrucks()));
      });

      test('should have empty props', () {
        expect(FetchInitialTrucks().props, isEmpty);
      });
    });

    group('RefreshTrucks', () {
      test('should extend TruckEvent', () {
        expect(RefreshTrucks(), isA<TruckEvent>());
      });

      test('should support value equality', () {
        expect(RefreshTrucks(), equals(RefreshTrucks()));
      });

      test('should have empty props', () {
        expect(RefreshTrucks().props, isEmpty);
      });
    });

    group('FetchNextPage', () {
      test('should extend TruckEvent', () {
        expect(FetchNextPage(), isA<TruckEvent>());
      });

      test('should support value equality', () {
        expect(FetchNextPage(), equals(FetchNextPage()));
      });

      test('should have empty props', () {
        expect(FetchNextPage().props, isEmpty);
      });
    });
  });
}
