import 'package:flutter/material.dart';

import '../../models/booking.dart';
import '../../models/service.dart';
import '../../services/queue_service.dart';

class QueueProvider extends ChangeNotifier {
  final QueueService _queueService = QueueService();

  QueueStatus? _queueStatus;
  Booking? _currentBooking;
  List<Booking> _allBookings = [];
  List<BarberService> _availableServices = BarberService.getServices();
  List<BarberService> _selectedServices = [];

  QueueProvider() {
    _initialize();
    _queueService.addQueueUpdateListener(_handleQueueUpdate);
  }

  Future<void> _initialize() async {
    _queueStatus = await _queueService.getQueueStatus();
    _currentBooking = await _queueService.getCurrentBooking();
    _allBookings = await _queueService.getAllBookings();
    notifyListeners();
  }

  void _handleQueueUpdate() {
    _initialize();
  }

  // Getters
  QueueStatus? get queueStatus => _queueStatus;
  Booking? get currentBooking => _currentBooking;
  List<Booking> get allBookings => _allBookings;
  List<BarberService> get availableServices => _availableServices;
  List<BarberService> get selectedServices => _selectedServices;

  // Check if user is in queue
  bool get isInQueue => _queueStatus?.yourNumber != null;

  // Calculate total selected services duration
  int get totalSelectedDuration {
    return _selectedServices.fold(
        0, (sum, service) => sum + service.durationMinutes);
  }

  // Calculate total selected services price
  double get totalSelectedPrice {
    return _selectedServices.fold(0, (sum, service) => sum + service.price);
  }

  // Toggle service selection
  void toggleService(BarberService service) {
    final index = _availableServices.indexWhere((s) => s.id == service.id);
    if (index != -1) {
      final updatedService = _availableServices[index].copyWith(
        isSelected: !_availableServices[index].isSelected,
      );

      _availableServices[index] = updatedService;

      // Update selected services list
      _selectedServices =
          _availableServices.where((s) => s.isSelected).toList();

      notifyListeners();
    }
  }

  // Clear all selected services
  void clearSelectedServices() {
    for (int i = 0; i < _availableServices.length; i++) {
      _availableServices[i] = _availableServices[i].copyWith(isSelected: false);
    }
    _selectedServices = [];
    notifyListeners();
  }

  // Join queue with selected services
  Future<QueueStatus> joinQueue() async {
    if (_selectedServices.isEmpty) {
      throw Exception('No services selected');
    }

    final status = await _queueService.joinQueue(_selectedServices);
    await _initialize(); // Refresh data
    return status;
  }

  // Leave queue
  Future<void> leaveQueue() async {
    await _queueService.leaveQueue();
    await _initialize(); // Refresh data
  }

  // Book for later
  Future<Booking> bookForLater(DateTime appointmentTime) async {
    if (_selectedServices.isEmpty) {
      throw Exception('No services selected');
    }

    final booking =
        await _queueService.bookForLater(_selectedServices, appointmentTime);
    await _initialize(); // Refresh data
    return booking;
  }

  // Cancel booking
  Future<void> cancelBooking(String bookingId) async {
    await _queueService.cancelBooking(bookingId);
    await _initialize(); // Refresh data
  }

  @override
  void dispose() {
    _queueService.removeQueueUpdateListener(_handleQueueUpdate);
    super.dispose();
  }
}
