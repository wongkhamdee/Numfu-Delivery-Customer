// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:numfu/model/restaurant_model.dart';

import 'package:numfu/model/sqlite_model.dart';
import 'package:numfu/screen/Launcher.dart';
import 'package:numfu/screen/index.dart';
import 'package:numfu/screen/location.dart';
import 'package:numfu/screen/ordering.dart';
import 'package:numfu/screen/res.dart';
import 'package:numfu/screen/wait_approve.dart';
import 'package:numfu/screen/wallet.dart';
import 'package:numfu/utility/app_controller.dart';
import 'package:numfu/utility/app_service.dart';
import 'package:numfu/utility/my_constant.dart';
import 'package:numfu/utility/my_dialog.dart';
import 'package:numfu/utility/sqlite_helper.dart';
import 'package:numfu/widgets/show_title.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  void initState() {
    super.initState();
    AppService().processCalculatefood();
    AppService().findCurrentUsermodel();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'ตะกร้าสินค้า',
          style: MyCostant().headStyle(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                MyDialog().normalDialog(
                    context, 'ยกเลิกตะกร้า', 'คุณต้องการยกเลิกคำสั่งซื้อ?',
                    firstAction: TextButton(
                        onPressed: () {
                          SQLiteHelper().deleteAlldata().then((value) {
                            Get.back();
                            Get.back();
                          });
                        },
                        child: const Text('ยืนยัน')));
              },
              icon: Icon(Icons.remove_shopping_cart_rounded)),
        ],
      ),
      backgroundColor: Colors.white,
      body: GetX(
          init: AppController(),
          builder: (AppController appController) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: appController.sqliteModels.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.shopping_cart, size: 50),
                          const SizedBox(height: 20),
                          const Text(
                            'ไม่มีสินค้าในตะกร้า',
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              // กลับไปที่หน้า luncher
                              Get.offAll(() => Launcher());
                            },
                            child: const Text(
                              'เลือกร้าน',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  MyCostant.primary),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      child: ListView(
                        children: [
                          const SizedBox(
                            height: 0,
                          ),

                          buildboxaddress(),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                ' สรุปคำสั่งซื้อ',
                                style: MyCostant().h2Style(),
                              ),
                              GestureDetector(
                                // onTap: () {
                                //   Get.to(Res(
                                //       restaurantModel:
                                //           appController.restaurantModels.last));
                                // },
                                child: Text(
                                  'เพิ่มเมนู ',
                                  style: MyCostant().h44Style(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 3),
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemCount: appController.sqliteModels.length,
                              itemBuilder: (context, index) => buildBoxmenu1(
                                  index: index,
                                  appController: appController,
                                  context: context)),
                          // buildBoxmenu1(),
                          // buildDivider(),
                          // buildBoxmenu2(),
                          buildDivider(),
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                'รวมค่าอาหาร',
                                style: MyCostant().h3Style(),
                              )),
                              Text(
                                '฿ ${appController.total.value}',
                                style: MyCostant().h3Style(),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                'ค่าจัดส่ง',
                                style: MyCostant().h3Style(),
                              )),
                              Text(
                                '฿ ${appController.sqliteModels.last.derivery}',
                                style: MyCostant().h3Style(),
                              ),
                            ],
                          ),
                          buildDivider(),
                          Text(
                            'รายละเอียดการชำระเงิน',
                            style: MyCostant().h2Style(),
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                'ยอดเงินคงเหลือ',
                                style: MyCostant().h3Style(),
                              )),
                              Text(
                                appController.currentUserModels.isEmpty
                                    ? ''
                                    : '฿ ${(int.parse(appController.currentUserModels.last.wallet!) - int.parse(appController.currentUserModels.last.payment!))}',
                                style: MyCostant().h3Style(),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                'ยอดรวมทั้งหมด',
                                style: MyCostant().h2Style(),
                              )),
                              Text(
                                '฿ ${(int.parse(appController.sqliteModels.last.derivery) + appController.total.value)}',
                                style: MyCostant().h2Style(),
                              ),
                            ],
                          ),
                          buildEnter(
                            size: size,
                            appController: appController,
                          ),
                        ],
                      ),
                    ),
            );
          }),
    );
  }

  String cutWord(String name) {
    String result = name;
    if (result.length > 14) {
      result = result.substring(0, 10);
      result = '$result...';
    }
    return result;
  }
}

