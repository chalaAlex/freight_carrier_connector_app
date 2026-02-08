# Implementation Plan: Truck Listing Screen

## Overview

This implementation plan breaks down the truck listing screen feature into discrete, incremental coding tasks following Clean Architecture. Each task builds on previous work, with testing integrated throughout to validate functionality early. The implementation follows the layer order: domain → data → presentation, ensuring dependencies flow correctly.

## Tasks

- [x] 1. Set up domain layer foundation
  - Create directory structure: `lib/feature/freight/truck_listing/domain/`
  - Define Truck entity with all properties (id, model, company, pricePerDay, pricePerHour, capacityTons, type, location, radiusKm, imageUrl, isAvailable)
  - Define TruckType enum (flatbed, refrigerated, dryVan)
  - Extend Equatable for value equality
  - Define TruckRepository interface with fetchTrucks(int page) method returning Future<Either<Failure, List<Truck>>>
  - _Requirements: 1.1, 1.7_

- [ ]* 1.1 Write property test for Truck entity equality
  - **Property: Truck equality**
  - **Validates: Requirements 1.1**
  - Generate random Truck instances and verify Equatable behavior

- [x] 2. Implement domain use case
  - Create GetTrucksUseCase extending BaseUseCase<List<Truck>, int>
  - Inject TruckRepository dependency
  - Implement call method that delegates to repository.fetchTrucks
  - _Requirements: 2.1, 2.2_

- [ ]* 2.1 Write property test for use case delegation
  - **Property 3: UseCase Repository Delegation**
  - **Validates: Requirements 2.2, 2.3, 2.4**
  - Generate random page numbers and mock repository responses
  - Verify use case returns repository result unchanged

- [x] 3. Implement data layer models and serialization
  - Create directory structure: `lib/feature/freight/truck_listing/data/models/`
  - Define TruckModel extending Truck entity
  - Implement fromJson factory constructor with proper type conversions
  - Implement toJson method
  - Handle TruckType enum serialization (use .name and .byName)
  - _Requirements: 1.2_

- [ ]* 3.1 Write property test for JSON serialization round-trip
  - **Property 1: JSON Serialization Round-Trip**
  - **Validates: Requirements 1.2**
  - Generate random TruckModel instances
  - Serialize to JSON then deserialize back
  - Assert equality of original and round-tripped model


- [x] 4. Implement mock API service
  - Create directory structure: `lib/feature/freight/truck_listing/data/datasources/`
  - Implement MockTruckApiService class
  - Add constructor parameter for simulateFailures (default false)
  - Implement fetchTrucks(int page) method:
    - Simulate random network delay (500-1500ms)
    - Optionally simulate random failures (20% probability)
    - Calculate pagination (10 trucks per page, max 50 total)
    - Generate diverse mock truck data using helper method
  - Implement _generateMockTruck helper with varied data (models, companies, types, locations)
  - _Requirements: 1.3, 1.4, 1.5_

- [ ]* 4.1 Write property test for pagination consistency
  - **Property 2: Mock API Pagination Consistency**
  - **Validates: Requirements 1.4**
  - Generate random valid page numbers (1-5)
  - Verify exactly 10 trucks returned for pages 1-4
  - Verify 10 or fewer trucks for page 5
  - Verify empty list for pages beyond range

- [x] 5. Implement repository implementation
  - Create directory structure: `lib/feature/freight/truck_listing/data/repositories/`
  - Implement TruckRepositoryImpl implementing TruckRepository
  - Inject MockTruckApiService dependency
  - Implement fetchTrucks method:
    - Call apiService.fetchTrucks
    - Wrap in try-catch
    - Return Right(trucks) on success
    - Return Left(NetworkFailure) on NetworkException
    - Return Left(UnexpectedFailure) on other exceptions
  - _Requirements: 1.6_

- [ ]* 5.1 Write unit tests for repository error handling
  - Test successful fetch returns Right with trucks
  - Test NetworkException returns Left with NetworkFailure
  - Test unexpected exception returns Left with UnexpectedFailure
  - _Requirements: 1.6_

