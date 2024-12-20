import 'dart:convert';

import 'package:coding_interview_frontend/app/data/models/currency_type.dart';
import 'package:coding_interview_frontend/app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {

  final TextEditingController amountController = TextEditingController(text: '0');
  final RxBool isLoading = false.obs;

  final fiatIds = ["BRL", "COP", "PEN", "VES"];
  final cryptoIds = ["TATUM-TRON-USDT"];

  final currencyTitles = {
    "BRL": "BRL",
    "COP": "COP",
    "PEN": "PEN",
    "VES": "VES",
    "TATUM-TRON-USDT": "USDT",
  };
  final currencySubtitles = {
    "BRL": "Real Brasileño (R\$)",
    "COP": "Pesos Colombianos (COL\$)",
    "PEN": "Soles Peruanos (S/)",
    "VES": "Bolívares (Bs)",
    "TATUM-TRON-USDT": "Tether (USDT)",
  };
  final currencyImages = {
    "BRL": "assets/fiat_currencies/BRL.png",
    "COP": "assets/fiat_currencies/COP.png",
    "PEN": "assets/fiat_currencies/PEN.png",
    "VES": "assets/fiat_currencies/VES.png",
    "TATUM-TRON-USDT": "assets/cripto_currencies/TATUM-TRON-USDT.png",
  };

  RxString type = '0'.obs;
  RxString cryptoCurrencyId = 'TATUM-TRON-USDT'.obs;
  RxString fiatCurrencyId = 'VES'.obs;
  RxDouble tasaEstimada = 0.0.obs;
  RxDouble montoTotal = 0.0.obs;

  Future<void> cargarConversion() async {
    isLoading.value = true;

    try {
      final response = await ApiService.getConversion(
        queryParams: {
          'type': type.value,
          'cryptoCurrencyId': cryptoCurrencyId.value,
          'fiatCurrencyId': fiatCurrencyId.value,
          'amount': amountController.text.trim(),
          "amountCurrencyId": type.value == "0" ? cryptoCurrencyId.value : fiatCurrencyId.value,
        },
      );

      final datosJson = jsonDecode(response.body);
      if(datosJson['data']?['byPrice']?['fiatToCryptoExchangeRate'] != null){
        tasaEstimada.value = double.parse(datosJson['data']['byPrice']['fiatToCryptoExchangeRate']);
      } else {
        tasaEstimada.value = 0;
      }

      actualizarMontoARecibir();

    } catch(e){
      print(e);
    }

    isLoading.value = false;
  }

  void actualizarMontoARecibir(){
    double amountDouble = double.parse(amountController.text.trim());

    if(type.value == "0"){
      montoTotal.value = amountDouble * tasaEstimada.value;
    } else {
      montoTotal.value = amountDouble / tasaEstimada.value;
    }

    if(tasaEstimada.value == 0) montoTotal.value = 0;
  }


  void showDialogCurrencyList(CurrencyType currencyType){

    List<String> currencyIds;

    if(currencyType == CurrencyType.CRYPTO){
      currencyIds = cryptoIds;
    } else {
      currencyIds = fiatIds;
    }

    showModalBottomSheet(
      context: Get.context!,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0),),
      ),
      isScrollControlled: true,
      builder: (BuildContext context){
        return Obx(() => Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          padding: const EdgeInsets.only(bottom: 16, top: 16,),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              Center(
                child: Container(
                  width: 50,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Text(currencyType == CurrencyType.CRYPTO ? "Cripto" : "FIAT",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              for(int i = 0; i < currencyIds.length; i++)
                InkWell(
                  onTap: () {
                    if(currencyType == CurrencyType.CRYPTO){
                      cryptoCurrencyId.value = currencyIds[i];
                    } else {
                      fiatCurrencyId.value = currencyIds[i];
                    }

                    cargarConversion();
                  },
                  child: ListTile(
                    leading: Image.asset(currencyImages[currencyIds[i]] ?? "",
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                    ),
                    title: Text(currencyTitles[currencyIds[i]] ?? "",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(currencySubtitles[currencyIds[i]] ?? ""),
                    trailing: Radio<String>(
                      value: currencyIds[i],
                      groupValue: currencyType == CurrencyType.CRYPTO ? cryptoCurrencyId.value : fiatCurrencyId.value,
                      onChanged: (value) {
                        if(value != null){
                          if(currencyType == CurrencyType.CRYPTO){
                            cryptoCurrencyId.value = value;
                          } else {
                            fiatCurrencyId.value = value;
                          }

                          cargarConversion();
                        }
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),);
      },
    );
  }
}
