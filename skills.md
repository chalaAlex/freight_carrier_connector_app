I am building a Flutter freight-truck marketplace application.

The app fetches trucks from a REST API that supports server-side filtering using query parameters.

Example API endpoint:

GET /trucks

Example query parameters:
feature=Tracking System
brand=Volvo
isFeatured=true
capacity_gte=10
region=Oromia

Example request:
GET /trucks?brand=Volvo&isFeatured=true&capacity_gte=10&page=1&limit=10

Example API response:

{
  "statusCode": 200,
  "message": "Successfully retrieved trucks",
  "total": 120,
  "data": {
    "carriers": [...]
  }
}

I want to implement a scalable server-side filtering system in Flutter.

Requirements:

1. Update a TruckFilters model that stores filter states:
   - feature
   - brand
   - verification
   - loadCapacity

2. Implement a function that converts TruckFilters into query parameters.

Example output:

{
  "feature": "Tracking System",
  "brand": "Volvo",
  "verification": true,
  "loadCapacity": gte 30, // Review it 
}

3. Implement a TruckRepository method:

Future<Either<Failure, TruckBaseResponseEntity>> fetchTrucks(TruckFilters filters)

This method should:
- build query parameters
- call the API
- parse the response
- return a list of TruckBaseResponseEntity

Use Dio as the HTTP client.

4. Implement a state controller (ChangeNotifier, Riverpod, or BLoC) that:

- stores current filters
- calls the repository
- updates the truck list
- supports pagination
- supports resetting filters

5. When the user selects a filter:
   - update the filter state
   - send a new API request with all active filters

Example:

User selects brand = Volvo

API request:
GET /trucks?brand=Volvo

User then selects isFeatured = true

API request:
GET /trucks?brand=Volvo&isFeatured=true

6. Implement the following controller methods:

setFeature(String feature)
setBrand(String brand)
setLoadCapacity(int capacity)
resetFilters()
loadNextPage()

7. Ensure the system handles these edge cases:

- removing filters
- pagination with filters
- empty results
- loading states
- API errors

8. Use clean architecture principles:

Presentation
Controller / Provider
Usecase
Repository
Datasource

9. Provide clean, well-structured Dart code for:

- TruckFilters model
- Query parameter builder
- TruckRepository
- Controller / state management
- Example usage in UI

Focus on scalability because the system may support many filters in the future.