- [x] 6. Checkpoint - Ensure data and domain layers work together
  - Run all tests to verify data flow from mock API through repository to use case
  - Ensure all tests pass, ask the user if questions arise

- [x] 7. Implement bloc events and states
  - Create directory structure: `lib/feature/freight/truck_listing/presentation/bloc/`
  - Define TruckEvent abstract class extending Equatable
  - Define concrete events: FetchInitialTrucks, RefreshTrucks, FetchNextPage
  - Define TruckState abstract class extending Equatable
  - Define concrete states:
    - TruckInitial
    - TruckLoading
    - TruckSuccess (with trucks list, currentPage, hasMorePages)
    - TruckError (with message)
    - TruckPaginationLoading (with currentTrucks)
    - TruckPaginationError (with currentTrucks and message)
  - Implement copyWith method for TruckSuccess
  - _Requirements: 3.1, 3.2_

- [x] 8. Implement TruckBloc logic
  - Create TruckBloc extending Bloc<TruckEvent, TruckState>
  - Inject GetTrucksUseCase dependency
  - Define trucksPerPage constant (10)
  - Register event handlers in constructor
  - Implement _onFetchInitialTrucks:
    - Emit TruckLoading
    - Call use case with page 1
    - Emit TruckSuccess or TruckError based on result
    - Set hasMorePages based on result length
  - Implement _onRefreshTrucks:
    - Emit TruckLoading
    - Call use case with page 1
    - Emit TruckSuccess or TruckError based on result
  - Implement _onFetchNextPage:
    - Check if current state is TruckSuccess and hasMorePages is true
    - Return early if not
    - Emit TruckPaginationLoading with current trucks
    - Call use case with nextPage
    - Emit TruckSuccess with appended trucks or TruckPaginationError
  - _Requirements: 3.3, 3.4, 3.5, 3.6, 3.7, 3.8_


- [ ]* 8.1 Write property test for bloc state transitions
  - **Property 4: Bloc State Transition Correctness**
  - **Validates: Requirements 3.3, 3.7**
  - Generate random use case results (success/failure)
  - Dispatch FetchInitialTrucks event
  - Verify correct state sequence: TruckLoading → TruckSuccess/TruckError

- [ ]* 8.2 Write property test for bloc refresh behavior
  - **Property 5: Bloc Refresh Resets State**
  - **Validates: Requirements 3.4**
  - Generate random TruckSuccess states with various pages
  - Dispatch RefreshTrucks event
  - Verify page resets to 1 and list is fresh

- [ ]* 8.3 Write property test for bloc pagination append
  - **Property 6: Bloc Pagination Appends Trucks**
  - **Validates: Requirements 3.5**
  - Generate TruckSuccess states with hasMorePages=true
  - Dispatch FetchNextPage event
  - Verify trucks are appended and page increments

- [ ]* 8.4 Write property test for bloc pagination boundary
  - **Property 7: Bloc Pagination Respects Boundaries**
  - **Validates: Requirements 3.6**
  - Generate TruckSuccess states with hasMorePages=false
  - Dispatch FetchNextPage event
  - Verify state unchanged and no API calls made

- [x] 9. Add required strings to StringManager
  - Add truck listing screen strings:
    - truckListingTitle = "FreightConnect"
    - searchHint = "Search trucks..."
    - filterAll = "All Trucks"
    - filterAvailable = "Available"
    - filterRefrigerated = "Refrigerated"
    - postFreight = "Post Freight"
    - available = "Available"
    - busy = "Busy"
    - pricePerDay = "per day"
    - pricePerHour = "per hour"
    - capacity = "Capacity"
    - tons = "tons"
    - requestTruck = "Request Truck"
    - notifyWhenFree = "Notify When Free"
    - viewDetails = "View Details"
    - noTrucksAvailable = "No trucks available"
    - checkBackLater = "Check back later or post your freight"
    - networkError = "Unable to connect. Please check your connection and try again."
    - unexpectedError = "Something went wrong. Please try again."
    - genericError = "An error occurred. Please try again."
    - retry = "Retry"
  - _Requirements: 4.11, 13.1, 13.5_

