import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/subscribed_events_controller.dart';
import '../../../data/models/event_model.dart';

class SubscribedEventsView extends GetView<SubscribedEventsController> {
  const SubscribedEventsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Subscribed Events'),
        centerTitle: true,
      ),
      body: Obx(
        () => controller.subscribedEvents.isEmpty
            ? _buildEmptyState()
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.subscribedEvents.length,
                itemBuilder: (context, index) {
                  final event = controller.subscribedEvents[index];
                  return _buildEventCard(context, event);
                },
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.event_busy,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            'No subscribed events',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Browse event tracks to subscribe to events',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Get.toNamed('/event-tracks'),
            icon: const Icon(Icons.search),
            label: const Text('Browse Events'),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, Event event) {
    final bool isPast = event.isPast;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: isPast ? Colors.grey.shade100 : Colors.white,
      child: InkWell(
        onTap: () => controller.navigateToEventDetails(event),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      event.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isPast ? Colors.grey.shade700 : Colors.black,
                      ),
                    ),
                  ),
                  if (isPast)
                    const Chip(
                      label: Text('Past'),
                      backgroundColor: Colors.grey,
                      labelStyle: TextStyle(color: Colors.white),
                    )
                  else
                    const Chip(
                      label: Text('Upcoming'),
                      backgroundColor: Colors.teal,
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    event.location,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    '${event.dateTime.day}/${event.dateTime.month}/${event.dateTime.year} at ${event.dateTime.hour}:${event.dateTime.minute.toString().padLeft(2, '0')}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (isPast && event.averageRating != null)
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          '${event.averageRating!.toStringAsFixed(1)}/5.0',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    )
                  else
                    Text(
                      '${event.availableSpots} spots left',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  TextButton.icon(
                    onPressed: () => controller.unsubscribeFromEvent(event.id),
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    label: const Text(
                      'Unsubscribe',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

