# Featured Carrier Integration - Complete Guide

## Overview
This document outlines the complete integration of the Featured Carrier feature following Clean Architecture principles.

## Architecture Layers

### 1. Data Layer

#### Models (`lib/feature/landing/data/`)
- `featured_carrier_response.dart` - JSON response models with serialization
  - `FeaturedCarrierBaseResponse`
  - `FeaturedCarrierData`
  - `CarrierTruck`
  - `TruckLocation`

#### Data Sources (`lib/feature/landing/data/datasources/`)
- `featured_carrier_remote_data_source.dart` - Abstract interface
- `featured_carrier_remote_data_source_impl.dart` - API implementation

#### Repositories (`lib/feature/landing/data/repositories/`)
- `featured_carrier_repository_impl.dart` - Repository implementation with error handling

### 2. Domain Layer

#### Entities (`lib/feature/landing/domain/entity/`)
- `featured_carrier_entity.dart` - Business logic entities
  - `FeaturedCarrierResponseEntity`
  - `FeaturedCarrierDataEntity`
  - `CarrierTruckEntity`
  - `TruckLocationEntity`

#### Repositories (`lib/feature/landing/domain/repositories/`)
- `featured_carrier_repository.dart` - Repository interface

#### Use Cases (`lib/feature/landing/domain/usecases/`)
- `get_featured_carriers_usecase.dart` - Business logic for fetching featured carriers

### 3. Presentation Layer

#### BLoC (`lib/feature/landing/presentation/bloc/`)
- `featured_carrier_bloc.dart` - State management
- `featured_carrier_event.dart` - Events (LoadFeaturedCarriers)
- `featured_carrier_state.dart` - States (Initial, Loading, Loaded, Error)

#### Screens (`lib/feature/landing/presentation/screen/`)
- `landing_page.dart` - Main landing page
- `landing_detail_page.dart` - Detail page for carrier listings

## Configuration Files Updated

### 1. API Client (`lib/core/network/api_client.dart`)
Added endpoint:
```dart
@GET("/carriers/featured")
Future<FeaturedCarrierBaseResponse> getFeaturedCarriers();
```

### 2. Mapper (`lib/cofig/mapper.dart`)
Added mappers:
```dart
extension CarrierTruckMapper on CarrierTruck {
  CarrierTruckEntity toEntity() { ... }
}

extension TruckLocationMapper on TruckLocation {
  TruckLocationEntity toEntity() { ... }
}
```

### 3. Dependency Injection (`lib/core/di.dart`)
Registered:
- Data Source: `FeaturedCarrierRemoteDataSource`
- Repository: `FeaturedCarrierRepository`
- Use Case: `GetFeaturedCarriersUseCase`
- BLoC: `FeaturedCarrierBloc`

## Usage Example

### In your widget:

```dart
import 'package:clean_architecture/feature/landing/presentation/bloc/featured_carrier_bloc.dart';
import 'package:clean_architecture/feature/landing/presentation/bloc/featured_carrier_event.dart';
import 'package:clean_architecture/feature/landing/presentation/bloc/featured_carrier_state.dart';
import 'package:clean_architecture/core/di.dart' as di;

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<FeaturedCarrierBloc>()
        ..add(const LoadFeaturedCarriers()),
      child: BlocBuilder<FeaturedCarrierBloc, FeaturedCarrierState>(
        builder: (context, state) {
          if (state is FeaturedCarrierLoading) {
            return CircularProgressIndicator();
          }
          
          if (state is FeaturedCarrierLoaded) {
            return ListView.builder(
              itemCount: state.carriers.length,
              itemBuilder: (context, index) {
                final carrier = state.carriers[index];
                return ListTile(
                  title: Text(carrier.model),
                  subtitle: Text(carrier.company),
                );
              },
            );
          }
          
          if (state is FeaturedCarrierError) {
            return Text('Error: ${state.message}');
          }
          
          return Container();
        },
      ),
    );
  }
}
```

## API Endpoint

Expected API endpoint: `GET /carriers/featured`

Expected Response Format:
```json
{
  "status": "success",
  "results": 10,
  "data": {
    "featuredCarrier": [
      {
        "_id": "123",
        "truckOwner": "owner_id",
        "driver": ["driver_id_1"],
        "company": "Company Name",
        "model": "Volvo FH16",
        "plateNumber": "ABC123",
        "brand": "Volvo",
        "loadCapacity": 25000,
        "features": ["GPS", "Refrigerated"],
        "location": {
          "startLocation": "Denver",
          "destinationLocation": "Chicago",
          "_id": "loc_123"
        },
        "image": ["url1", "url2"],
        "aboutTruck": "Description",
        "isAvailable": true,
        "isFeatured": true,
        "isVerified": true,
        "createdAt": "2024-01-01T00:00:00.000Z",
        "updatedAt": "2024-01-01T00:00:00.000Z"
      }
    ]
  }
}
```

## Testing

To test the integration:

1. Ensure your API endpoint is configured correctly in `base_url_config.dart`
2. Run code generation: `flutter pub run build_runner build --delete-conflicting-outputs`
3. Use the BLoC in your widget
4. Trigger the `LoadFeaturedCarriers` event
5. Handle the different states (Loading, Loaded, Error)

## TODO Items

- [ ] Update API endpoint URL when backend is ready
- [ ] Add proper status code validation in repository
- [ ] Implement caching strategy
- [ ] Add pagination support if needed
- [ ] Write unit tests for all layers
- [ ] Write widget tests for UI components
- [ ] Add error retry mechanism
- [ ] Implement pull-to-refresh functionality

## Files Created

### Data Layer
1. `lib/feature/landing/data/datasources/featured_carrier_remote_data_source.dart`
2. `lib/feature/landing/data/datasources/featured_carrier_remote_data_source_impl.dart`
3. `lib/feature/landing/data/repositories/featured_carrier_repository_impl.dart`

### Domain Layer
4. `lib/feature/landing/domain/repositories/featured_carrier_repository.dart`
5. `lib/feature/landing/domain/usecases/get_featured_carriers_usecase.dart`

### Presentation Layer
6. `lib/feature/landing/presentation/bloc/featured_carrier_bloc.dart`
7. `lib/feature/landing/presentation/bloc/featured_carrier_event.dart`
8. `lib/feature/landing/presentation/bloc/featured_carrier_state.dart`

## Notes

- The integration follows the existing project structure exactly
- All dependencies are properly registered in DI
- Mappers are added to convert between DTOs and Entities
- Error handling is implemented using Either<Failure, Success> pattern
- BLoC pattern is used for state management
- The code is ready to use once the API endpoint is available
