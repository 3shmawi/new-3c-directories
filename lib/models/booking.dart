import 'dart:convert';

import 'package:uuid/uuid.dart';

import 'service.dart';

class Booking {
  final String id;
  final DateTime dateTime;
  final List<BarberService> services;
  final int queueNumber;
  final int estimatedDurationMinutes;

  Booking({
    String? id,
    required this.dateTime,
    required this.services,
    required this.queueNumber,
    required this.estimatedDurationMinutes,
  }) : id = id ?? const Uuid().v4();

  int get totalPrice {
    return services.fold(0, (sum, service) => sum + service.price.toInt());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dateTime': dateTime.toIso8601String(),
      'services': services.map((service) => service.toJson()).toList(),
      'queueNumber': queueNumber,
      'estimatedDurationMinutes': estimatedDurationMinutes,
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      dateTime: DateTime.parse(json['dateTime']),
      services: (json['services'] as List)
          .map((serviceJson) => BarberService.fromJson(serviceJson))
          .toList(),
      queueNumber: json['queueNumber'],
      estimatedDurationMinutes: json['estimatedDurationMinutes'],
    );
  }

  factory Booking.fromJsonString(String jsonString) {
    return Booking.fromJson(jsonDecode(jsonString));
  }
}

class QueueStatus {
  final int currentNumber;
  final int? yourNumber;
  final int peopleAhead;
  final int estimatedWaitMinutes;

  QueueStatus({
    required this.currentNumber,
    this.yourNumber,
    required this.peopleAhead,
    required this.estimatedWaitMinutes,
  });

  Map<String, dynamic> toJson() {
    return {
      'currentNumber': currentNumber,
      'yourNumber': yourNumber,
      'peopleAhead': peopleAhead,
      'estimatedWaitMinutes': estimatedWaitMinutes,
    };
  }

  factory QueueStatus.fromJson(Map<String, dynamic> json) {
    return QueueStatus(
      currentNumber: json['currentNumber'],
      yourNumber: json['yourNumber'],
      peopleAhead: json['peopleAhead'],
      estimatedWaitMinutes: json['estimatedWaitMinutes'],
    );
  }
}
