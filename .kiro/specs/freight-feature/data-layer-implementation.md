# Freight Feature - Data Layer Implementation

## Overview
Complete data layer implementation for the freight feature following Clean Architecture patterns used in the project.

## Files Created

### 1. Data Layer

#### Data Sources
- **`lib/feature/freight/data/datasources/freight_remote_data_source.dart`**
  - Interface defining freight data operations
  - Methods: `createFreight()`, `getFreights()`

- **`lib/feature/freight/data/datasources/freight_remote_data_source_impl.dart`**
  - Implementation using ApiClient
  - Handles API calls for freight operations

#### Repositories
- **`lib/feature/freight/data/repositories/freight_repository_impl.dart`**
  - Implements FreightRepository interface
  - Maps DTOs to entities using extension methods
  - Handles error mapping with ErrorHandler

### 2. Domain Layer

#### Repositories (Interface)
- **`lib/feature/freight/domain/repositories/freight_repository.dart`**
  - Abstract repository interface
  - Returns `Either<Failure, FreightBaseResponseEntity>`

#### Use Cases
- **`lib/feature/freight/domain/usecases/create_freight_usecase.dart`**
  - Use case for creating freight
  - Takes `CreateFreightRequest` as parameter

- **`lib/feature/freight/domain/usecases/get_freights_usecase.dart`**
  - Use case for fetching freight list
  - Takes page number as parameter

### 3. Request Models

#### Updated: `lib/core/request/create_freight_request.dart`
- Added `toJson()` methods to all classes:
  - `CreateFreightRequest`
  - `Cargo`
  - `FreightRoute`
  - `Location`
  - `Schedule`
  - `TruckRequirement`
  - `Pricing`

### 4. API Client

#### Updated: `lib/core/network/api_client.dart`
- Added freight endpoints:
  ```dart
  @POST("/freights")
  Future<FreightBaseResponse> createFreight(@Body() CreateFreightRequest request);
  ```

### 5. Dependency Injection

#### Updated: `lib/core/di.dart`
- Added freight imports
- Registered data sources:
  ```dart
  sl.registerFactory<FreightRemoteDataSource>(
    () => FreightRemoteDataSourceImpl(client: sl()),
  );
  ```
- Registered repositories:
  ```dart
  sl.registerFactory<FreightRepository>(() => FreightRepositoryImpl(sl()));
  ```
- Registered use cases:
  ```dart
  sl.registerFactory(() => CreateFreightUseCase(sl()));
  sl.registerFactory(() => GetFreightsUseCase(sl()));
  ```

## Architecture Pattern

The implementation follows the same pattern as the truck listing and signup features:

```
Presentation Layer (UI/BLoC)
        ↓
Domain Layer (Use Cases)
        ↓
Domain Layer (Repository Interface)
        ↓
Data Layer (Repository Implementation)
        ↓
Data Layer (Remote Data Source)
        ↓
Network Layer (API Client)
```

## Data Flow

### Creating Freight:
1. User fills form in `PostFreightPage`
2. Form data converted to `CreateFreightRequest`
3. `CreateFreightUseCase` called with request
4. `FreightRepository` delegates to `FreightRemoteDataSource`
5. `ApiClient` makes POST request to `/freights`
6. Response mapped from DTO to Entity
7. Result returned as `Either<Failure, FreightBaseResponseEntity>`

### Getting Freights:
1. `GetFreightsUseCase` called with page number
2. `FreightRepository` delegates to `FreightRemoteDataSource`
3. `ApiClient` makes GET request to `/freights?page=X`
4. Response mapped from DTO to Entity
5. Result returned as `Either<Failure, FreightBaseResponseEntity>`

## Mapper Extensions

The mapper uses extension methods (already implemented in `lib/cofig/mapper.dart`):

```dart
extension FreightDtoMapper on FreightDto {
  FreightEntity toEntity() { ... }
}

extension CargoDtoMapper on CargoDto {
  CargoEntity toEntity() { ... }
}

// ... and more for Route, Location, Schedule, TruckRequirement, Pricing
```

## API Endpoints

### Create Freight
- **Method**: POST
- **Endpoint**: `/freights`
- **Body**: CreateFreightRequest (JSON)
- **Response**: FreightBaseResponse

### Get Freights
- **Method**: GET
- **Endpoint**: `/freights?page={page}&limit={limit}`
- **Response**: FreightBaseResponse

## Error Handling

All operations use the existing error handling pattern:
- Network errors caught and mapped to `Failure`
- HTTP status codes checked (200/201 = success)
- `ErrorHandler.handle(error)` for consistent error mapping

## Testing Considerations

### Unit Tests Needed:
1. **Data Source Tests**:
   - Test API calls are made correctly
   - Test response handling

2. **Repository Tests**:
   - Test DTO to Entity mapping
   - Test error handling
   - Test success/failure scenarios

3. **Use Case Tests**:
   - Test repository calls
   - Test parameter passing

## Next Steps

### To Complete the Feature:
1. **Create BLoC** for freight management:
   - `FreightBloc`
   - `FreightEvent` (CreateFreight, GetFreights, etc.)
   - `FreightState` (Loading, Success, Error, etc.)

2. **Integrate with UI**:
   - Connect `PostFreightPage` to `CreateFreightUseCase`
   - Create freight listing screen
   - Add loading/error states

3. **Add Validation**:
   - Form validation in UI
   - Request validation before API call

4. **Add Tests**:
   - Unit tests for all layers
   - Widget tests for UI
   - Integration tests

## Dependencies

All dependencies are already in the project:
- ✅ `dio` - HTTP client
- ✅ `retrofit` - Type-safe HTTP client
- ✅ `json_annotation` - JSON serialization
- ✅ `dartz` - Functional programming (Either)
- ✅ `equatable` - Value equality
- ✅ `get_it` - Dependency injection

## Verification

Run these commands to verify:

```bash
# Generate code
dart run build_runner build --delete-conflicting-outputs

# Analyze code
flutter analyze lib/feature/freight/

# Check for errors
flutter analyze lib/core/di.dart
```

## Status

✅ Data Layer - Complete
✅ Domain Layer - Complete  
✅ Request Models - Complete
✅ API Client - Complete
✅ Dependency Injection - Complete
✅ Mappers - Complete (already existed)
⏳ Presentation Layer (BLoC) - Pending
⏳ UI Integration - Pending
⏳ Tests - Pending

## Notes

- The implementation follows the exact same patterns as truck listing and signup features
- All code is type-safe and null-safe
- Error handling is consistent across the app
- Ready for BLoC implementation and UI integration
