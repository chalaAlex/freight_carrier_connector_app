# Requirements Document: Truck Listing Screen

## Introduction

The Truck Listing Screen is a core feature of the FreightConnect Flutter application that enables users to browse, search, and interact with available trucks for freight transportation. This feature implements a production-quality, paginated list view following Clean Architecture principles with flutter_bloc state management. The screen provides real-time truck availability information, filtering capabilities, and seamless user interactions including pull-to-refresh, infinite scroll pagination, and comprehensive error handling.

## Glossary

- **Truck_Listing_System**: The complete feature module responsible for displaying and managing truck listings
- **Mock_API_Service**: A simulated remote data source that mimics network behavior with delays and optional failures
- **Truck_Entity**: The domain model representing a truck with its properties (model, company, capacity, type, location, pricing, availability)
- **Truck_Repository**: The abstraction layer defining truck data operations
- **Truck_Bloc**: The business logic component managing truck listing state using flutter_bloc
- **Pagination**: The mechanism for loading trucks in batches (10 per page) to optimize performance
- **Pull_To_Refresh**: User gesture to reload the truck list from the beginning
- **Infinite_Scroll**: Automatic loading of next page when user scrolls near the bottom
- **Shimmer_Loader**: Skeleton loading animation displayed during initial data fetch
- **StringManager**: Centralized string resource management class
- **SizeManager**: Centralized size and spacing constants class
- **AppTheme**: Centralized theme and styling configuration
- **Clean_Architecture**: Architectural pattern with separation into data, domain, and presentation layers

## Requirements

### Requirement 1: Data Layer Implementation

**User Story:** As a developer, I want a well-structured data layer following Clean Architecture, so that truck data is properly modeled and can be fetched from remote sources with proper error handling.

#### Acceptance Criteria

1. THE Truck_Listing_System SHALL define a Truck entity in the domain layer with properties: id, model, company, pricePerDay, pricePerHour, capacityTons, type (Flatbed/Refrigerated/Dry Van), location, radiusKm, imageUrl, and isAvailable
2. THE Truck_Listing_System SHALL define a Truck model in the data layer that extends the Truck entity and includes JSON serialization methods (fromJson, toJson)
3. WHEN the Mock_API_Service is called, THE Truck_Listing_System SHALL simulate network delay between 500ms and 1500ms
4. WHEN the Mock_API_Service is called with a page number, THE Truck_Listing_System SHALL return exactly 10 trucks for that page
5. WHERE random failure simulation is enabled, THE Mock_API_Service SHALL randomly fail with 20% probability and return a network error
6. THE Truck_Listing_System SHALL implement a TruckRepositoryImpl in the data layer that delegates to the Mock_API_Service
7. THE Truck_Listing_System SHALL define a TruckRepository interface in the domain layer with methods: fetchTrucks(page) returning Either<Failure, List<Truck>>

### Requirement 2: Domain Layer Use Cases

**User Story:** As a developer, I want clear use case definitions in the domain layer, so that business logic is separated from presentation and data concerns.

#### Acceptance Criteria

1. THE Truck_Listing_System SHALL implement a GetTrucksUseCase that accepts a page parameter
2. WHEN GetTrucksUseCase is executed, THE Truck_Listing_System SHALL call the TruckRepository.fetchTrucks method with the provided page number
3. WHEN the repository returns success, THE GetTrucksUseCase SHALL return Right(List<Truck>)
4. WHEN the repository returns failure, THE GetTrucksUseCase SHALL return Left(Failure) with appropriate error information

### Requirement 3: State Management with flutter_bloc

**User Story:** As a developer, I want robust state management using flutter_bloc, so that the UI can react to data changes, loading states, and errors appropriately.

#### Acceptance Criteria

1. THE Truck_Bloc SHALL define events: FetchInitialTrucks, RefreshTrucks, and FetchNextPage
2. THE Truck_Bloc SHALL define states: TruckInitial, TruckLoading, TruckSuccess, TruckError, TruckPaginationLoading, and TruckPaginationError
3. WHEN FetchInitialTrucks event is dispatched, THE Truck_Bloc SHALL emit TruckLoading state followed by either TruckSuccess or TruckError
4. WHEN RefreshTrucks event is dispatched, THE Truck_Bloc SHALL reset the page to 1, clear existing trucks, and fetch fresh data
5. WHEN FetchNextPage event is dispatched AND more pages exist, THE Truck_Bloc SHALL emit TruckPaginationLoading, fetch the next page, and append results to existing trucks
6. WHEN FetchNextPage event is dispatched AND no more pages exist, THE Truck_Bloc SHALL not make any API calls
7. WHEN any fetch operation fails, THE Truck_Bloc SHALL emit appropriate error state with error message
8. THE Truck_Bloc SHALL track the current page number and whether more pages are available

### Requirement 4: UI Component Architecture

**User Story:** As a developer, I want reusable, well-structured UI components, so that the code is maintainable and follows Flutter best practices.

