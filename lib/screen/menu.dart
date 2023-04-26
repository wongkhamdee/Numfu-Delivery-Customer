// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:numfu/model/product_model.dart';
import 'package:numfu/model/restaurant_model.dart';
import 'package:numfu/model/sqlite_model.dart';
import 'package:numfu/utility/app_controller.dart';
import 'package:numfu/utility/app_service.dart';
import 'package:numfu/utility/my_constant.dart';
import 'package:numfu/utility/sqlite_helper.dart';
import 'package:numfu/widgets/show_title.dart';
import 'package:numfu/widgets/widget_image_network.dart';

class Menu extends StatefulWidget {
  const Menu({
    Key? key,
    required this.productModel,
    required this.restaurantModel,
  }) : super(key: key);

  final ProductModel productModel;
  final RestaurantModel restaurantModel;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  void initState() {
    super.initState();
    AppService().findPostion().then((value) {
      AppController controller = Get.put(AppController());

      controller.distanceKm.value = AppService().calculateDistance(
          controller.position.last.latitude,
          controller.position.last.longitude,
          double.parse(widget.restaurantModel.latitude),
          double.parse(widget.restaurantModel.longitude));
    });

    SQLiteHelper().readData();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '',
          style: MyCostant().headStyle(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: GetX(
          init: AppController(),
          builder: (AppController appController) {
            print('sqliteModels --> ${appController.sqliteModels.length}');
            return Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildBanner(),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Text(widget.productModel.food_name,
                                  style: MyCostant().h2Style())),
                          Icon(Icons.favorite_border,
                              size: 30, color: Colors.black),
                        ],
                      ),
                      Text('${widget.productModel.description}',
                          style: MyCostant().h44Style()),
                      buildAdd_remove(appController: appController),
                      buildDivider(),
                      //  ----ห้ามลบ----
                      // Row(
                      //   children: [
                      //     Text('ระยะทาง : ', style: MyCostant().h3Style()),
                      //     ShowTitle(
                      //         title:
                      //             '${appController.distanceKm.toStringAsFixed(1)} km',
                      //         textStyle: MyCostant().h3Style())
                      //   ],
                      // ),
                      // Row(
                      //   children: [
                      //     Text('ค่าส่ง : ', style: MyCostant().h3Style()),
                      //     ShowTitle(
                      //         title:
                      //             '฿ ${AppService().calculatePriceDistance(distance: appController.distanceKm.value)}',
                      //         textStyle: MyCostant().h3Style())
                      //   ],
                      // ),
                      // buildchoice1(),
                      // Text('ซีอิ๊วดำหวาน', style: MyCostant().h3Style()),
                      // buildchoice2(),
                      // Text('ขนาด', style: MyCostant().h3Style()),
                      // buildchoice3(),
                      // buildchoice4(),
                      const Spacer(),
                      buildEnter(
                        size: size,
                        appController: appController,
                        restaurantModel: widget.restaurantModel,
                        productModel: widget.productModel,
                      ),
                    ],
                  ),
                ));
          }),
    );
  }

  Row buildAdd_remove({required AppController appController}) {
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
                  if (appController.amount.value > 1) {
                    appController.amount.value--;
                  }
                },
                icon: Icon(
                  Icons.remove_circle,
                  color: Color.fromARGB(255, 214, 214, 214),
                ),
              ),
              Text(
                appController.amount.toString(),
                style: MyCostant().h3Style(),
              ),
              IconButton(
                onPressed: () {
                  appController.amount.value++;
                },
                icon: Icon(
                  Icons.add_circle,
                  color: Color(0xffFF8126),
                ),
              ),
            ],
          ),
        ),
        Text(
          '  ฿ ${appController.amount.value * int.parse(widget.productModel.food_price)}',
          style: MyCostant().h3_1Style(),
        ),
      ],
    );
  }

  Divider buildDivider() {
    return const Divider(
      height: 20,
      color: Color(0xffD8D8D8),
    );
  }

  ClipRRect buildBanner() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox.fromSize(
        // child: Image.asset(
        //   'img/1.jpg',
        //   height: 200,
        //   width: double.infinity,
        //   fit: BoxFit.cover,
        // ),
        child: WidgetImageNetwork(
          urlImage: '${MyCostant.domain}${widget.productModel.food_image}',
          width: double.infinity,
          size: 200,
        ),
      ),
    );
  }
}

