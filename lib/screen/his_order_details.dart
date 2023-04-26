// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:numfu/screen/Launcher.dart';
import 'package:numfu/screen/history.dart';
import 'package:numfu/utility/app_controller.dart';

import 'package:numfu/utility/app_service.dart';
import 'package:numfu/utility/my_constant.dart';
import 'package:numfu/widgets/show_title.dart';

import '../model/order_model.dart';

class HisDetails extends StatefulWidget {
  const HisDetails({
    Key? key,
    required this.orderModel,
  }) : super(key: key);
  final OrderModel orderModel;

  @override
  State<HisDetails> createState() => _HisDetailsState();
}

class _HisDetailsState extends State<HisDetails> {
  String totalPrice = '';
  @override
  void initState() {
    super.initState();
    AppService().readOrderWhereOrderId(
        id: widget.orderModel.id, res_id: widget.orderModel.idShop);
    print('IDC = ${widget.orderModel.id} CUSTID = ${widget.orderModel.idShop}');
  }

  @override
  Widget build(BuildContext context) {
    int totalPriceInt = int.tryParse(totalPrice) ?? 0;
    int totalAmount = int.parse(widget.orderModel.delivery) +
        int.parse(widget.orderModel.total) +
        totalPriceInt;

    totalPrice = totalPriceInt.toString();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'รายละเอียดการสั่งซื้อ',
          style: MyCostant().headStyle(),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.offAll(() => Launcher());
            Get.to(() => Launcher());
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: GetX(
          init: AppController(),
          builder: (AppController appController) {
            return Center(
              child: Column(
                children: [
                  ShowTitle(
                      title:
                          'ชืื่อร้าน ${appController.resModelForListOrders.first.res_name}',
                      textStyle: MyCostant().h2Style()),
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                        '${MyCostant.domain}${appController.resModelForListOrders.first.company_logo}'),
                  ),
                  Text(
                    'ชื่อผู้ส่ง ${widget.orderModel.idRidder}',
                    style: MyCostant().h2Style(),
                  ),
                  Text(
                    'เลขคำสั่งซื้อ LMF-670600${widget.orderModel.id}',
                    style: MyCostant().h3Style(),
                  ),
                  Text(
                    'วันที่ ${DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.parse(widget.orderModel.dateTime))} ',
                    style: MyCostant().h3Style(),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'จำนวน',
                              style: MyCostant().h3Style(),
                            ),
                            Text(
                              widget.orderModel.amounts
                                  .replaceAll('[', '')
                                  .replaceAll(']', '')
                                  .replaceAll(', ', '\n'),
                              style: MyCostant().h3Style(),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'รายการ',
                              style: MyCostant().h3Style(),
                            ),
                            Text(
                              widget.orderModel.names
                                  .replaceAll('[', '')
                                  .replaceAll(']', '')
                                  .replaceAll(', ', '\n'),
                              style: MyCostant().h3Style(),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Text(
                              'ราคา',
                              style: MyCostant().h3Style(),
                            ),
                            for (var name in widget.orderModel.prices
                                .replaceAll('[', '')
                                .replaceAll(']', '')
                                .split(','))
                              Text(
                                name,
                                style: MyCostant().h3Style(),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  buildDivider(),
                  Text(
                    'ค่าส่ง ${widget.orderModel.delivery} บาท',
                    style: MyCostant().h2Style(),
                  ),
                  Text(
                    'ค่าอาหาร ${widget.orderModel.total} บาท',
                    style: MyCostant().h2Style(),
                  ),
                  Text(
                    'ราคารวม $totalAmount บาท',
                    style: MyCostant().h2Style(),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

Divider buildDivider() {
  return const Divider(
    height: 25,
    color: Color(0xff4A4949),
  );
}
