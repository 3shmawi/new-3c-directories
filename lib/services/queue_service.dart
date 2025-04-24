import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/booking.dart';
import '../../models/service.dart';

class QueueService {
  static const String _queueStatusKey = 'queue_status';
  static const String _bookingKey = 'current_booking';
  static const String _allBookingsKey = 'all_bookings';
  static const String _languageKey = 'language_code';

  static final QueueService _instance = QueueService._internal();
  factory QueueService() => _instance;
  QueueService._internal();

  final Random _random = Random();
  Timer? _queueTimer;

  // Queue progression simulation settings
  static const int _simulationIntervalSeconds =
      30; // Update queue every 30 seconds
  static const int _minServiceTimeMinutes = 10;
  static const int _maxServiceTimeMinutes = 25;

  // Store callbacks
  final List<VoidCallback> _queueUpdateListeners = [];

  void addQueueUpdateListener(VoidCallback listener) {
    _queueUpdateListeners.add(listener);
  }

  void removeQueueUpdateListener(VoidCallback listener) {
    _queueUpdateListeners.remove(listener);
  }

  void _notifyListeners() {
    for (var listener in _queueUpdateListeners) {
      listener();
    }
  }

  // Get or initialize queue status
  Future<QueueStatus> getQueueStatus() async {
    final prefs = await SharedPreferences.getInstance();
    String? queueStatusJson = prefs.getString(_queueStatusKey);

    if (queueStatusJson == null) {
      // Initialize with default values
      final defaultStatus = QueueStatus(
        currentNumber:
            _random.nextInt(5) + 1, // Start with 1-5 as current number
        yourNumber: null, // User not in queue initially
        peopleAhead: 0,
        estimatedWaitMinutes: 0,
      );

      await prefs.setString(
          _queueStatusKey, jsonEncode(defaultStatus.toJson()));
      return defaultStatus;
    } else {
      return QueueStatus.fromJson(jsonDecode(queueStatusJson));
    }
  }

  // Join the queue
  Future<QueueStatus> joinQueue(List<BarberService> selectedServices) async {
    final prefs = await SharedPreferences.getInstance();
    final currentStatus = await getQueueStatus();

    // Calculate estimated duration based on selected services
    int totalDuration = selectedServices.fold(
        0, (sum, service) => sum + service.durationMinutes);

    // Generate queue number (current + random number of people in line)
    int queueNumber = currentStatus.currentNumber + _random.nextInt(5) + 1;

    // Calculate people ahead and estimated wait time
    int peopleAhead = queueNumber - currentStatus.currentNumber;
    int estimatedWaitMinutes = peopleAhead * _getAverageServiceTime();

    // Create updated queue status
    final updatedStatus = QueueStatus(
      currentNumber: currentStatus.currentNumber,
      yourNumber: queueNumber,
      peopleAhead: peopleAhead,
      estimatedWaitMinutes: estimatedWaitMinutes,
    );

    // Create and save booking
    final newBooking = Booking(
      dateTime: DateTime.now(),
      services: selectedServices,
      queueNumber: queueNumber,
      estimatedDurationMinutes: totalDuration,
    );

    // Save updated queue status and booking
    await prefs.setString(_queueStatusKey, jsonEncode(updatedStatus.toJson()));
    await prefs.setString(_bookingKey, newBooking.toJsonString());

    // Add to all bookings list
    await _addToBookingsList(newBooking);

    // Start queue simulation
    _startQueueSimulation();

    return updatedStatus;
  }

  // Leave the queue
  Future<void> leaveQueue() async {
    final prefs = await SharedPreferences.getInstance();
    final currentStatus = await getQueueStatus();

    // Reset your number and related fields
    final updatedStatus = QueueStatus(
      currentNumber: currentStatus.currentNumber,
      yourNumber: null,
      peopleAhead: 0,
      estimatedWaitMinutes: 0,
    );

    await prefs.setString(_queueStatusKey, jsonEncode(updatedStatus.toJson()));
    await prefs.remove(_bookingKey);

    // Stop queue simulation if user leaves queue
    _stopQueueSimulation();

    _notifyListeners();
  }

  // Get current booking
  Future<Booking?> getCurrentBooking() async {
    final prefs = await SharedPreferences.getInstance();
    String? bookingJson = prefs.getString(_bookingKey);

    if (bookingJson == null) {
      return null;
    } else {
      return Booking.fromJsonString(bookingJson);
    }
  }

