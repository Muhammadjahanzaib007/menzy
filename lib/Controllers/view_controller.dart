import 'package:get/state_manager.dart';

class ViewController extends GetxController {
  // Rx<User> user = User().obs;
  RxBool unityview = true.obs;
  @override
  Future<void> onInit() async {
    super.onInit();
  }
  Future changeview(bool value) async {
    unityview.value = value;
    update();
  }





}
