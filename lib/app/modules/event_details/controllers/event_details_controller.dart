import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/event_model.dart';
import '../../../data/models/track_model.dart';
import '../../../data/models/feedback_model.dart';
import '../../../data/providers/local_data_provider.dart';

class EventDetailsController extends GetxController {
  final LocalDataProvider _localDataProvider = LocalDataProvider();
  
  final RxList<Event> events = <Event>[].obs;
  final Rx<Track?> track = Rx<Track?>(null);
  final RxBool isLoading = true.obs;
  
  final RxString selectedEventId = ''.obs;
  final Rx<Event?> selectedEvent = Rx<Event?>(null);
  final RxBool isSubscribed = false.obs;
  
  final TextEditingController feedbackController = TextEditingController();
  final RxDouble rating = 0.0.obs;
  
  @override
  void onInit() {
    super.onInit();
    
    if (Get.arguments != null) {
      if (Get.arguments['trackId'] != null) {
        loadEventsByTrack(Get.arguments['trackId']);
      }
      
      if (Get.arguments['eventId'] != null) {
        selectedEventId.value = Get.arguments['eventId'];
        loadEventDetails();
      }
    }
  }
  
  @override
  void onClose() {
    feedbackController.dispose();
    super.onClose();
  }
  
  void loadEventsByTrack(String trackId) {
    isLoading.value = true;
    
    final tracks = _localDataProvider.getTracks();
    track.value = tracks.firstWhere(
      (t) => t.id == trackId,
      orElse: () => Track(
        id: '',
        name: 'Unknown Track',
        description: '',
      ),
    );
    
    events.value = _localDataProvider.getEventsByTrack(trackId);
    
    isLoading.value = false;
  }
  
  void loadEventDetails() {
    if (selectedEventId.value.isEmpty) return;
    
    final allEvents = _localDataProvider.getEvents();
    selectedEvent.value = allEvents.cast<Event?>().firstWhere(
      (e) => e?.id == selectedEventId.value,
      orElse: () => null,
    );
    
    if (selectedEvent.value != null) {
      isSubscribed.value = _localDataProvider.isSubscribedToEvent(selectedEvent.value!.id);
    }
  }
  
  void selectEvent(Event event) {
    selectedEventId.value = event.id;
    selectedEvent.value = event;
    isSubscribed.value = _localDataProvider.isSubscribedToEvent(event.id);
  }
  
  Future<void> toggleSubscription() async {
    if (selectedEvent.value == null) return;
    
    final eventId = selectedEvent.value!.id;
    bool success;
    
    if (isSubscribed.value) {
      success = await _localDataProvider.unsubscribeFromEvent(eventId);
      if (success) {
        isSubscribed.value = false;
        Get.snackbar(
          'Success',
          'Unsubscribed from event',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      success = await _localDataProvider.subscribeToEvent(eventId);
      if (success) {
        isSubscribed.value = true;
        Get.snackbar(
          'Success',
          'Subscribed to event',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }
  
  Future<void> submitFeedback() async {
    if (selectedEvent.value == null) return;
    if (rating.value == 0) {
      Get.snackbar(
        'Error',
        'Please provide a rating',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    final feedback = EventFeedback(
      eventId: selectedEvent.value!.id,
      feedback: feedbackController.text.trim(),
      rating: rating.value,
      submittedAt: DateTime.now(),
    );
    
    final success = await _localDataProvider.saveFeedback(feedback);
    
    if (success) {
      feedbackController.clear();
      rating.value = 0;
      Get.snackbar(
        'Success',
        'Feedback submitted',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

