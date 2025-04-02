import 'package:get/get.dart';
import '../../../data/providers/local_data_provider.dart';

class HomeController extends GetxController {
  final LocalDataProvider _localDataProvider = LocalDataProvider();
  
  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _localDataProvider.initializeIfEmpty();
  }

  void navigateToEventTracks() {
    Get.toNamed('/event-tracks');
  }

  void navigateToSubscribedEvents() {
    Get.toNamed('/subscribed-events');
  }
}

