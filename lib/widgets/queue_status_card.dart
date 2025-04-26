import 'package:flutter/material.dart';
import 'package:new_3c/app/extensions/localizations.dart';
import 'package:provider/provider.dart';

import '../../providers/queue_provider.dart';

class QueueStatusCard extends StatelessWidget {
  const QueueStatusCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final queueProvider = Provider.of<QueueProvider>(context);
    // final languageProvider = Provider.of<LanguageProvider>(context);
    final queueStatus = queueProvider.queueStatus;
    final isInQueue = queueProvider.isInQueue;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.translate('queue_status'),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (isInQueue)
                  ElevatedButton.icon(
                    onPressed: () async {
                      final confirmed =
                          await _showLeaveQueueConfirmation(context);
                      if (confirmed) {
                        queueProvider.leaveQueue();
                      }
                    },
                    icon: Icon(Icons.exit_to_app, color: Colors.white),
                    label: Text(
                      context.translate('leave_queue'),
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildInfoColumn(
                  context,
                  Icons.confirmation_number,
                  context.translate('current_number'),
                  queueStatus?.currentNumber.toString() ?? '-',
                  Theme.of(context).colorScheme.primary,
                ),
                if (isInQueue) ...[
                  _buildInfoColumn(
                    context,
                    Icons.person,
                    context.translate('your_number'),
                    queueStatus?.yourNumber?.toString() ?? '-',
                    Theme.of(context).colorScheme.tertiary,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            if (isInQueue) ...[
              Row(
                children: [
                  _buildInfoColumn(
                    context,
                    Icons.people,
                    context.translate('people_ahead'),
                    queueStatus?.peopleAhead.toString() ?? '0',
                    Theme.of(context).colorScheme.secondary,
                  ),
                  _buildInfoColumn(
                    context,
                    Icons.timer,
                    context.translate('estimated_wait'),
                    _formatWaitTime(
                        context, queueStatus?.estimatedWaitMinutes ?? 0),
                    Colors.orange,
                  ),
                ],
              ),
              if ((queueStatus?.peopleAhead ?? 0) <= 1) ...[
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: (queueStatus?.peopleAhead ?? 0) == 0
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        (queueStatus?.peopleAhead ?? 0) == 0
                            ? Icons.celebration
                            : Icons.access_time,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          (queueStatus?.peopleAhead ?? 0) == 0
                              ? context.translate('your_turn_now')
                              : context.translate('your_turn_soon'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
            if (!isInQueue) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '✨ ${context.translate('join_queue')}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.translate('select_services_prompt'),
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(BuildContext context, IconData icon, String label,
      String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }

  String _formatWaitTime(BuildContext context, int minutes) {
    if (minutes < 60) {
      return '$minutes ${context.translate('mins')}';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      return '$hours ${context.translate('hours')} $remainingMinutes ${context.translate('mins')}';
    }
  }

  Future<bool> _showLeaveQueueConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(context.translate('warning')),
            content: Text(context.translate('leave_queue') + '?'),
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
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ) ??
        false;
  }
}
