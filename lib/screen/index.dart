import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:numfu/screen/Favorite.dart';
import 'package:numfu/screen/carousel.dart';
import 'package:numfu/screen/location.dart';
import 'package:numfu/screen/login.dart';
import 'package:numfu/screen/promotion.dart';
import 'package:numfu/screen/res_all.dart';
import 'package:numfu/screen/search.dart';
import 'package:numfu/state/build_address.dart';
import 'package:numfu/state/build_res.dart';
import 'package:numfu/utility/app_controller.dart';
import 'package:numfu/utility/app_service.dart';
import 'package:numfu/utility/my_constant.dart';
import 'package:numfu/utility/sqlite_helper.dart';
import 'package:numfu/widgets/widget_show_icon_cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/restaurant_model.dart';

final FocusNode _searchFocusNode = FocusNode();

class Index extends StatefulWidget {
  static const routeName = '/';

  const Index({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _IndexState();
  }
}

class _IndexState extends State<Index> {
  bool load = true;
  @override
  void initState() {
    super.initState();
    AppService().findCurrentUsermodel();
    AppService().readAllRestaurant();
    AppService().findPostion();
  }

  Future<void> _refreshList() async {
    // ดึงข้อมูลใหม่จากฐานข้อมูลหรือ API ได้ตามต้องการ
    setState(() {
      load = true;
    });
    await AppService().findCurrentUsermodel();
    await AppService().readAllRestaurant();
    await AppService().findPostion();

    // อัพเดต state ให้กับ ListView.builder
    setState(() {
      load = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return GetX(
        init: AppController(),
        builder: (AppController appController) {
          print(
              '## restautantModels ===> ${appController.restaurantModels.length}');
          print('## position --> ${appController.position.length}');
          return GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: GetX(
                init: AppController(),
                builder: (AppController appController) {
                  print(
                      'sqLiteModels --> ${appController.sqliteModels.length}');
                  return Scaffold(
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                      title: Text(
                        "Numfu Delivery",
                        style: GoogleFonts.khand(
                            textStyle: const TextStyle(fontSize: 36)),
                      ),
                      actions: [
                        IconButton(
                          onPressed: () {
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (context) {
                            //   return const Favorite();
                            // }));
                          },
                          icon: const Icon(
                            Icons.favorite,
                            color: Color.fromARGB(255, 255, 7, 40),
                          ),
                        ),
                      ],
                      backgroundColor: Colors.white,
                      elevation: 0,
                    ),
                    backgroundColor: Colors.white,
                    body: appController.currentUserModels.isEmpty
                        ? const SizedBox()
                        : Center(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: Stack(
                                children: [
                                  Container(
                                    child: RefreshIndicator(
                                      onRefresh: _refreshList,
                                      child: ListView(
                                        children: [
                                          // const BuildAdress(),
                                          buildAddress(context,
                                              appController: appController),
                                          buildSearch(size),
                                          const SizedBox(height: 20),
                                          Carousel(),
                                          buildPro(),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 4),
                                            child: buildTextRecommended(),
                                          ),
                                          Expanded(
                                            child: BuildRes(),
                                          ),
                                          // Text(
                                          //   'ร้านน่าลอง',
                                          //   style: MyCostant().h2Style(),
                                          // ),
                                          // SizedBox(
                                          //   height: 500,
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const WidgetIconCart(),
                                ],
                              ),
                            ),
                          ),
                  );
                }),
          );
        });
  }

  Column buildTextRecommended() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ร้านค้าแนะนำ',
          style: MyCostant().h2Style(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'ใกล้บ้านคุณ',
              style: MyCostant().h3Style(),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Positioned(
                child: InkWell(
                  onTap: () {
                    Get.to(BuildResAll());
                  },
                  child: Text(
                    'ทั้งหมด',
                    style: TextStyle(
                      color: MyCostant.primary,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Container buildAddress(BuildContext context,
      {required AppController appController}) {
    String address =
        appController.currentUserModels.last.address_name.toString();
    return Container(
      width: double.infinity,
      height: 110,
      color: MyCostant.primary,
      child: Row(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(10.0),
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(1000),
              image: const DecorationImage(
                image: AssetImage("img/delivery.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: const TextStyle(fontFamily: 'MN'),
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const LocationMap();
              }));
            },
            child: Text(
              address.isNotEmpty ? 'จัดส่งที่ : $address' : 'กรุณาเลือกที่อยู่',
              style: TextStyle(
                  fontSize: 24, color: Color.fromARGB(255, 255, 255, 255)),
            ),
          ),
          Icon(
            Icons.edit,
            color: Colors.white,
            size: 20.0,
          ),
        ],
      ),
    );
  }

  MaterialButton buildPro() {
    return MaterialButton(
      onPressed: () {},
      color: MyCostant.light,
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              'คูปองส่วนลดอาหาร',
              style: MyCostant().h7button(),
            ),
          ),
          Positioned(
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Color(0xffFF8126),
                border: Border.all(
                  color: Color(0xffFF8126),
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Text(
                ' ดู ',
                style: MyCostant().h7button().copyWith(color: MyCostant.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row buildSearch(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
              width: size * 0.90,
              child: TextFormField(
                readOnly: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchPage()),
                  );
                },
                decoration: InputDecoration(
                  labelStyle: MyCostant().h4Style(),
                  labelText: 'กินอะไรดี?',
                  prefixIcon: Icon(Icons.search),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: MyCostant.dark, width: 2),
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: MyCostant.light, width: 2),
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
