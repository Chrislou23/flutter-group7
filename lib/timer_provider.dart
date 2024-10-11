import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class TimerProvider with ChangeNotifier, WidgetsBindingObserver {
  Timer? _usageTimer;
  Timer? _blockTimer;
  bool _isBlocked = false;
  static const int _usageDurationMinutes = 5;
  static const int _blockDurationMinutes = 2;
  Duration _remainingUsageTime = Duration(minutes: _usageDurationMinutes);
  Duration _remainingBlockTime = Duration(minutes: _blockDurationMinutes);

  TimerProvider() {
    WidgetsBinding.instance.addObserver(this);
    _loadState();
    _startUsageTimer();
  }

  bool get isBlocked => _isBlocked;
  Duration get remainingUsageTime => _remainingUsageTime;
  Duration get remainingBlockTime => _remainingBlockTime;

  void _startUsageTimer() {
    _usageTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_remainingUsageTime.inSeconds == 0) {
        _isBlocked = true;
        timer.cancel();
        _saveState();
        _navigateToHomePage();
        _showBlockDialog(); // Déplacer après la navigation pour s'assurer que le contexte est bon
        _startBlockTimer();
      } else {
        _remainingUsageTime -= const Duration(seconds: 1);
        notifyListeners();
        _saveState();
      }
    });
  }

  void _startBlockTimer() {
    _blockTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (_remainingBlockTime.inSeconds == 0) {
        _isBlocked = false;
        timer.cancel();
        _resetUsageTimer();
        _saveState();
      } else {
        _remainingBlockTime -= const Duration(seconds: 1);
        notifyListeners();
        _saveState();
      }
    });
  }

  void _resetUsageTimer() {
    _remainingUsageTime = Duration(minutes: _usageDurationMinutes);
    _remainingBlockTime = Duration(minutes: _blockDurationMinutes);
    _startUsageTimer();
    notifyListeners();
    _saveState();
  }

  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isBlocked', _isBlocked);
    prefs.setInt('remainingUsageTime', _remainingUsageTime.inSeconds);
    prefs.setInt('remainingBlockTime', _remainingBlockTime.inSeconds);
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    _isBlocked = prefs.getBool('isBlocked') ?? false;
    _remainingUsageTime =
        Duration(seconds: prefs.getInt('remainingUsageTime') ?? _usageDurationMinutes * 60);
    _remainingBlockTime =
        Duration(seconds: prefs.getInt('remainingBlockTime') ?? _blockDurationMinutes * 60);
    notifyListeners();
  }

  void _showBlockDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (navigatorKey.currentContext != null) {
        showDialog(
          context: navigatorKey.currentContext!,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('REST YOUR EYES'),
              content: const Text(
                  'You have reached the maximum usage time. Please take a break.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }

  void _navigateToHomePage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigatorKey.currentState?.pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _usageTimer?.cancel(); // Stop the timer if app is in the background
    } else if (state == AppLifecycleState.resumed) {
      if (!_isBlocked) {
        _startUsageTimer(); // Restart the timer if app becomes active again and is not blocked
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _usageTimer?.cancel();
    _blockTimer?.cancel();
    super.dispose();
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();