class buildEnter extends StatelessWidget {
  const buildEnter({
    Key? key,
    required this.size,
    required this.appController,
    required this.restaurantModel,
    required this.productModel,
  }) : super(key: key);

  final double size;
  final AppController appController;
  final RestaurantModel restaurantModel;
  final ProductModel productModel;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SQLiteHelper().readData().then((value) {
          SQLiteModel sqLiteModel = SQLiteModel(
            resId: restaurantModel.res_id,
            resName: restaurantModel.res_name,
            foodName: productModel.food_name,
            price: productModel.food_price,
            amount: appController.amount.toString(),
            sum: (int.parse(productModel.food_price) *
                    appController.amount.value)
                .toString(),
            distance: appController.distanceKm.value.toString(),
            derivery: AppService().calculatePriceDistance(
                distance: appController.distanceKm.value),
            urlImage: productModel.food_image,
          );

          print('sqliteModel --> ${sqLiteModel.toMap()}');

          if (appController.sqliteModels.isEmpty) {
            // new cart
            SQLiteHelper().insertData(sqLiteModel: sqLiteModel).then((value) {
              Get.back();
              Get.snackbar('Add Cart', 'Add Cart Success');
            });
          } else {
            // old cart
            print(
                '## aooController.sqlModel.last --> ${appController.sqliteModels.last.toMap()}');

            if (appController.sqliteModels.last.resId == sqLiteModel.resId) {
              //Same Shop
              SQLiteHelper().insertData(sqLiteModel: sqLiteModel).then((value) {
                Get.back();
                Get.snackbar('Add Cart', 'Add Cart Success');
              });
            } else {
              Get.snackbar('ผิดร้าน',
                  'กรุณาเลือกร้าน ${appController.sqliteModels.last.resName} ก่อน');
            }
          }
        });
        // Navigator.push(context, MaterialPageRoute(builder: (context) {
        //   return Cart();
        // }));
      },
      child: Container(
        margin: EdgeInsets.only(
          top: 0,
          bottom: 20,
        ),
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
            "เพิ่มไปยังตะกร้า",
            style: MyCostant().h5button(),
          ),
        ),
      ),
    );
  }
}

MaterialButton buildchoice1() {
  return MaterialButton(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(1.0))),
    onPressed: () {},
    color: MyCostant.white,
    child: Row(
      children: [
        Icon(
          Icons.check_box,
          color: MyCostant.primary,
          size: 20.0,
        ),
        Expanded(
          child: Text(
            ' ไข่ต้ม',
            style: TextStyle(fontSize: 18),
          ),
        ),
        Text(
          '฿ 10',
          style: TextStyle(fontSize: 18),
        ),
      ],
    ),
  );
}

MaterialButton buildchoice2() {
  return MaterialButton(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(1.0))),
    onPressed: () {},
    color: MyCostant.white,
    child: Row(
      children: [
        Icon(
          Icons.check_box,
          color: MyCostant.primary,
          size: 20.0,
        ),
        Expanded(
          child: Text(
            ' ซีอิ๊วดำหวาน',
            style: TextStyle(fontSize: 18),
          ),
        ),
        Text(
          '฿ 0',
          style: TextStyle(fontSize: 18),
        ),
      ],
    ),
  );
}

MaterialButton buildchoice3() {
  return MaterialButton(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(1.0))),
    onPressed: () {},
    color: MyCostant.white,
    child: Row(
      children: [
        Icon(
          Icons.check_box,
          color: MyCostant.primary,
          size: 20.0,
        ),
        Expanded(
          child: Text(
            ' จั๊มโบ้',
            style: TextStyle(fontSize: 18),
          ),
        ),
        Text(
          '฿ 40',
          style: TextStyle(fontSize: 18),
        ),
      ],
    ),
  );
}

MaterialButton buildchoice4() {
  return MaterialButton(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(1.0))),
    onPressed: () {},
    color: MyCostant.white,
    child: Row(
      children: [
        Icon(
          Icons.check_box,
          color: MyCostant.primary,
          size: 20.0,
        ),
        Expanded(
          child: Text(
            ' พิเศษ',
            style: TextStyle(fontSize: 18),
          ),
        ),
        Text(
          '฿ 20',
          style: TextStyle(fontSize: 18),
        ),
      ],
    ),
  );
}