- [x] 10. Add required sizes to SizeManager
  - Add truck listing specific sizes:
    - cardElevation = 2.0
    - cardRadius = 12.0
    - imageHeight = 180.0
    - badgePadding = 8.0
    - badgeRadius = 16.0
    - iconSize = 20.0
    - buttonHeight = 40.0
    - paginationLoaderHeight = 60.0
  - _Requirements: 4.10, 13.2, 13.6_

- [x] 11. Implement TruckImageSection widget
  - Create directory structure: `lib/feature/freight/truck_listing/presentation/widgets/`
  - Create TruckImageSection as StatelessWidget
  - Accept imageUrl and isAvailable parameters
  - Use Stack to overlay badge on image
  - Use ClipRRect with SizeManager.cardRadius for rounded corners
  - Display truck image with placeholder for loading/error
  - Position availability badge (top-right corner)
  - Badge shows "Available" (green) or "Busy" (red) using AppTheme colors
  - Use SizeManager for all dimensions
  - Use StringManager for badge text
  - _Requirements: 4.3, 6.1_


- [x] 12. Implement TruckInfoSection widget
  - Create TruckInfoSection as StatelessWidget
  - Accept Truck parameter
  - Display truck model name using AppTheme headline style
  - Display company name using AppTheme subtitle style
  - Display pricing row: "ETB {pricePerDay} per day • ETB {pricePerHour} per hour"
  - Display specs row with icons:
    - Capacity: "{capacityTons} tons"
    - Type: "{type}" (Flatbed/Refrigerated/Dry Van)
    - Location: "{location} • {radiusKm}km radius"
  - Display action buttons based on isAvailable:
    - If available: "Request Truck" (primary) + "View Details" (secondary)
    - If busy: "Notify When Free" (secondary) + "View Details" (secondary)
  - Use SizeManager for all spacing and dimensions
  - Use StringManager for all text
  - Use AppTheme for all colors and text styles
  - _Requirements: 4.4, 6.2, 6.3, 6.4, 6.5, 6.6, 6.7, 6.8, 6.9_

- [x] 13. Implement TruckCard widget
  - Create TruckCard as StatelessWidget
  - Accept Truck parameter and optional onTap callback
  - Wrap in Card widget with elevation from SizeManager
  - Wrap in InkWell for tap feedback
  - Use Column to stack TruckImageSection and TruckInfoSection
  - Apply SizeManager padding
  - Use const constructor where possible
  - _Requirements: 4.1, 6.10_

- [ ]* 13.1 Write widget test for TruckCard
  - Test card displays truck information correctly
  - Test "Available" badge shown when isAvailable=true
  - Test "Busy" badge shown when isAvailable=false
  - Test "Request Truck" button shown when available
  - Test "Notify When Free" button shown when busy
  - _Requirements: 6.1, 6.8_

- [x] 14. Implement ShimmerLoader widget
  - Create ShimmerLoader as StatelessWidget
  - Display 3-5 skeleton cards mimicking TruckCard layout
  - Use shimmer animation (consider shimmer package or custom gradient animation)
  - Use SizeManager for dimensions matching TruckCard
  - _Requirements: 4.8, 7.1, 7.4_

- [x] 15. Implement PaginationLoader widget
  - Create PaginationLoader as StatelessWidget
  - Display CircularProgressIndicator centered
  - Apply SizeManager.paginationLoaderHeight for container height
  - Add padding for visual separation
  - _Requirements: 4.5, 9.2_

- [x] 16. Implement ErrorRetryWidget
  - Create ErrorRetryWidget as StatelessWidget
  - Accept message and onRetry callback parameters
  - Display error icon from AppTheme
  - Display error message using AppTheme text style
  - Display retry button with StringManager.retry text
  - Center content vertically and horizontally
  - Use SizeManager for spacing
  - _Requirements: 4.6, 10.1, 10.4_

