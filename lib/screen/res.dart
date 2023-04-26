// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:numfu/model/restaurant_model.dart';
import 'package:numfu/screen/history.dart';
import 'package:numfu/screen/index.dart';
import 'package:numfu/screen/menu.dart';
import 'package:numfu/screen/promotion.dart';
import 'package:numfu/utility/app_controller.dart';
import 'package:numfu/utility/app_service.dart';
import 'package:numfu/utility/my_constant.dart';
import 'package:numfu/widgets/show_title.dart';
import 'package:numfu/widgets/widget_image_network.dart';
import 'package:numfu/widgets/widget_show_footer_cart.dart';

class Res extends StatefulWidget {
  static const routeName = '/';

  const Res({
    Key? key,
    required this.restaurantModel,
  }) : super(key: key);

  final RestaurantModel restaurantModel;

  @override
  State<StatefulWidget> createState() {
    return _ResState();
  }
}

class _ResState extends State<Res> {
  bool load = true;
  @override
  void initState() {
    super.initState();
    AppService().readProductWhereResId(res_id: widget.restaurantModel.res_id);
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurantModel.res_name),
        actions: [
          // IconButton(
          //     onPressed: () {
          //       Get.to(Index());
          //     },
          //     icon: Icon(
          //       Icons.search,
          //       color: Color.fromARGB(255, 95, 95, 95),
          //     )),
          // IconButton(
          //     onPressed: () {
          //       Get.to(Index());
          //     },
          //     icon: Icon(
          //       Icons.favorite,
          //       color: Color.fromARGB(255, 95, 95, 95),
          //     ))
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: GetX(
        init: AppController(),
        builder: (AppController appController) {
          print('## productModels --> ${appController.productModels.length}');
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      buildBanner(
                        restaurantModel: widget.restaurantModel,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                        child: Container(
                          child: Column(
                            children: [
                              showSheet(),
                              buildPro(),
                            ],
                          ),
                        ),
                      ),
                      //buildCate(size: size),
                      appController.productModels.isEmpty
                          ? const SizedBox()
                          : ListView.builder(
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: appController.productModels.length,
                              itemBuilder: (context, index) => InkWell(
                                onTap: () {
                                  appController.amount.value = 1;
                                  appController.distanceKm.value = 0.0;
                                  Get.to(Menu(
                                    productModel:
                                        appController.productModels[index],
                                    restaurantModel: widget.restaurantModel,
                                  ));
                                },
                                child: Card(
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: WidgetImageNetwork(
                                          urlImage:
                                              '${MyCostant.domain}${appController.productModels[index].food_image}',
                                          size: 100,
                                          width: 150,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 100,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ShowTitle(
                                              title: appController
                                                  .productModels[index]
                                                  .food_name,
                                              textStyle: MyCostant().h2Style(),
                                            ),
                                            ShowTitle(
                                              title: cutWord(appController
                                                  .productModels[index]
                                                  .description),
                                              textStyle: MyCostant().h44Style(),
                                            ),
                                            ShowTitle(
                                              title:
                                                  '฿ ${appController.productModels[index].food_price}',
                                              textStyle: MyCostant().h3Style(),
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
                ),
              ),
              // Widget footer cart
              WidgetFootercart(),
            ],
          );
        },
      ),
    );
  }

  String cutWord(String name) {
    String result = name;
    if (result.length > 20) {
      result = result.substring(0, 10);
      result = '$result...';
    }
    return result;
  }

