import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../model/assistance.dart';
import '../services/geolocation_service.dart';

class OrderController extends GetxController {
  final GeolocationServiceInterface _geolocationService;
  final selectedAssistances = <Assistance>[].obs;
  final formKey = GlobalKey<FormState>();
  final operatorIdController = TextEditingController();

  OrderController(this._geolocationService);

  @override
  void onInit() {
    super.onInit;
    _geolocationService.start();
  }

  getLocation() {
    _geolocationService
        .getPosition()
        .then((value) => log(value.toJson().toString()));
  }

  finishStartOrder() {
    getLocation();
  }

  editServices() {
    Get.toNamed("/services", arguments: selectedAssistances);
  }
}
