import 'dart:async';
import 'package:flutter/foundation.dart';

/// A utility class that delays the execution of a function until after
/// a specified duration has elapsed since the last time it was invoked.
/// 
/// This is particularly useful for search inputs where you want to wait
/// for the user to stop typing before triggering an expensive operation.
/// 
/// Example usage:
/// ```dart
/// final debouncer = Debouncer(delay: Duration(milliseconds: 500));
/// 
/// TextField(
///   onChanged: (value) {
///     debouncer.run(() {
///       // This will only execute 500ms after the user stops typing
///       performSearch(value);
///     });
///   },
/// )
/// ```
class Debouncer {
  /// The duration to wait before executing the action
  final Duration delay;
  
  /// Internal timer that tracks the delay
  Timer? _timer;

  /// Creates a debouncer with the specified delay
  /// 
  /// Default delay is 500 milliseconds
  Debouncer({this.delay = const Duration(milliseconds: 500)});

  /// Runs the given action after the specified delay
  /// 
  /// If this method is called again before the delay expires,
  /// the previous timer is cancelled and a new one is started.
  /// This ensures that the action only executes after the user
  /// has stopped invoking this method for the full delay duration.
  void run(VoidCallback action) {
    // Cancel any existing timer
    _timer?.cancel();
    
    // Start a new timer
    _timer = Timer(delay, action);
  }

  /// Cancels any pending action and cleans up resources
  /// 
  /// This should be called when the debouncer is no longer needed,
  /// typically in a widget's dispose method.
  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