- [x] 17. Implement EmptyStateWidget
  - Create EmptyStateWidget as StatelessWidget
  - Display empty state icon/illustration
  - Display StringManager.noTrucksAvailable message
  - Display StringManager.checkBackLater suggestion
  - Center content vertically and horizontally
  - Use AppTheme for styling
  - Use SizeManager for spacing
  - _Requirements: 4.7, 11.1, 11.2, 11.3, 11.4_


- [x] 18. Implement TruckListView widget
  - Create TruckListView as StatelessWidget
  - Accept trucks list, ScrollController, and onEndReached callback
  - Use ListView.builder for efficient rendering
  - Render TruckCard for each truck
  - Append PaginationLoader when loading more pages (check bloc state)
  - Use const constructors where possible
  - _Requirements: 4.2, 12.1, 12.2_

- [ ]* 18.1 Write property test for scroll position pagination trigger
  - **Property 8: Scroll Position Triggers Pagination**
  - **Validates: Requirements 9.1**
  - Generate random scroll positions
  - Test pagination trigger logic (within 200px of bottom)
  - Verify correct true/false based on threshold

- [x] 19. Implement TruckListingScreen main screen
  - Create directory structure: `lib/feature/freight/truck_listing/presentation/screens/`
  - Create TruckListingScreen as StatefulWidget
  - Initialize ScrollController in initState
  - Add scroll listener to detect when user scrolls within 200px of bottom
  - Dispatch FetchNextPage event when threshold reached
  - Dispose ScrollController in dispose method
  - Implement build method with:
    - AppBar with StringManager.truckListingTitle
    - Search bar below app bar
    - Filter chips row (All Trucks, Available, Refrigerated)
    - BlocBuilder<TruckBloc, TruckState> for main content
    - RefreshIndicator wrapping content for pull-to-refresh
    - FloatingActionButton with StringManager.postFreight
  - Handle state rendering:
    - TruckInitial/TruckLoading: Show ShimmerLoader
    - TruckSuccess: Show TruckListView with trucks
    - TruckError: Show ErrorRetryWidget
    - TruckPaginationLoading: Show TruckListView with PaginationLoader
    - TruckPaginationError: Show TruckListView with error at bottom
  - Handle empty state: Show EmptyStateWidget when TruckSuccess with empty list
  - Implement onRefresh callback to dispatch RefreshTrucks event
  - Use BlocProvider to provide TruckBloc
  - Dispatch FetchInitialTrucks in initState
  - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.5, 7.1, 7.2, 7.3, 8.1, 8.2, 8.3, 8.4, 8.5, 9.1, 9.2, 9.3, 9.4, 9.5, 9.6, 10.1, 10.2, 10.3, 11.1, 12.3, 12.4_

- [x] 20. Set up dependency injection
  - Register MockTruckApiService in GetIt (di.dart)
  - Register TruckRepositoryImpl in GetIt
  - Register GetTrucksUseCase in GetIt
  - Register TruckBloc factory in GetIt
  - Ensure proper dependency chain
  - _Requirements: 14.1-14.12_

- [x] 21. Integrate TruckListingScreen into navigation
  - Add route for TruckListingScreen in routes_manager.dart
  - Update freight home page or navigation to include truck listing screen
  - Test navigation flow
  - _Requirements: 14.1-14.12_

- [x] 22. Final checkpoint - End-to-end testing
  - Run the app and test complete user flow:
    - Initial load with shimmer
    - Successful data display
    - Pull-to-refresh functionality
    - Infinite scroll pagination
    - Error scenarios (enable simulateFailures)
    - Empty state (modify mock to return empty list)
  - Verify all styling uses StringManager, SizeManager, and AppTheme
  - Ensure all tests pass
  - Ask the user if questions arise

## Notes

- Tasks marked with `*` are optional and can be skipped for faster MVP
- Each task references specific requirements for traceability
- Checkpoints ensure incremental validation at key milestones
- Property tests validate universal correctness properties
- Unit tests validate specific examples and edge cases
- Follow Clean Architecture strictly: domain → data → presentation
- All styling must use centralized resource managers (no hardcoded values)
