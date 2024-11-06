import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

// Global navigator key to access the navigator outside of the widget tree
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class TimerProvider with ChangeNotifier, WidgetsBindingObserver {
  // Timers for usage and block durations
  Timer? _usageTimer;
  Timer? _blockTimer;

  // Flags to indicate if the user is blocked
  bool _isBlocked = false;

  // Constants for usage and block durations
  static const int _usageDurationMinutes = 20;
  static const int _blockDurationMinutes = 1;

  // Remaining time durations
  Duration _remainingUsageTime = Duration(minutes: _usageDurationMinutes);
  Duration _remainingBlockTime = Duration(minutes: _blockDurationMinutes);

  TimerProvider() {
    // Add this object as an observer of app lifecycle events
    WidgetsBinding.instance.addObserver(this);
    _loadState();        // Load saved state from SharedPreferences
    _startUsageTimer();  // Start the usage timer
  }

  // Getters for external access
  bool get isBlocked => _isBlocked;
  Duration get remainingUsageTime => _remainingUsageTime;
  Duration get remainingBlockTime => _remainingBlockTime;

  // Starts the usage timer which counts down the allowed usage time
  void _startUsageTimer() {
    _usageTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_remainingUsageTime.inSeconds == 0) {
        _isBlocked = true;
        timer.cancel();
        _saveState();
        _navigateToHomePage();
        _showBlockDialog(); // Show the block dialog after navigation
        _startBlockTimer(); // Start the block timer
      } else {
        _remainingUsageTime -= const Duration(seconds: 1);
        notifyListeners(); // Notify listeners to update UI
        _saveState();      // Save the current state
      }
    });
  }

  // Starts the block timer which counts down the block duration
  void _startBlockTimer() {
    _blockTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_remainingBlockTime.inSeconds == 0) {
        _isBlocked = false;
        timer.cancel();
        _resetUsageTimer(); // Reset the usage timer after block period
        _saveState();
      } else {
        _remainingBlockTime -= const Duration(seconds: 1);
        notifyListeners();
        _saveState();
      }
    });
  }

  // Resets the usage timer to the initial duration
  void _resetUsageTimer() {
    _remainingUsageTime = Duration(minutes: _usageDurationMinutes);
    _remainingBlockTime = Duration(minutes: _blockDurationMinutes);
    _startUsageTimer();
    notifyListeners();
    _saveState();
  }

  // Saves the current state to SharedPreferences for persistence
  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isBlocked', _isBlocked);
    prefs.setInt('remainingUsageTime', _remainingUsageTime.inSeconds);
    prefs.setInt('remainingBlockTime', _remainingBlockTime.inSeconds);
  }

  // Loads the saved state from SharedPreferences
  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    _isBlocked = prefs.getBool('isBlocked') ?? false;
    _remainingUsageTime = Duration(
      seconds: prefs.getInt('remainingUsageTime') ?? _usageDurationMinutes * 60,
    );
    _remainingBlockTime = Duration(
      seconds: prefs.getInt('remainingBlockTime') ?? _blockDurationMinutes * 60,
    );
    notifyListeners();
  }

  // Displays a dialog informing the user that they are blocked
  void _showBlockDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (navigatorKey.currentContext != null) {
        showDialog(
          context: navigatorKey.currentContext!,
          barrierDismissible: false, // Prevent dismissal by tapping outside
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('REST YOUR EYES'),
              content: const Text(
                'You have reached the maximum usage time. Please take a break.',
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }

  // Navigates back to the home page
  void _navigateToHomePage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/',
        (Route<dynamic> route) => false,
      );
    });
  }

  // Handles app lifecycle changes (e.g., app paused or resumed)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _usageTimer?.cancel(); // Stop the timer when app is in background
    } else if (state == AppLifecycleState.resumed) {
      if (!_isBlocked) {
        _startUsageTimer(); // Restart the timer if app becomes active and not blocked
      }
    }
  }

  // Clean up timers and remove observers when the provider is disposed
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _usageTimer?.cancel();
    _blockTimer?.cancel();
    super.dispose();
  }
}
