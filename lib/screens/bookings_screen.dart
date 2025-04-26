import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/extensions/localizations.dart';
import '../../models/booking.dart';
import '../../providers/queue_provider.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({Key? key}) : super(key: key);

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  @override
  Widget build(BuildContext context) {
    final queueProvider = Provider.of<QueueProvider>(context);
    final bookings = queueProvider.allBookings;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.translate('your_bookings')),
        elevation: 0,
      ),
      body: bookings.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                return _buildBookingCard(context, bookings[index]);
              },
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            "https://images.pexels.com/photos/7319307/pexels-photo-7319307.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
            height: 200,
            width: 200,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.calendar_today,
                size: 100,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            context.translate('no_bookings'),
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              context.translate('book_appointment'),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.add, color: Colors.white),
            label: Text(
              context.translate('book_appointment'),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, Booking booking) {
    final queueProvider = Provider.of<QueueProvider>(context, listen: false);
    final isUpcoming = booking.dateTime.isAfter(DateTime.now());

    // Sort services alphabetically by name key
    final services = [...booking.services];

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          // Header with date/time
          Container(
            decoration: BoxDecoration(
              color: isUpcoming
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey[600],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  isUpcoming ? Icons.event_available : Icons.event_busy,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatDate(booking.dateTime),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _formatTime(booking.dateTime),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isUpcoming
                        ? Theme.of(context).colorScheme.tertiary
                        : Colors.grey[400],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    isUpcoming
                        ? context.translate('queue_number') +
                            ' ${booking.queueNumber}'
                        : context.translate('completed'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Booking details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Services
                Text(
                  context.translate('services'),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),

                ...services
                    .map((service) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check,
                                  size: 12,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(context.translate(service.nameKey)),
                              ),
                              Text('\$${service.price.toStringAsFixed(2)}'),
                            ],
                          ),
                        ))
                    .toList(),

                const Divider(),

                // Duration and price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.timer,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${booking.estimatedDurationMinutes} ${context.translate('minutes')}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    Text(
                      context.translate('total_price') +
                          ': \$${booking.totalPrice.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),

                if (isUpcoming) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      onPressed: () => _showCancelDialog(context, booking.id),
                      icon: Icon(
                        Icons.cancel,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      label: Text(
                        context.translate('cancel_booking'),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        side: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .error
                              .withOpacity(0.5),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
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

  Future<void> _showCancelDialog(BuildContext context, String bookingId) async {
    final queueProvider = Provider.of<QueueProvider>(context, listen: false);

    final shouldCancel = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.translate('cancel_booking')),
        content: Text(context.translate('cancel') + '?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.translate('cancel')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(
              context.translate('confirm'),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );

    if (shouldCancel ?? false) {
      await queueProvider.cancelBooking(bookingId);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.translate('booking_cancelled')),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }
}