#### Acceptance Criteria

1. THE Truck_Listing_System SHALL implement TruckCard as a separate StatelessWidget that displays a single truck's information
2. THE Truck_Listing_System SHALL implement TruckListView as a separate StatelessWidget that manages the scrollable list using ListView.builder
3. THE Truck_Listing_System SHALL implement TruckImageSection as a separate StatelessWidget that displays truck image with availability badge overlay
4. THE Truck_Listing_System SHALL implement TruckInfoSection as a separate StatelessWidget that displays truck details (name, company, specs, location)
5. THE Truck_Listing_System SHALL implement PaginationLoader as a separate StatelessWidget that shows a loading indicator at the bottom of the list
6. THE Truck_Listing_System SHALL implement ErrorRetryWidget as a separate StatelessWidget that displays error message with a retry button
7. THE Truck_Listing_System SHALL implement EmptyStateWidget as a separate StatelessWidget that displays when no trucks are available
8. THE Truck_Listing_System SHALL implement ShimmerLoader as a separate StatelessWidget that displays skeleton loading cards during initial load
9. WHEN any widget needs styling, THE Truck_Listing_System SHALL use only AppTheme for colors and text styles
10. WHEN any widget needs dimensions, THE Truck_Listing_System SHALL use only SizeManager for padding, spacing, and radius values
11. WHEN any widget needs text content, THE Truck_Listing_System SHALL use only StringManager for all displayed strings

### Requirement 5: Screen Layout and Header

**User Story:** As a user, I want a clear, branded header with search and filter capabilities, so that I can easily navigate and filter truck listings.

#### Acceptance Criteria

1. THE Truck_Listing_System SHALL display "FreightConnect" branding in the app bar
2. THE Truck_Listing_System SHALL display a search bar below the app bar
3. THE Truck_Listing_System SHALL display filter chips with options: "All Trucks", "Available", and "Refrigerated"
4. WHEN a filter chip is tapped, THE Truck_Listing_System SHALL provide visual feedback (selection state)
5. THE Truck_Listing_System SHALL display a floating action button with "Post Freight" functionality

### Requirement 6: Truck Card Display

**User Story:** As a user, I want to see comprehensive truck information in an organized card layout, so that I can quickly evaluate truck options.

#### Acceptance Criteria

1. WHEN displaying a truck card, THE Truck_Listing_System SHALL show an availability badge (Available/Busy) overlaid on the truck image
2. WHEN displaying a truck card, THE Truck_Listing_System SHALL show the truck model name prominently
3. WHEN displaying a truck card, THE Truck_Listing_System SHALL show the company name
4. WHEN displaying a truck card, THE Truck_Listing_System SHALL show pricing information (price per day and price per hour)
5. WHEN displaying a truck card, THE Truck_Listing_System SHALL show capacity in tons
6. WHEN displaying a truck card, THE Truck_Listing_System SHALL show truck type (Flatbed/Refrigerated/Dry Van)
7. WHEN displaying a truck card, THE Truck_Listing_System SHALL show location with radius (e.g., "Addis Ababa • 50km radius")
8. WHEN displaying a truck card, THE Truck_Listing_System SHALL show action buttons based on availability: "Request Truck" (if available) or "Notify When Free" (if busy)
9. WHEN displaying a truck card, THE Truck_Listing_System SHALL show a "View Details" button
10. WHEN a user taps anywhere on the truck card, THE Truck_Listing_System SHALL provide visual feedback using InkWell

### Requirement 7: Initial Loading Experience

**User Story:** As a user, I want a smooth loading experience when first opening the truck listing screen, so that I understand the app is working and data is being fetched.

#### Acceptance Criteria

1. WHEN the screen is first loaded, THE Truck_Listing_System SHALL display shimmer skeleton loaders for truck cards
2. WHEN the initial data fetch completes successfully, THE Truck_Listing_System SHALL replace shimmer loaders with actual truck cards
3. WHEN the initial data fetch fails, THE Truck_Listing_System SHALL display an error message with a retry button
4. THE Truck_Listing_System SHALL display at least 3 shimmer skeleton cards during loading

### Requirement 8: Pull-to-Refresh Functionality

**User Story:** As a user, I want to pull down on the list to refresh truck data, so that I can see the most up-to-date truck availability.

#### Acceptance Criteria

1. WHEN a user pulls down on the truck list, THE Truck_Listing_System SHALL display a refresh indicator
2. WHEN pull-to-refresh is triggered, THE Truck_Bloc SHALL dispatch RefreshTrucks event
3. WHEN refresh completes successfully, THE Truck_Listing_System SHALL display the updated truck list from page 1
4. WHEN refresh fails, THE Truck_Listing_System SHALL display an error message and retain the existing truck list
5. WHEN refresh is in progress, THE Truck_Listing_System SHALL prevent multiple simultaneous refresh operations

### Requirement 9: Infinite Scroll Pagination

