import 'package:abctechapp/controller/assistance_controller.dart';
import 'package:get/get.dart';

class ServicesBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AssistanceController>(() => AssistanceController());
  }
}
