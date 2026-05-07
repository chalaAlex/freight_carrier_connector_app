# Freight_Carrier_Connector Application

A full-stack freight and logistics management platform built with Flutter, Node.js/Express. The system connects freight owners with carriers, handles bidding, payments, and shipment tracking through a clean architecture pattern.

## Description

This project implements a complete freight marketplace where freight owners can post cargo shipments and carriers can bid on them. The system includes real-time chat, payment processing with escrow, AI-powered suggestions, and comprehensive shipment tracking. Built with three separate applications: a Flutter mobile app for freight owners and carriers, an Express.js backend API.

The codebase demonstrates production-grade patterns including clean architecture, BLoC state management, dependency injection, and comprehensive error handling. The backend uses MongoDB for data persistence, Socket.IO for real-time features, and integrates with external services like Supabase for file storage and Google's Generative AI for intelligent suggestions.

## Screenshots.
<p align="center">
  <img src="screenshot_1.png" alt="Image 1" width="30%" />
  <img src="Screenshot_2.png" alt="Image 1" width="30%" />
</p>

<p align="center">
  <img src="Screenshot_3.png" alt="Image 1" width="30%" />
  <img src="Screenshot_4.png" alt="Image 1" width="30%" />
</p>

## Architecture & Techniques

### Flutter Mobile App

**Clean Architecture Pattern**
- Strict separation of concerns across data, domain, and presentation layers
- Each feature module follows the same structure: `data/`, `domain/`, `presentation/`
- See [`lib/feature/`](clean_architecture/lib/feature/) for feature modules

**State Management**
- [BLoC pattern](https://bloclibrary.dev/) with [flutter_bloc](https://pub.dev/packages/flutter_bloc) for predictable state management
- Event-driven architecture with immutable states using [Equatable](https://pub.dev/packages/equatable)
- Centralized state handling in [`lib/feature/*/presentation/bloc/`](clean_architecture/lib/feature/)

**Functional Programming**
- [Either monad](https://pub.dev/packages/dartz) from dartz for elegant error handling
- Type-safe failure handling without exceptions
- See [`lib/core/error/failure.dart`](clean_architecture/lib/core/error/failure.dart)

**Dependency Injection**
- [GetIt](https://pub.dev/packages/get_it) service locator pattern
- Configured in [`lib/core/di.dart`](clean_architecture/lib/core/di.dart)

**Network Layer**
- Type-safe REST API client using [Retrofit](https://pub.dev/packages/retrofit) with [Dio](https://pub.dev/packages/dio)
- Automatic JSON serialization with [json_serializable](https://pub.dev/packages/json_serializable)
- JWT authentication with token refresh interceptors
- See [`lib/core/network/api_client.dart`](clean_architecture/lib/core/network/api_client.dart)

**Real-time Communication**
- WebSocket integration with [socket_io_client](https://pub.dev/packages/socket_io_client)
- Real-time chat and notifications
- See [`lib/feature/chat/`](clean_architecture/lib/feature/chat/)

**File Storage**
- [Supabase](https://supabase.com/) integration for image uploads
- Configured in [`lib/core/storage/`](clean_architecture/lib/core/storage/)

**Input Validation**
- Custom validators for Ethiopian phone numbers, plate numbers, and business rules
- Input formatters for controlled text entry
- See [`lib/core/utils/validators.dart`](clean_architecture/lib/core/utils/validators.dart)

**Theme System**
- Dynamic theme switching with Cubit
- Custom color schemes for light/dark modes
- [Google Fonts](https://pub.dev/packages/google_fonts) integration
- See [`lib/core/theme/`](clean_architecture/lib/core/theme/)

**Environment Configuration**
- Multi-environment support (dev/prod)
- Separate entry points: [`lib/main_dev.dart`](clean_architecture/lib/main_dev.dart) and [`lib/main_prod.dart`](clean_architecture/lib/main_prod.dart)


## Technologies

### Flutter Dependencies
- **flutter_bloc** (^9.1.1) - State management with BLoC pattern
- **dio** (^5.9.1) - HTTP client for REST APIs
- **retrofit** (^4.9.2) - Type-safe REST client generator
- **get_it** (^9.2.0) - Service locator for dependency injection
- **dartz** (^0.10.1) - Functional programming utilities
- **equatable** (^2.0.8) - Value equality without boilerplate
- **supabase_flutter** (^2.12.0) - Supabase client for file storage
- **socket_io_client** (^3.0.0) - WebSocket client
- **google_fonts** (^8.0.0) - Font library
- **flutter_secure_storage** (^10.0.0) - Encrypted local storage
- **image_picker** (^1.0.7) - Image selection from gallery/camera
- **fluttertoast** (^9.0.0) - Toast notifications
- **intl** (^0.20.2) - Internationalization and date formatting


## Project Structure

```
.
├── clean_architecture/          # Flutter mobile application
│   ├── lib/
│   │   ├── cofig/              # Configuration and base classes
│   │   ├── core/               # Core utilities and shared code
│   │   │   ├── assets/         # Asset path constants
│   │   │   ├── colors/         # Color schemes
│   │   │   ├── error/          # Error handling
│   │   │   ├── network/        # API client and networking
│   │   │   ├── request/        # Request DTOs
│   │   │   ├── storage/        # File storage (Supabase)
│   │   │   ├── theme/          # Theme configuration
│   │   │   ├── token/          # Authentication tokens
│   │   │   ├── utils/          # Validators and utilities
│   │   │   └── widgets/        # Reusable widgets
│   │   ├── feature/            # Feature modules
│   │   │   ├── carrier_owner_module/
│   │   │   ├── freight_oner_module/
│   │   │   ├── chat/
│   │   │   ├── notifications/
│   │   │   └── payment/
│   │   ├── main_dev.dart       # Development entry point
│   │   └── main_prod.dart      # Production entry point
│   ├── assets/
│   │   └── images/             # Image assets
│   ├── test/                   # Unit and widget tests
│   └── pubspec.yaml            # Flutter dependencies
│