**User Story:** As a user, I want the list to automatically load more trucks as I scroll down, so that I can browse through all available trucks without manual pagination controls.

#### Acceptance Criteria

1. WHEN a user scrolls to within 200 pixels of the bottom, THE Truck_Listing_System SHALL trigger FetchNextPage event
2. WHEN pagination is loading, THE Truck_Listing_System SHALL display a PaginationLoader at the bottom of the list
3. WHEN pagination completes successfully, THE Truck_Listing_System SHALL append new trucks to the existing list
4. WHEN pagination fails, THE Truck_Listing_System SHALL display an error message at the bottom with a retry option
5. WHEN all pages have been loaded, THE Truck_Listing_System SHALL not trigger additional pagination requests
6. THE Truck_Listing_System SHALL use a ScrollController to detect scroll position for pagination triggering

### Requirement 10: Error Handling and Retry

**User Story:** As a user, I want clear error messages and the ability to retry failed operations, so that I can recover from network issues without restarting the app.

#### Acceptance Criteria

1. WHEN initial loading fails, THE Truck_Listing_System SHALL display an ErrorRetryWidget with error message and retry button
2. WHEN pagination loading fails, THE Truck_Listing_System SHALL display an error message at the bottom of the list with retry button
3. WHEN refresh fails, THE Truck_Listing_System SHALL display a toast or snackbar with error message
4. WHEN a user taps a retry button, THE Truck_Listing_System SHALL re-attempt the failed operation
5. THE Truck_Listing_System SHALL display user-friendly error messages (not technical stack traces)

### Requirement 11: Empty State Handling

**User Story:** As a user, I want to see a helpful message when no trucks are available, so that I understand the situation and know what to do next.

#### Acceptance Criteria

1. WHEN the truck list is empty after successful fetch, THE Truck_Listing_System SHALL display an EmptyStateWidget
2. THE EmptyStateWidget SHALL display an appropriate icon or illustration
3. THE EmptyStateWidget SHALL display a message indicating no trucks are available
4. THE EmptyStateWidget SHALL display a suggestion or call-to-action (e.g., "Check back later" or "Post your freight")

### Requirement 12: Performance Optimization

**User Story:** As a developer, I want the truck listing screen to be performant and efficient, so that users experience smooth scrolling and minimal memory usage.

#### Acceptance Criteria

1. THE Truck_Listing_System SHALL use ListView.builder for efficient rendering of truck cards
2. WHEN defining widgets, THE Truck_Listing_System SHALL use const constructors wherever possible
3. THE Truck_Listing_System SHALL use BlocBuilder or BlocSelector to minimize unnecessary widget rebuilds
4. THE Truck_Listing_System SHALL dispose of ScrollController and other resources properly in dispose method
5. THE Truck_Listing_System SHALL not load all trucks at once, but SHALL use pagination to load 10 trucks per page

### Requirement 13: Styling Consistency

**User Story:** As a developer, I want all styling to follow project conventions, so that the codebase is maintainable and consistent.

#### Acceptance Criteria

1. THE Truck_Listing_System SHALL NOT use any hardcoded string values in UI components
2. THE Truck_Listing_System SHALL NOT use any hardcoded size, padding, or radius values in UI components
3. THE Truck_Listing_System SHALL NOT use any hardcoded color values in UI components
4. THE Truck_Listing_System SHALL NOT define inline text styles in UI components
5. WHEN new strings are needed, THE Truck_Listing_System SHALL add them to StringManager
6. WHEN new sizes are needed, THE Truck_Listing_System SHALL add them to SizeManager
7. WHEN new colors or text styles are needed, THE Truck_Listing_System SHALL use or extend AppTheme

### Requirement 14: Clean Architecture Compliance

**User Story:** As a developer, I want the feature to strictly follow Clean Architecture principles, so that the code is testable, maintainable, and follows project standards.

#### Acceptance Criteria

1. THE Truck_Listing_System SHALL organize code into three layers: data, domain, and presentation
2. THE Truck_Listing_System SHALL place entities in domain/entities directory
3. THE Truck_Listing_System SHALL place repository interfaces in domain/repositories directory
4. THE Truck_Listing_System SHALL place use cases in domain/usecases directory
5. THE Truck_Listing_System SHALL place models in data/models directory
6. THE Truck_Listing_System SHALL place data sources in data/datasources directory
7. THE Truck_Listing_System SHALL place repository implementations in data/repositories directory
8. THE Truck_Listing_System SHALL place bloc files in presentation/bloc directory
9. THE Truck_Listing_System SHALL place screen files in presentation/screens directory
10. THE Truck_Listing_System SHALL place widget files in presentation/widgets directory
11. WHEN domain layer needs data, THE Truck_Listing_System SHALL depend only on repository interfaces, not implementations
12. WHEN presentation layer needs business logic, THE Truck_Listing_System SHALL depend only on use cases and bloc, not repositories or data sources directly
