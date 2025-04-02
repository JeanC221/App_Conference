import 'package:get/get.dart';
import '../../../data/models/track_model.dart';
import '../../../data/providers/local_data_provider.dart';

class EventTracksController extends GetxController {
  final LocalDataProvider _localDataProvider = LocalDataProvider();
  
  final RxList<Track> tracks = <Track>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    loadTracks();
  }
  
  void loadTracks() {
    tracks.value = _localDataProvider.getTracks();
  }
  
  void navigateToTrackEvents(String trackId, String trackName) {
    Get.toNamed('/event-details', arguments: {'trackId': trackId, 'trackName': trackName});
  }
}

