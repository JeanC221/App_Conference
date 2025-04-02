import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/event_tracks_controller.dart';

class EventTracksView extends GetView<EventTracksController> {
  const EventTracksView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Tracks'),
        centerTitle: true,
      ),
      body: Obx(
        () => controller.tracks.isEmpty
            ? const Center(child: Text('No tracks available'))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.tracks.length,
                itemBuilder: (context, index) {
                  final track = controller.tracks[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () => controller.navigateToTrackEvents(
                        track.id,
                        track.name,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              track.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              track.description,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  onPressed: () => controller.navigateToTrackEvents(
                                    track.id,
                                    track.name,
                                  ),
                                  icon: const Icon(Icons.arrow_forward),
                                  label: const Text('View Events'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

