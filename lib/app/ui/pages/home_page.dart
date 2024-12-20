import 'package:coding_interview_frontend/app/controllers/home_controller.dart';
import 'package:coding_interview_frontend/app/data/models/currency_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomeController> {

  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: CustomPaint(painter: CircularDividerPainter(), child: Center(
        child: Obx(() => Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 10,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildExchangeCard(),

              const SizedBox(height: 20),

              TextField(
                controller: controller.amountController,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 8),
                    child: Text(controller.currencyTitles[controller.type.value == "0" ? controller.cryptoCurrencyId.value : controller.fiatCurrencyId.value] ?? "",
                      style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.w600,),
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 0,
                    minHeight: 0,
                  ),
                  focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.amber,), borderRadius: BorderRadius.circular(15),),
                  enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.amber,), borderRadius: BorderRadius.circular(15),),
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16,),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value){
                  if(controller.tasaEstimada.value == 0){
                    controller.cargarConversion();
                  } else {
                    controller.actualizarMontoARecibir();
                  }
                },
              ),

              const SizedBox(height: 20),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(label: 'Tasa estimada',
                      value: '≈ ${controller.tasaEstimada.value.toStringAsFixed(2)} ${controller.fiatCurrencyId.value}'),
                  _buildInfoRow(label: 'Recibirás',
                      value: '≈ ${controller.montoTotal.value.toStringAsFixed(2)} ${controller.currencyTitles[controller.type.value == "0" ? controller.fiatCurrencyId.value : controller.cryptoCurrencyId.value]}'),
                  _buildInfoRow(label: 'Tiempo estimado', value: '≈ 10 Min'), // TODO : falta saber donde obtener ese valor de la API
                ],
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC107),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
                  ),
                  onPressed: () {},
                  child: const Text('Cambiar',),
                ),
              ),
            ],
          ),
        ), ),
      ), ),
    );
  }

  Widget _buildInfoRow({required String label, required String value}){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }


  Widget _buildFiatSelected(){
    return GestureDetector(
      onTap: (){
        controller.showDialogCurrencyList(CurrencyType.FIAT);
      },
      child: Row(
        children: [
          Image.asset(controller.currencyImages[controller.fiatCurrencyId.value] ?? "", height: 24, width: 24,),
          const SizedBox(width: 8),
          Text(controller.currencyTitles[controller.fiatCurrencyId.value] ?? "",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),
          ),
          const SizedBox(width: 8),
          const Icon(CupertinoIcons.chevron_down, size: 20,),
        ],
      ),
    );
  }

  Widget _buildCryptoSelected(){
    return GestureDetector(
      onTap: (){
        controller.showDialogCurrencyList(CurrencyType.CRYPTO);
      },
      child: Row(
        children: [
          Image.asset(controller.currencyImages[controller.cryptoCurrencyId.value] ?? "", height: 24, width: 24,),
          const SizedBox(width: 8),
          Text(controller.currencyTitles[controller.cryptoCurrencyId.value] ?? "",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),
          ),
          const SizedBox(width: 8),
          const Icon(CupertinoIcons.chevron_down, size: 20,),
        ],
      ),
    );
  }

  Widget _buildExchangeCard(){
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.amber, width: 2),
              borderRadius: BorderRadius.circular(40),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8,),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if(controller.type.value == "0")...[
                  _buildCryptoSelected(),
                  _buildFiatSelected(),
                ],
                if(controller.type.value != "0")...[
                  _buildFiatSelected(),
                  _buildCryptoSelected(),
                ],
              ],
            ),
          ),

          Positioned(
            top: -4,
            bottom: -4,
            left: 0,
            right: 0,
            child: Center(
              child: InkWell(
                onTap: (){
                  if(controller.type.value == "0"){
                    controller.type.value = "1";
                  } else {
                    controller.type.value = "0";
                  }

                  controller.actualizarMontoARecibir();
                },
                child: Container(
                  height: 56,
                  width: 56,
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.compare_arrows, color: Colors.white, size: 32,),
                ),
              ),
            ),
          ),

          Positioned(
            top: -10,
            left: 28,
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              padding: const EdgeInsets.symmetric(horizontal: 8,),
              child: const Text("TENGO",
                style: TextStyle(fontSize: 12,),
              ),
            ),
          ),

          Positioned(
            top: -10,
            right: 28,
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              padding: const EdgeInsets.symmetric(horizontal: 8,),
              child: const Text("QUIERO",
                style: TextStyle(fontSize: 12,),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CircularDividerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paintLeft = Paint()..color = const Color(0xFFCCF1FF);
    final Paint paintRight = Paint()..color = Colors.amber;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paintLeft,
    );

    final Path path = Path()
      ..moveTo(size.width * 0.8, 0)
      ..arcToPoint(
        Offset(size.width * 0.8, size.height),
        radius: Radius.circular(size.height),
        clockwise: false,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paintRight);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
