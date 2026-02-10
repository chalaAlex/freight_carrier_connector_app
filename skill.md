Perfect — here is the **refined version formatted for a `.md` instruction file** so it can be dropped directly into your project docs or prompt library.

---

# 📱 Flutter UI Implementation Specification (Senior-Level)

## 🧑‍💻 Role Definition

Act as a **Senior Flutter Engineer** with strong expertise in:

* Advanced UI composition in Flutter
* Scalable & maintainable architecture
* State management using **flutter_bloc**
* Performance-optimized list rendering
* Clean Architecture principles

---

## 📌 Project Context

A UI design screen has been provided. Your task is to convert this design into **production-quality Flutter code**.

All truck data must be treated as **remote API data**, not static or hardcoded UI data.

---

## 🎯 Primary Objective

Build the screen using:

* `flutter_bloc` for state management
* Clean architecture practices
* Reusable, class-based widgets
* Infinite scroll pagination
* Professional UX behaviors

This is **not** a UI mockup — it must resemble real production code.

---

# 🧱 Architecture & Engineering Rules (STRICT)

---

## 1️⃣ State Management

Use **flutter_bloc** and implement:

### Events

* Fetch initial trucks
* Refresh trucks
* Fetch next page

### States

* Initial
* Loading
* Success
* Error
* PaginationLoading
* PaginationError

Bloc logic must simulate asynchronous API behavior.

Handle:

* First load
* Pull-to-refresh
* Pagination
* Error retry

---

## 2️⃣ You must use a mock data defined in freight_mock.dart


## 2️⃣ Pagination (MANDATORY)

Simulate backend pagination:

| Scenario                 | Expected Behavior             |
| ------------------------ | ----------------------------- |
| Screen opens             | Fetch **Page 1** (10 trucks)  |
| User scrolls near bottom | Fetch next page               |
| Fetching more            | Show bottom loading indicator |
| No more data             | Stop requesting               |
| Failure                  | Show retry widget             |

Use:

* `ScrollController` **or**
* Infinite scroll listener pattern

---

## 3️⃣ Data Layer Simulation

Treat data as coming from a remote API.

```dart
Future<List<Truck>> fetchTrucks(int page);
```

Simulate:

* Network delay
* Optional random failure cases

---

## 4️⃣ UI Development Standards

You MUST use **AppTheme** for:

* Colors
* Text styles
* Spacing consistency

❌ No inline styles
❌ No hardcoded color values

---

## 5️⃣ String & Size Management

| Resource                   | Rule                          |
| -------------------------- | ----------------------------- |
| All text                   | Store in `StringManager.dart` |
| All sizes, padding, radius | Store in `SizeManager.dart`   |

No raw values like:

```dart
padding: EdgeInsets.all(16) ❌
```

---

## 6️⃣ Widget Structure

Break UI into **separate reusable widgets**, such as:

* `TruckCard`
* `TruckListView`
* `TruckImageSection`
* `TruckInfoSection`
* `PaginationLoader`
* `ErrorRetryWidget`
* `EmptyStateWidget`

Each widget must be:

* In its own class
* Refactor-friendly
* Copy-paste ready

---

## 7️⃣ UX Requirements (HIGH PRIORITY)

Implement real-world UX:

* Skeleton loader or shimmer on first load
* Smooth scrolling
* Center loading indicator (initial)
* Bottom loader (pagination)
* Pull-to-refresh
* Error UI with retry button
* Empty state screen
* Card touch feedback (InkWell/GestureDetector)

---

## 8️⃣ Performance Rules

* Use `ListView.builder`
* Use `const` constructors when possible
* Avoid rebuilding entire widget trees
* Use `BlocBuilder` and `BlocSelector` efficiently

---

## 9️⃣ Expected Output Order

Provide implementation in this sequence:

1. Truck Model
2. Mock API Service
3. Bloc (Events, States, Bloc class)
4. Main Screen
5. Reusable Widgets
6. StringManager
7. SizeManager
8. AppTheme additions

---

# 🚫 What NOT To Do

* No `setState`
* No giant monolithic widget files
* No hardcoded strings
* No static dummy lists
* No inline styling

---

## 🧠 Engineering Mindset

Write the code as if:

* It will ship to production
* A senior engineer will review it
* The feature must scale

---

**Goal:** Deliver architecture-quality Flutter code — not just UI drawing.
