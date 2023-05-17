// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numfu/screen/history.dart';
import 'package:numfu/screen/ordering.dart';

import 'package:numfu/utility/app_controller.dart';
import 'package:numfu/utility/app_service.dart';
import 'package:numfu/widgets/show_title.dart';

import '../utility/my_constant.dart';

class AutoRefreshAndNavigatePage extends StatefulWidget {
  @override
  _AutoRefreshAndNavigatePageState createState() =>
      _AutoRefreshAndNavigatePageState();

  const AutoRefreshAndNavigatePage({
    Key? key,
  }) : super(key: key);
}

class _AutoRefreshAndNavigatePageState
    extends State<AutoRefreshAndNavigatePage> {
  final appController = Get.put(AppController());
  int count = 0;
  late Timer timer;
  bool load = true;

  @override
  void initState() {
    super.initState();
    AppService().refreshapprove();

    // เริ่มต้นการนับถอยหลัง
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        if (count < 10) {
          count++;
        } else {
          count = 0;
          AppService().refreshapprove();
          load = true; // ทำการอัพเดทข้อมูลอัตโนมัติ
        }
        if (appController.orderModel.isNotEmpty &&
            appController.orderModel.first.approveRider == '1') {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) =>
                  Ordering(orderModel: appController.orderModel.first)));
          print('#### orderId wait--> ${orderModel.id}');
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel(); // ยกเลิกการทำงานของ timer เมื่อปิดหน้าจอ
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'สั่งอาหาร',
          style: MyCostant().h2wStyle(),
        ),
        backgroundColor: MyCostant.primary,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      backgroundColor: MyCostant.white,
      body: GetX(
          init: AppController(),
          builder: (AppController appController) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  appController.orderModel.isEmpty
                      ? const SizedBox()
                      : Column(
                          children: [
                            Image(
                              image: AssetImage('img/delivery.gif'),
                              width: 150,
                            ),
                            ShowTitle(
                                title: 'รอสักครู่',
                                textStyle: MyCostant().h2Style()),
                            Text(
                              'เรากำลังค้นหาไรเดอร์ให้คุณ',
                              style: MyCostant().h3d80Style(),
                            ),
                            SizedBox(height: 20),
                            // CircularProgressIndicator(
                            //   strokeWidth: 5,
                            //   valueColor: AlwaysStoppedAnimation<Color>(
                            //       MyCostant.primary),
                            // ),

                            // Text(
                            //     'Auto refresh count: $count'), // แสดงตัวเลขนับถอยหลัง
                          ],
                        ),
                ],
              ),
            );
          }),
    );
  }
}
