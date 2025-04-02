import 'package:get/get.dart';
import '../../../data/models/event_model.dart';
import '../../../data/providers/local_data_provider.dart';

class SubscribedEventsController extends GetxController {
  final LocalDataProvider _localDataProvider = LocalDataProvider();
  
  final RxList<Event> subscribedEvents = <Event>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    loadSubscribedEvents();
  }
  
  void loadSubscribedEvents() {
    subscribedEvents.value = _localDataProvider.getSubscribedEvents();
  }
  
  void navigateToEventDetails(Event event) {
    Get.toNamed('/event-details', arguments: {
      'eventId': event.id,
      'trackId': event.trackId,
    });
  }
  
  Future<void> unsubscribeFromEvent(String eventId) async {
    await _localDataProvider.unsubscribeFromEvent(eventId);
    loadSubscribedEvents();
    Get.snackbar(
      'Success',
      'Unsubscribed from event',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

