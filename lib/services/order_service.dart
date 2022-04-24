// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:abctechapp/provider/order_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';

import '../model/order.dart';
import '../model/order_created.dart';

abstract class OrderServiceInterface {
  Future<OrderCreated> createOrder(Order order);
}

class OrderService extends GetxService implements OrderServiceInterface {
  final OrderProviderInterface _orderProvider;

  OrderService(this._orderProvider);

  @override
  Future<OrderCreated> createOrder(Order order) async {
    Response response = await _orderProvider.postOrder(order);
    if (response.hasError) {
      return Future.error(ErrorDescription('Erro na API'));
    }
    try {
      return Future.sync(() => OrderCreated(success: true, message: ""));
    } catch (e) {
      e.printError();
      return Future.error(ErrorDescription("Erro"));
    }
  }
}
