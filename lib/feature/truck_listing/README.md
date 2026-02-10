# Truck Listing Feature

This feature implements a truck listing screen with pagination, following Clean Architecture principles.

## Architecture Overview

The feature uses **real API data only** with the following architecture:

```
presentation/
├── bloc/           # State management (flutter_bloc)
├── screens/        # Main screens
└── widgets/        # Reusable UI components

domain/
├── entities/       # Business objects (Truck)
├── repositories/   # Abstract interfaces
└── usecases/       # Business logic

data/
├── datasources/    # API service implementation
├── models/         # Data transfer objects with @JsonSerializable()
├── mappers/        # Entity-Model mapping
└── repositories/   # Repository implementations
```

## Data Flow

1. **API Service** (`TruckApiService`) fetches JSON data from server
2. **JSON Serialization** converts JSON to `TruckModel` using generated code
3. **Mapper** (`TruckMapper`) converts `TruckModel` to `Truck` entity
4. **Repository** handles error mapping and returns domain entities
5. **Use Case** orchestrates business logic
6. **Bloc** manages UI state
7. **Widgets** display truck data

## Key Components

### TruckModel (@JsonSerializable)
- Uses `@JsonSerializable()` annotation for automatic JSON serialization
- Generated code handles `fromJson()` and `toJson()` methods
- Extends `Truck` entity for inheritance

### TruckMapper
- Maps between `TruckModel` (data layer) and `Truck` (domain layer)
- Implements `Mapper<TruckModel, Truck>` interface
- Ensures clean separation between layers

### TruckApiService
- Real API implementation only
- Calls `GET /trucks?page=X&limit=10`
- Uses mapper to convert models to entities
- Handles network errors with proper exception mapping

## API Contract

### Server Endpoint
```
GET /trucks?page={page}&limit={limit}
```

### Expected Response Format
```json
{
  "trucks": [
    {
      "id": "string",
      "model": "string", 
      "company": "string",
      "pricePerDay": number,
      "pricePerHour": number,
      "capacityTons": number,
      "type": "flatbed" | "refrigerated" | "dryVan",
      "location": "string",
      "radiusKm": number,
      "imageUrl": "string",
      "isAvailable": boolean
    }
  ]
}
```

### Query Parameters
- `page`: Page number (1-based, required)
- `limit`: Number of trucks per page (default: 10)

## Code Generation

The feature uses code generation for:

1. **JSON Serialization**: `@JsonSerializable()` generates `fromJson()` and `toJson()`
2. **API Client**: `@RestApi()` generates HTTP client methods

To regenerate code after changes:
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## Testing

Comprehensive test coverage includes:
- **Unit Tests**: Data sources, repositories, use cases, mappers
- **Widget Tests**: All UI components
- **Bloc Tests**: State management logic

Run tests:
```bash
flutter test test/feature/truck_listing/
```

## Dependencies

- `flutter_bloc`: State management
- `dartz`: Functional programming (Either type)
- `get_it`: Dependency injection
- `retrofit`: API client generation
- `dio`: HTTP client
- `json_annotation`: JSON serialization annotations
- `json_serializable`: JSON code generation

## Error Handling

- **NetworkException**: API/network errors
- **NetworkFailure**: Mapped to domain failure
- **UnexpectedFailure**: Unexpected errors
- Proper error states in UI (retry buttons, error messages)