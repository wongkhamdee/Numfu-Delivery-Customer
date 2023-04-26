// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:numfu/screen/cart.dart';
import 'package:numfu/screen/feedback.dart';
import 'package:numfu/screen/success.dart';
import 'package:numfu/utility/app_controller.dart';
import 'package:numfu/utility/app_service.dart';
import 'package:numfu/utility/my_constant.dart';
import 'package:numfu/widgets/show_title.dart';

import '../model/order_model.dart';

class testMap extends StatefulWidget {
  const testMap({
    Key? key,
  }) : super(key: key);

  @override
  _testMapState createState() => _testMapState();
}

const String apiKey = 'AIzaSyDCIRP40OMRZf1qIUyKT9dPOvO-qGMwBCs';

class _testMapState extends State<testMap> {
  late GoogleMapController mapController;
  final Completer<GoogleMapController> _controller = Completer();
  final appController = Get.put(AppController());
  int count = 0;
  late Timer timer;

  get http => null;

  @override
  void initState() {
    super.initState();
    getPolyPoints();
  }

  @override
  void dispose() {
    timer.cancel(); // ยกเลิกการทำงานของ timer เมื่อปิดหน้าจอ
    super.dispose();
  }

  static const LatLng sourceLocation = LatLng(38.33500926, -122.03272188);
  static const LatLng destination = LatLng(37.33429383, -122.06600055);
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
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Ordering',
          style: MyCostant().headStyle(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: 400,
            child: GoogleMap(
              onMapCreated: (controller) {},
              initialCameraPosition: const CameraPosition(
                target: sourceLocation,
                zoom: 13.0,
              ),
              polylines: polylineCoordinates.isNotEmpty
                  ? {
                      Polyline(
                        polylineId: PolylineId('route'),
                        points: polylineCoordinates,
                        color: MyCostant.black,
                      ),
                    }
                  : {},
              markers: {
                Marker(
                  markerId: MarkerId('start'),
                  position: sourceLocation,
                ),
                Marker(
                  markerId: MarkerId('end'),
                  position: destination,
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}
