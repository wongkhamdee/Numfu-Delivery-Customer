// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:numfu/model/order_model.dart';
import 'package:numfu/screen/his_order_details.dart';
import 'package:numfu/utility/app_controller.dart';
import 'package:numfu/utility/app_service.dart';
import 'package:numfu/utility/my_constant.dart';
import 'package:numfu/widgets/show_progress.dart';
import 'package:numfu/widgets/show_title.dart';
import 'package:numfu/widgets/widget_image_network.dart';

class History extends StatefulWidget {
  static const routeName = '/';

  const History({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HistoryState();
  }
}

late final OrderModel orderModel;

class _HistoryState extends State<History> {
  final appController = Get.put(AppController());
  bool load = true;
  @override
  void initState() {
    processReadOrder();
    super.initState();
  }

  void processReadOrder() {
    AppService().readOrderWhereResId().then((value) {
      appController.orderModel.sort((a, b) => DateTime.parse(b.dateTime)
          .millisecondsSinceEpoch
          .compareTo(DateTime.parse(a.dateTime).millisecondsSinceEpoch));
      setState(() {
        load = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          print('## Ordermodels ===> ${appController.orderModel.length}');

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Text(
                'ประวัติการสั่งซื้อ',
                style: MyCostant().headStyle(),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            backgroundColor: Colors.white,
            body: LayoutBuilder(
                builder: (context, BoxConstraints boxConstraints) {
              return GetX(
                  init: AppController(),
                  builder: (AppController appController) {
                    print('OrderModel = ${appController.orderModel.length}');

                    return SizedBox(
                      width: boxConstraints.maxWidth,
                      height: boxConstraints.maxHeight,
                      child: Stack(
                        children: [
                          load
                              ? const ShowProgress()
                              : ((appController.orderModel.isEmpty))
                                  ? Center(
                                      child: ShowTitle(
                                          title: 'ไม่มีออเดอร์',
                                          textStyle: MyCostant().h2Style()))
                                  : ListView.builder(
                                      itemCount:
                                          appController.orderModel.length,
                                      itemBuilder: (context, index) => InkWell(
                                        onTap: () {
                                          Get.to(HisDetails(
                                              orderModel: appController
                                                  .orderModel[index]));
                                        },
                                        child: Card(
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: WidgetImageNetwork(
                                                    urlImage:
                                                        '${MyCostant.domain}${appController.resModelForListOrders[index].company_logo}',
                                                    size: 120,
                                                    width: 80,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 120,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          DateFormat(
                                                                  'dd MMM yy HH:mm',
                                                                  'th')
                                                              .format(DateTime.parse(
                                                                  appController
                                                                      .orderModel[
                                                                          index]
                                                                      .dateTime))
                                                              .replaceAll(
                                                                  '.', ''),
                                                          style: MyCostant()
                                                              .h4d80Style(),
                                                        ),
                                                        SizedBox(
                                                          width: size * 0.25,
                                                        ),
                                                        ShowTitle(
                                                          title:
                                                              '- ฿${appController.orderModel[index].total}.00',
                                                          textStyle: MyCostant()
                                                              .h3Style(),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.location_on,
                                                          color: Color.fromARGB(
                                                              255, 250, 25, 25),
                                                          size: 20,
                                                        ),
                                                        const SizedBox(
                                                            width: 5),
                                                        ShowTitle(
                                                          title: appController
                                                              .resModelForListOrders[
                                                                  index]
                                                              .res_name,
                                                          textStyle: MyCostant()
                                                              .h3Style(),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.location_on,
                                                          color: Colors.green,
                                                          size: 20,
                                                        ),
                                                        const SizedBox(
                                                            width: 5),
                                                        ShowTitle(
                                                          title: appController
                                                              .currentUserModels
                                                              .last
                                                              .cust_firstname,
                                                          textStyle: MyCostant()
                                                              .h3Style(),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      (() {
                                                        switch (appController
                                                            .orderModel[index]
                                                            .approveRider) {
                                                          case '0':
                                                            return 'รอไรเดอร์รับอาหาร';
                                                          case '1':
                                                            return 'ไรเดอร์รับออเดอร์แล้ว';
                                                          case '2':
                                                            return 'ไรเดอร์เข้ารับอาหาร';
                                                          case '3':
                                                            return 'ไรเดอร์ถึงที่หมายแล้ว';
                                                          case '4':
                                                            return 'จัดส่งสำเร็จ';
                                                          default:
                                                            return '';
                                                        }
                                                      })(),
                                                      style: MyCostant()
                                                          .h4Style()
                                                          .copyWith(
                                                        color: (() {
                                                          switch (appController
                                                              .orderModel[index]
                                                              .approveRider) {
                                                            case '0':
                                                              return Colors.red;
                                                            case '1':
                                                            case '2':
                                                              return Colors
                                                                  .orange;
                                                            case '3':
                                                            case '4':
                                                              return Colors
                                                                  .green;
                                                            default:
                                                              return Colors
                                                                  .black;
                                                          }
                                                        })(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                        ],
                      ),
                    );
                  });
            }),
          );
        });
  }
}
