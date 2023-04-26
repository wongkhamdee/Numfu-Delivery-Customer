// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:numfu/model/restaurant_model.dart';

import 'package:numfu/screen/cart.dart';
import 'package:numfu/screen/feedback.dart';
import 'package:numfu/screen/success.dart';
import 'package:numfu/utility/app_controller.dart';
import 'package:numfu/utility/app_service.dart';
import 'package:numfu/utility/my_constant.dart';
import 'package:numfu/utility/sqlite_helper.dart';
import 'package:numfu/widgets/show_title.dart';

import '../model/order_model.dart';

class Ordering extends StatefulWidget {
  const Ordering({
    Key? key,
    required this.orderModel,
  }) : super(key: key);
  final OrderModel orderModel;

  @override
  _OrderingState createState() => _OrderingState();
}

const String apiKey = 'AIzaSyDCIRP40OMRZf1qIUyKT9dPOvO-qGMwBCs';

class _OrderingState extends State<Ordering> {
  late GoogleMapController mapController;
  List<RestaurantModel> resmodel = [];
  final appController = Get.put(AppController());
  int count = 0;
  late Timer timer;
  late LatLng _center;
  get http => null;
  bool load = true;

  @override
  void initState() {
    super.initState();
    readApiAllSale();
    AppService().readMapWhereOrderIdResIdUserId(id: widget.orderModel.id);
    AppService().refreshapprove();
    // sourceLocation = LatLng(
    //   double.parse(appController.resMapModelForListOrders.last.latitude),
    //   double.parse(appController.resMapModelForListOrders.last.longitude),
    // );
    // destination = LatLng(
    //   double.parse(appController.currentUserModels.last.lat),
    //   double.parse(appController.currentUserModels.last.lng),
    // );

    getPolyPoints();

    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        if (count < 10) {
          count++;
        } else {
          count = 0;
          AppService().refreshapprove(); // ทำการอัพเดทข้อมูลอัตโนมัติ
        }
        if (appController.orderModel.isNotEmpty &&
            appController.orderModel.first.approveRider == '4') {
          appController.orderModel.clear();
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => success()));
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<Null> readApiAllSale() async {
    String url =
        '${MyCostant.domain}/customer_getRestaurnatWhereResid.php?isAdd=true';
    await Dio().get(url).then((value) {
      var result = json.decode(value.data);
      setState(() {
        load = false;
      });
      for (var item in result) {
        RestaurantModel model = RestaurantModel.fromMap(item);
        setState(() {
          resmodel.add(model);
        });
      }
    });
  }

