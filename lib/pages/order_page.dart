import 'package:abctechapp/controller/order_controller.dart';
import 'package:abctechapp/model/assistance.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class OrderPage extends GetView<OrderController> {
  const OrderPage({Key? key}) : super(key: key);

  Widget renderAssists(List<Assistance> assists) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: assists.length,
        itemBuilder: (context, index) =>
            ListTile(title: Text(assists[index].name)));
  }

  Widget renderFromScreen(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: controller.formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(children: const [
              Expanded(
                  child: Text(
                'Preencha o formulário de ordem de serviço',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w200),
              ))
            ]),
            Obx(() {
              var enabled = controller.screenState.value == OrderState.creating;
              return TextFormField(
                controller: controller.operatorIdController,
                enabled: enabled,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: "Código do prestador"),
                textAlign: TextAlign.center,
              );
            }),
            Row(children: [
              const Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(top: 25, bottom: 25),
                      child: Text(
                        'Selecione os serviços a serem prestados',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w400),
                      ))),
              Ink(
                  decoration: const ShapeDecoration(
                      shape: CircleBorder(), color: Colors.blueGrey),
                  child: IconButton(
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      onPressed: () => controller.editServices()),
                  width: 40,
                  height: 40)
            ]),
            Obx(
              () => renderAssists(controller.selectedAssistances),
            ),
            Row(children: [
              Expanded(
                  child: ElevatedButton(onPressed: () {
                FocusScope.of(context).unfocus();
                controller.finishStartOrder();
              }, child: Obx(
                (() {
                  if (controller.screenState.value == OrderState.creating) {
                    return const Text("Iniciar serviço");
                  } else {
                    return const Text("Finalizar serviço");
                  }
                }),
              )))
            ]),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Ordem de serviço"),
        ),
        body: Container(
            constraints: const BoxConstraints.expand(),
            padding: const EdgeInsets.all(10.0),
            child: controller.obx((state) => renderFromScreen(context),
                onLoading: const Center(child: CircularProgressIndicator()),
                onError: (error) => Text(error.toString()))));
  }
}
