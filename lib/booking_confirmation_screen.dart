import 'package:flutter/material.dart';
import 'package:new_3c/app/extensions/localizations.dart';
import 'package:provider/provider.dart';

import '../providers/queue_provider.dart';
import 'screens/home_screen.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final bool isJoinQueue;
  final DateTime? bookingDateTime;

  const BookingConfirmationScreen({
    Key? key,
    required this.isJoinQueue,
    this.bookingDateTime,
  }) : super(key: key);

  @override
  State<BookingConfirmationScreen> createState() =>
      _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final queueProvider = Provider.of<QueueProvider>(context);
    // final languageProvider = Provider.of<LanguageProvider>(context);

    final queueStatus = queueProvider.queueStatus;
    final booking = queueProvider.currentBooking;
    final selectedServices = widget.isJoinQueue
        ? (booking?.services ?? [])
        : queueProvider.selectedServices;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Opacity(
                opacity: 0.1,
                child: Image.network(
                  "https://images.pexels.com/photos/3992874/pexels-photo-3992874.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.1),
                    );
                  },
                ),
              ),
            ),

            // Content
            FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Success icon
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 64,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Heading
                        Text(
                          widget.isJoinQueue
                              ? context.translate('queue_joined')
                              : context.translate('booking_confirmed'),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),

                        // Subheading
                        widget.isJoinQueue
                            ? Text(
                                '${context.translate('queue_number')} ${queueStatus?.yourNumber}',
                                style: Theme.of(context).textTheme.titleMedium,
                                textAlign: TextAlign.center,
                              )
                            : Text(
                                context.translate('booking_successful'),
                                style: Theme.of(context).textTheme.titleMedium,
                                textAlign: TextAlign.center,
                              ),
                        const SizedBox(height: 32),

                        // Booking details card
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  context.translate('booking_details'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const Divider(),
                                const SizedBox(height: 8),

                                // Queue details or appointment details
                                if (widget.isJoinQueue) ...[
                                  _buildDetailRow(
                                    context,
                                    Icons.people,
                                    context.translate('people_ahead'),
                                    '${queueStatus?.peopleAhead}',
                                  ),
                                  const SizedBox(height: 12),
                                  _buildDetailRow(
                                    context,
                                    Icons.timer,
                                    context.translate('estimated_wait_time'),
                                    '${queueStatus?.estimatedWaitMinutes} ${context.translate('mins')}',
                                  ),
                                ] else ...[
                                  _buildDetailRow(
                                    context,
                                    Icons.calendar_today,
                                    context.translate('date'),
                                    _formatDate(widget.bookingDateTime!),
                                  ),
                                  const SizedBox(height: 12),
                                  _buildDetailRow(
                                    context,
                                    Icons.access_time,
                                    context.translate('time'),
                                    _formatTime(widget.bookingDateTime!),
                                  ),
                                  const SizedBox(height: 12),
                                  _buildDetailRow(
                                    context,
                                    Icons.timer,
                                    context.translate('estimated_duration'),
                                    '${_calculateTotalDuration(selectedServices)} ${context.translate('mins')}',
                                  ),
                                ],

                                const SizedBox(height: 16),
                                Text(
                                  context.translate('booking_services'),
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                const SizedBox(height: 8),

                                // Services list
                                ...selectedServices
                                    .map((service) => Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.check_circle,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(context.translate(
                                                    service.nameKey)),
                                              ),
                                              Text(
                                                  '\$${service.price.toStringAsFixed(2)}'),
                                            ],
                                          ),
                                        ))
                                    .toList(),

                                const Divider(),
                                const SizedBox(height: 8),

                                // Total price
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      context.translate('total_price'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                    Text(
                                      '\$${_calculateTotalPrice(selectedServices).toStringAsFixed(2)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Back to home button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeScreen()),
                                (route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(
                              context.translate('continue'),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final correctedHour = hour == 0 ? 12 : hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$correctedHour:$minute $period';
  }

  int _calculateTotalDuration(List<dynamic> services) {
    return services.fold<int>(
        0, (int sum, dynamic service) => sum + service.durationMinutes as int);
  }

  double _calculateTotalPrice(List<dynamic> services) {
    return services.fold<double>(0.0, (sum, service) => sum + service.price);
  }
}