  // Save booking for later
  Future<Booking> bookForLater(
      List<BarberService> selectedServices, DateTime appointmentTime) async {
    // Calculate estimated duration based on selected services
    int totalDuration = selectedServices.fold(
        0, (sum, service) => sum + service.durationMinutes);

    // Get current queue status to assign a future queue number
    final currentStatus = await getQueueStatus();
    int queueNumber = currentStatus.currentNumber +
        10 +
        _random.nextInt(10); // Future queue number

    // Create booking
    final newBooking = Booking(
      dateTime: appointmentTime,
      services: selectedServices,
      queueNumber: queueNumber,
      estimatedDurationMinutes: totalDuration,
    );

    // Add to bookings list
    await _addToBookingsList(newBooking);

    return newBooking;
  }

  // Get all user bookings
  Future<List<Booking>> getAllBookings() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? bookingsJson = prefs.getStringList(_allBookingsKey);

    if (bookingsJson == null || bookingsJson.isEmpty) {
      return [];
    } else {
      return bookingsJson.map((json) => Booking.fromJsonString(json)).toList();
    }
  }

  // Add booking to list of all bookings
  Future<void> _addToBookingsList(Booking booking) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> bookingsJson = prefs.getStringList(_allBookingsKey) ?? [];

    bookingsJson.add(booking.toJsonString());
    await prefs.setStringList(_allBookingsKey, bookingsJson);
  }

  // Cancel a specific booking
  Future<void> cancelBooking(String bookingId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? bookingsJson = prefs.getStringList(_allBookingsKey);

    if (bookingsJson != null && bookingsJson.isNotEmpty) {
      // Filter out the booking to cancel
      List<String> updatedBookings = bookingsJson.where((json) {
        final booking = Booking.fromJsonString(json);
        return booking.id != bookingId;
      }).toList();

      await prefs.setStringList(_allBookingsKey, updatedBookings);

      // If we're canceling the current booking, also clear current booking
      final currentBooking = await getCurrentBooking();
      if (currentBooking != null && currentBooking.id == bookingId) {
        await leaveQueue();
      }
    }
  }

  // Start queue simulation (advancing queue periodically)
  void _startQueueSimulation() {
    // Stop existing timer if any
    _stopQueueSimulation();

    // Create new timer to advance queue
    _queueTimer = Timer.periodic(
      Duration(seconds: _simulationIntervalSeconds),
      (_) => _advanceQueue(),
    );
  }

  // Stop queue simulation
  void _stopQueueSimulation() {
    _queueTimer?.cancel();
    _queueTimer = null;
  }

  // Advance the queue (simulating people being served)
  Future<void> _advanceQueue() async {
    final prefs = await SharedPreferences.getInstance();
    final currentStatus = await getQueueStatus();
    final currentBooking = await getCurrentBooking();

    // Only advance if user is in queue
    if (currentStatus.yourNumber != null && currentBooking != null) {
      // Randomly decide whether to advance the queue
      if (_random.nextDouble() > 0.3) {
        // 70% chance to advance on each interval
        int newCurrentNumber = currentStatus.currentNumber + 1;
        int newPeopleAhead =
            max(0, currentStatus.yourNumber! - newCurrentNumber);
        int newEstimatedWait = newPeopleAhead * _getAverageServiceTime();

        final updatedStatus = QueueStatus(
          currentNumber: newCurrentNumber,
          yourNumber: currentStatus.yourNumber,
          peopleAhead: newPeopleAhead,
          estimatedWaitMinutes: newEstimatedWait,
        );

        await prefs.setString(
            _queueStatusKey, jsonEncode(updatedStatus.toJson()));

        // If it's the user's turn, clear queue status after some time
        if (newPeopleAhead == 0) {
          // Schedule automatic queue exit after service completion
          Future.delayed(Duration(minutes: 1), () {
            leaveQueue();
          });
        }

        _notifyListeners();
      }
    }
  }

  // Helper method to get average service time
  int _getAverageServiceTime() {
    return (_minServiceTimeMinutes + _maxServiceTimeMinutes) ~/ 2;
  }

  // Language settings
  Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? 'en'; // Default to English
  }

  Future<void> setLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }
}