  late LatLng destination;
  late LatLng sourceLocation;
  //  static const LatLng sourceLocation = LatLng(38.33500926, -122.03272188);
  // static const LatLng destination = LatLng(37.33429383, -122.06600055);
  List<LatLng> polylineCoordinates = [];
  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      apiKey,
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetX(
          init: AppController(),
          builder: (AppController appController) {
            return appController.orderModel.isEmpty
                ? const Text('data')
                : Column(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 460,
                            child: GoogleMap(
                              onMapCreated: (controller) {},
                              initialCameraPosition: CameraPosition(
                                target: sourceLocation,
                                zoom: 13.0,
                              ),
                              polylines: polylineCoordinates.isNotEmpty
                                  ? {
                                      Polyline(
                                        polylineId: PolylineId('route'),
                                        points: polylineCoordinates,
                                        color: MyCostant.red,
                                        width: 6,
                                      ),
                                    }
                                  : {},
                              markers: {
                                Marker(
                                  markerId: MarkerId('start'),
                                  position: sourceLocation,
                                  icon: BitmapDescriptor.defaultMarkerWithHue(
                                      BitmapDescriptor.hueBlue),
                                  infoWindow: InfoWindow(
                                    title: appController
                                        .resMapModelForListOrders.last.res_name,
                                    snippet: appController
                                        .resMapModelForListOrders
                                        .last
                                        .complete_address,
                                  ),
                                ),
                                Marker(
                                  markerId: MarkerId('end'),
                                  position: destination,
                                  infoWindow: InfoWindow(
                                    title:
                                        'ที่อยู่ของคุณ ${appController.currentUserModels.last.cust_firstname}',
                                  ),
                                ),
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      appController.resMapModelForListOrders.isEmpty &&
                              appController.orderModel.isEmpty
                          ? const Text('data')
                          : Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 55),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            '${appController.resMapModelForListOrders.first.res_name}',
                                            style: MyCostant().h3Style(),
                                          ),
                                          Text(
                                            '${appController.resMapModelForListOrders.first.complete_address}',
                                            style: MyCostant().h4Style(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                      appController.orderModel.isEmpty
                          ? const Text('data')
                          : Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 55, bottom: 20, top: 20),
                                  child: buildSate(context,
                                      appController: appController),
                                ),
                              ],
                            ),
                      appController.riderMapModel.isEmpty
                          ? const Text('data')
                          : Column(
                              children: [
                                Container(
                                  width: size * 0.9,
                                  decoration: const BoxDecoration(
                                    color: Color(0xffFF8126),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundImage: NetworkImage(
                                                '${MyCostant.domain}${appController.riderMapModel.last.profile_image}'),
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                appController
                                                        .riderMapModel
                                                        .first
                                                        .driver_firstname +
                                                    ' ' +
                                                    appController.riderMapModel
                                                        .first.driver_firstname,
                                                style: TextStyle(
                                                    color: MyCostant.white,
                                                    fontSize: 20),
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.star,
                                                    color: Color.fromARGB(
                                                        255, 255, 241, 41),
                                                    size: 20.0,
                                                  ),
                                                  Text(
                                                    '4.6 เรตติ้ง',
                                                    style: TextStyle(
                                                        color: MyCostant.white,
                                                        fontSize: 20),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                    ],
                  );
          }),
    );
  }

  Column buildSate(BuildContext context,
      {required AppController appController}) {
    final int approveRider =
        int.parse(appController.orderModel.first.approveRider);
    return Column(
      children: [
        Row(children: [
          Wrap(
            spacing: 15.0,
            children: [
              Column(
                children: [
                  Container(
                      height: 50.0,
                      width: 50.0,
                      child: Center(
                        child: Card(
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.hourglass_empty,
                              size: 15.0,
                            ),
                            color:
                                appController.orderModel.first.approveRider ==
                                        '1'
                                    ? MyCostant.primary
                                    : MyCostant.dark80,
                            onPressed: () {},
                          ),
                        ),
                      )),
                  Text('รออาหาร',
                      style: appController.orderModel.first.approveRider == '1'
                          ? MyCostant().h4pStyle()
                          : MyCostant().h4d80Style()),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: Center(
                        child: Card(
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: IconButton(
                            icon: new Icon(
                              Icons.cookie,
                              size: 15.0,
                            ),
                            color:
                                appController.orderModel.first.approveRider ==
                                        '2'
                                    ? MyCostant.primary
                                    : MyCostant.dark80,
                            onPressed: () {},
                          ),
                        ),
                      )),
                  Text('กำลังไปหาคุณ',
                      style: appController.orderModel.first.approveRider == '2'
                          ? MyCostant().h4pStyle()
                          : MyCostant().h4d80Style()),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: Center(
                        child: Card(
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.drive_eta,
                              size: 15.0,
                            ),
                            color:
                                appController.orderModel.first.approveRider ==
                                        '3'
                                    ? MyCostant.primary
                                    : MyCostant.dark80,
                            onPressed: () {},
                          ),
                        ),
                      )),
                  Text('ถึงที่หมาย',
                      style: appController.orderModel.first.approveRider == '3'
                          ? MyCostant().h4pStyle()
                          : MyCostant().h4d80Style()),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: Center(
                        child: Card(
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.check,
                              size: 15.0,
                            ),
                            color:
                                appController.orderModel.first.approveRider ==
                                        '4'
                                    ? MyCostant.primary
                                    : MyCostant.dark80,
                            onPressed: () {},
                          ),
                        ),
                      )),
                  Text('สำเร็จ',
                      style: appController.orderModel.first.approveRider == '4'
                          ? MyCostant().h4pStyle()
                          : MyCostant().h4d80Style()),
                ],
              ),
            ],
          ),
        ]),
      ],
    );
  }
}

Divider buildDivider() {
  return const Divider(
    height: 30,
    thickness: 5,
    indent: 20,
    endIndent: 30,
    color: Color(0xff4A4949),
  );
}