class buildboxaddress extends StatelessWidget {
  const buildboxaddress({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Obx(() {
        final appController = Get.find<AppController>();
        return Card(
          color: Color(0xffFF8126),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "จัดส่งที่",
                  style: MyCostant().h2wStyle(),
                ),
                Text(
                  appController.currentUserModels.last.address,
                  style: MyCostant().h4wStyle(),
                ),
                Container(
                  width: size * 0.15,
                  decoration: const BoxDecoration(
                    color: Color(0xffffffff),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        ' 0.1 km',
                        style: MyCostant().h4Style(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

Row buildAdd_remove1(
    {required index,
    required AppController appController,
    required BuildContext context}) {
  return Row(
    children: [
      Container(
        width: 115,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xffF5F4F4),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                int amountInt =
                    int.parse(appController.sqliteModels[index].amount);

                if (amountInt == 1) {
                  //delete product
                  MyDialog()
                      .normalDialog(context, 'Confirm Delete', 'Please Confirm',
                          firstAction: TextButton(
                              onPressed: () {
                                Get.back();
                                SQLiteHelper().deleteWhereId(
                                    id: appController.sqliteModels[index].id!);
                                if (appController.sqliteModels.length == 1) {
                                  // if no product in cart, go back to index automatically
                                  Get.offAll(() => Launcher());
                                }
                              },
                              child: const Text('Confirm')));
                } else {
                  amountInt--;

                  Map<String, dynamic> map =
                      appController.sqliteModels[index].toMap();

                  map['amount'] = amountInt.toString();
                  map['sum'] = (amountInt *
                          int.parse(appController.sqliteModels[index].price))
                      .toString();

                  SQLiteHelper()
                      .editData(
                          id: appController.sqliteModels[index].id!, map: map)
                      .then((value) {
                    AppService().processCalculatefood();
                  });
                }
              },
              icon: Icon(
                Icons.remove_circle,
                color: Color.fromARGB(255, 214, 214, 214),
              ),
            ),
            Text(
              appController.sqliteModels[index].amount,
              style: MyCostant().h3Style(),
            ),
            IconButton(
              onPressed: () {
                int amountInt =
                    int.parse(appController.sqliteModels[index].amount);

                amountInt++;

                Map<String, dynamic> map =
                    appController.sqliteModels[index].toMap();

                map['amount'] = amountInt.toString();
                map['sum'] = (amountInt *
                        int.parse(appController.sqliteModels[index].price))
                    .toString();

                SQLiteHelper()
                    .editData(
                        id: appController.sqliteModels[index].id!, map: map)
                    .then((value) {
                  AppService().processCalculatefood();
                });
              },
              icon: const Icon(
                Icons.add_circle,
                color: Color(0xffFF8126),
              ),
            ),
          ],
        ),
      ),
      Text(
        '  ฿ ${appController.sqliteModels[index].sum}',
        style: MyCostant().h3_1Style(),
      ),
    ],
  );
}

Container buildBoxmenu1(
    {required int index,
    required AppController appController,
    required BuildContext context}) {
  return Container(
    width: 400,
    height: 120,
    decoration: const BoxDecoration(
      color: Color.fromARGB(255, 255, 255, 255),
      borderRadius: BorderRadius.all(Radius.circular(15)),
    ),
    child: Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 150,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(
                            '${MyCostant.domain}${appController.sqliteModels[index].urlImage}'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 15),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appController.sqliteModels[index].foodName,
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      buildAdd_remove1(
                          appController: appController,
                          index: index,
                          context: context),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Divider buildDivider() {
  return const Divider(
    height: 25,
    color: Color(0xff4A4949),
  );
}

class buildEnter extends StatelessWidget {
  const buildEnter({
    Key? key,
    required this.size,
    required this.appController,
  }) : super(key: key);

  final double size;
  final AppController appController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (appController.currentUserModels.last.address.isNotEmpty) {
          var idProducts = <String>[];
          var names = <String>[];
          var prices = <String>[];
          var amounts = <String>[];

          for (var element in appController.sqliteModels) {
            idProducts.add(element.id.toString());
            names.add(element.foodName);
            prices.add(element.price);
            amounts.add(element.amount);
          }

          String url =
              'https://www.androidthai.in.th/edumall/customer_insertOrder.php?isAdd=true&idCustomer=${appController.currentUserModels.last.cust_id}&idShop=${appController.sqliteModels.last.resId}&idRidder=0&dateTime=${DateTime.now().toString()}&idProducts=${idProducts.toString()}&names=${names.toString()}&prices=${prices.toString()}&amounts=${amounts.toString()}&total=${appController.total}&delivery=${appController.sqliteModels.last.derivery}&approveShop=0&approveRider=0&payment=${appController.currentUserModels.last.payment}';
          print('##16april url --> $url');

          if (int.parse(appController.currentUserModels.last.wallet!) -
                  int.parse(appController.currentUserModels.last.payment!) >=
              int.parse(appController.sqliteModels.last.derivery) +
                  appController.total.value) {
            await MyDialog()
                .normalDialog(context, 'คำสั่งซื้อ', 'ยืนยันคำสั่งซื้อ',
                    firstAction: TextButton(
                        onPressed: () async {
                          await Dio().get(url).then((value) {
                            Get.off(() => AutoRefreshAndNavigatePage());
                            SQLiteHelper().deleteAlldata();
                          });
                        },
                        child: const Text('ยืนยัน')));
          } else {
            MyDialog().normalDialog(context, 'ยกเลิกออเดอร์', 'เงินไม่พอ',
                firstAction: TextButton(
                    onPressed: () {
                      Get.off(Wallet());
                    },
                    child: const Text('เติมเงิน')));
          }
        } else {
          MyDialog().normalDialog(
              context, 'ไม่สามารถสั่งอาหารได้', 'กรุณาตั้งค่าที่อยู่ก่อน',
              firstAction: TextButton(
                  onPressed: () {
                    Get.off(() => LocationMap());
                  },
                  child: const Text('ตั้งค่าที่อยู่')));
        }
      },
      child: Container(
        margin: EdgeInsets.only(top: 0),
        width: size * 10,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: MyCostant.primary,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            "ยืนยันคำสั่งซื้อ",
            style: MyCostant().h5button(),
          ),
        ),
      ),
    );
  }
}
