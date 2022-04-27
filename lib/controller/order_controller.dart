import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../model/assistance.dart';
import '../model/order.dart';
import '../model/order_created.dart';
import '../model/order_location.dart';
import '../services/geolocation_service.dart';
import '../services/order_service.dart';

enum OrderState { creating, started, finished }

class OrderController extends GetxController with StateMixin<OrderCreated> {
  final GeolocationServiceInterface _geolocationService;
  final selectedAssistances = <Assistance>[].obs;
  final formKey = GlobalKey<FormState>();
  final operatorIdController = TextEditingController();
  final OrderServiceInterface _orderService;
  final screenState = OrderState.creating.obs;
  late Order _order;

  OrderController(this._geolocationService, this._orderService);

  @override
  void onInit() {
    super.onInit;
    _geolocationService.start();
    change(null, status: RxStatus.success());
  }

  Future<Position> _getLocation() async {
    Position position = await _geolocationService.getPosition();
    return Future.sync(() => position);
  }

  OrderLocation orderLocationFromPosition(Position position) {
    return OrderLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        dateTime: DateTime.now());
  }

  List<int> getServicesIds() {
    return selectedAssistances.map((e) => e.id).toList();
  }

  finishStartOrder() {
    if (operatorIdController.text == "" ||
        int.parse(operatorIdController.text) == 0) {
      Get.snackbar("Atenção: ", "Insira o seu código de prestador", backgroundColor: Colors.orangeAccent[700], colorText: Colors.white);
    } else if (selectedAssistances.isEmpty) {
      Get.snackbar("Atenção: ", "Selecione os serviços prestados", backgroundColor: Colors.orangeAccent[700], colorText: Colors.white);
    } else {
      switch (screenState.value) {
        case OrderState.creating:
          change(null, status: RxStatus.loading());
          _getLocation().then((value) {
            _order = Order(
                operatorId: int.parse(operatorIdController.text),
                services: getServicesIds(),
                start: orderLocationFromPosition(value),
                end: null);
            screenState.value = OrderState.started;
            change(null, status: RxStatus.success());
          });

          break;
        case OrderState.started:
          change(null, status: RxStatus.loading());
          _getLocation().then((value) {
            _order.end = orderLocationFromPosition(value);
            _createOrder();
          });

          break;
        default:
      }
    }
  }

  _createOrder() {
    screenState.value = OrderState.finished;
    _orderService.createOrder(_order).then((value) {
      if (value.success) {
        Get.snackbar("Sucesso: ", "Ordem de serviço finalizada", backgroundColor: Colors.green[700], colorText: Colors.white);
      }
      clearForm();
    }).catchError((error) {
      Get.snackbar("Não foi possível concluir a ordem de serviço: ", error.toString(), backgroundColor: Colors.red[400], colorText: Colors.white);
      clearForm();
    });
  }

  editServices() {
    Get.toNamed("/services", arguments: selectedAssistances);
  }

  void clearForm() {
    screenState.value = OrderState.creating;
    operatorIdController.text = "";
    selectedAssistances.clear();
    change(null, status: RxStatus.success());
  }
}