  MaterialButton buildPro() {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
        side: BorderSide(
          color: Color.fromARGB(255, 5, 5, 5),
          width: 2.0,
        ),
      ),
      minWidth: 2,
      onPressed: () {},
      color: MyCostant.white,
      child: Row(
        children: [
          Icon(
            Icons.discount,
            color: MyCostant.primary,
            size: 20.0,
          ),
          Text(
            'ดูโปรโมชันที่สามารถใช้งานได้',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}

class buildBanner extends StatelessWidget {
  const buildBanner({
    Key? key,
    required this.restaurantModel,
  }) : super(key: key);

  final RestaurantModel restaurantModel;

  @override
  Widget build(BuildContext context) {
    String cutWord(String name) {
      String result = name;
      if (result.length > 20) {
        result = result.substring(0, 30);
        result = '$result...';
      }
      return result;
    }

    return Stack(
      children: <Widget>[
        Column(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      '${MyCostant.domain}${restaurantModel.company_logo}'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.3), BlendMode.darken),
                ),
              ),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(left: 20, top: 80),
          child: Text(
            restaurantModel.res_name,
            style: TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.bold,
                fontSize: 30.0),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 20, top: 120),
          child: Row(
            children: [
              Icon(
                Icons.star,
                color: MyCostant.star,
                size: 20.0,
              ),
              Text(
                cutWord(
                  restaurantModel.complete_address,
                ),
                style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class buildMywallet extends StatelessWidget {
  const buildMywallet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 110,
      color: MyCostant.primary,
    );
  }
}

class buildCate extends StatelessWidget {
  const buildCate({
    Key? key,
    required this.size,
  }) : super(key: key);

  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(top: 5, left: 30),
          width: size * 0.2,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: MyCostant.dark),
            borderRadius: BorderRadius.circular(10),
            color: MyCostant.primary,
          ),
          child: Center(
            child: Text(
              "ทั้งหมด",
              style: MyCostant().h6_1button(),
            ),
          ),
        ),
        SizedBox(width: 10),
        Container(
          width: size * 0.2,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: MyCostant.dark),
            borderRadius: BorderRadius.circular(10),
            color: MyCostant.dark2,
          ),
          child: Center(
            child: Text(
              "ข้าวมันไก่",
              style: MyCostant().h6_2button(),
            ),
          ),
        ),
        SizedBox(width: 10),
        Container(
          width: size * 0.2,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: MyCostant.dark),
            borderRadius: BorderRadius.circular(10),
            color: MyCostant.dark2,
          ),
          child: Center(
            child: Text(
              "ก๋วยเตี๋ยว",
              style: MyCostant().h6_2button(),
            ),
          ),
        ),
        SizedBox(width: 10),
        Container(
          width: size * 0.2,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: MyCostant.dark),
            borderRadius: BorderRadius.circular(10),
            color: MyCostant.dark2,
          ),
          child: Center(
            child: Text(
              "น้ำ",
              style: MyCostant().h6_2button(),
            ),
          ),
        ),
      ],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  _State createState() => _State();
}

class _State extends State<HomePage> {
  int _selectedIndex = 0;
  final double _sheetSize = 0.4;
  _onItemTapped(index) {
    setState(() {
      DraggableScrollableActuator.reset(context);
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example'),
      ),
      body: SizedBox.expand(
        child: DraggableScrollableSheet(
          key: UniqueKey(),
          initialChildSize: _sheetSize,
          minChildSize: 0.0,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              color: Colors.blue[100],
              child: ListView.builder(
                controller: scrollController,
                itemCount: 25,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(title: Text('Item $index'));
                },
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class showSheet extends StatefulWidget {
  const showSheet({Key? key}) : super(key: key);

  @override
  State<showSheet> createState() => _showSheetState();
}

class _showSheetState extends State<showSheet> {
  void displayPersistentBottomSheet() {
    Scaffold.of(context).showBottomSheet<void>((BuildContext context) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: [
                Container(
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color(0xffE7E7E7),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '  จัดส่งล่วงเวลา',
                        style: TextStyle(
                          color: MyCostant.primary,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
                Text(
                  '  รับที่ร้าน',
                  style: TextStyle(
                    color: MyCostant.dark80,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      'วันนี้',
                      style: TextStyle(
                        color: MyCostant.primary,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '14',
                      style: TextStyle(
                        color: MyCostant.black,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      width: 100,
                    ),
                    Text(
                      'พฤ.',
                      style: TextStyle(
                        color: MyCostant.black,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '15',
                      style: TextStyle(
                        color: MyCostant.black,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      width: 100,
                    ),
                    Text(
                      'ศ.',
                      style: TextStyle(
                        color: MyCostant.black,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '16',
                      style: TextStyle(
                        color: MyCostant.black,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      width: 100,
                    ),
                    Text(
                      'ส.',
                      style: TextStyle(
                        color: MyCostant.black,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '17',
                      style: TextStyle(
                        color: MyCostant.black,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      width: 40,
                    ),
                    Text(
                      'อ.',
                      style: TextStyle(
                        color: MyCostant.black,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '18',
                      style: TextStyle(
                        color: MyCostant.black,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  'วันนี้ 13:30 - 14:00 น.',
                  style: TextStyle(
                    color: MyCostant.black,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  'วันนี้ 14:30 - 15:00 น.',
                  style: TextStyle(
                    color: MyCostant.black,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  'วันนี้ 15:30 - 16:00 น.',
                  style: TextStyle(
                    color: MyCostant.black,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  'ทันที 40 นาที',
                  style: TextStyle(
                    color: MyCostant.black,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
        side: BorderSide(
          color: Color.fromARGB(255, 5, 5, 5),
          width: 2.0,
        ),
      ),
      minWidth: 2,
      onPressed: displayPersistentBottomSheet,
      color: MyCostant.white,
      child: Row(
        children: [
          Icon(
            Icons.timelapse,
            color: MyCostant.primary,
            size: 20.0,
          ),
          Text(
            ' การจัดส่งล่วงเวลา',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
