# Truck Listing Screen Fix Summary

## Issues Found and Fixed

### 1. Missing BLoC Provider
**Problem**: The `TruckListingScreen` was trying to access `TruckBloc` via `context.read<TruckBloc>()`, but the bloc was not provided in the route.

**Fix**: Added `BlocProvider` in `routes_manager.dart` for the truck listing route:
```dart
case Routes.truckListingRoute:
  return MaterialPageRoute(
    builder: (_) => BlocProvider(
      create: (_) => sl<TruckBloc>(),
      child: const TruckListingScreen(),
    ),
  );
```

### 2. Incorrect Data Model Structure
**Problem**: The `TruckDto` model had several mismatches with the backend API:
- `features` was defined as `TruckType` enum instead of `String`
- `image` field was mapped to `imageUrl` (wrong JSON key)
- `createdAt` and `updatedAt` were defined as `bool` instead of `String`

**Backend Response Structure**:
```json
{
  "statusCode": 200,
  "message": "Successfully retrieved all trucks",
  "total": 10,
  "data": {
    "trucks": [
      {
        "_id": "...",
        "model": "...",
        "features": "flatbed",  // String, not enum
        "image": ["url1", "url2"],  // Array of strings
        "createdAt": "2024-01-01T00:00:00.000Z",  // ISO date string
        "updatedAt": "2024-01-01T00:00:00.000Z"
      }
    ]
  }
}
```

**Fix**: Updated `TruckDto` in `truck_model.dart`:
- Changed `features` from `TruckType` to `String`
- Changed JSON key from `imageUrl` to `image`
- Changed `createdAt` and `updatedAt` from `bool` to `String?`

### 3. Missing Mapper Logic
**Problem**: The mapper didn't convert the string `features` from the backend to the `TruckType` enum expected by the entity.

**Fix**: Updated `TruckDataMapper` in `mapper.dart` to include conversion logic:
```dart
TruckType _mapStringToTruckType(String features) {
  switch (features.toLowerCase()) {
    case 'flatbed':
      return TruckType.flatbed;
    case 'refrigerated':
      return TruckType.refrigerated;
    case 'dryvan':
      return TruckType.dryVan;
    default:
      return TruckType.dryVan;
  }
}
```

Also added date parsing for `createdAt` and `updatedAt`:
```dart
createdAt: dto.createdAt != null ? DateTime.tryParse(dto.createdAt!) : null,
updatedAt: dto.updatedAt != null ? DateTime.tryParse(dto.updatedAt!) : null,
```

### 4. Image Index Bug in TruckCard
**Problem**: The `TruckCard` widget was using the list index to access the truck's images array:
```dart
imageUrl: truck.images[index]  // Wrong! index is the truck's position in the list
```

This would cause an out-of-bounds error when there are more trucks than images.

**Fix**: Changed to use the first image in the array:
```dart
imageUrl: truck.images.isNotEmpty ? truck.images[0] : ''
```

## Files Modified

1. **lib/cofig/routes_manager.dart**
   - Added `TruckBloc` import
   - Added `BlocProvider` for truck listing route

2. **lib/feature/truck_listing/data/models/truck_model.dart**
   - Fixed `features` type from `TruckType` to `String`
   - Fixed JSON key from `imageUrl` to `image`
   - Fixed `createdAt` and `updatedAt` types from `bool` to `String?`
   - Removed unused import

3. **lib/cofig/mapper.dart**
   - Added `_mapStringToTruckType()` helper method
   - Added date parsing for `createdAt` and `updatedAt`

4. **lib/feature/truck_listing/presentation/widgets/truck_card.dart**
   - Fixed image index bug to use first image instead of list index

## Testing
After these fixes, the Truck Listing Screen should:
1. Successfully fetch data from the backend
2. Display trucks in the list
3. Show truck images correctly
4. Handle pagination properly
5. Apply filters and search correctly

## Backend API Endpoint
- **GET** `/trucks`
- Query parameters: `page`, `limit`, `search`, `company`, `isAvailable`, `carrierType`
