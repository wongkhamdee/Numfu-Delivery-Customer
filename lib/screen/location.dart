import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:numfu/model/address_model.dart';
import 'package:numfu/screen/select_address.dart';
import 'package:numfu/state/build_enter.dart';
import 'package:numfu/utility/app_service.dart';
import 'package:numfu/utility/my_dialog.dart';
import 'package:numfu/widgets/show_progress.dart';
import 'package:numfu/utility/my_constant.dart';
import 'package:numfu/widgets/show_title.dart';

class LocationMap extends StatefulWidget {
  const LocationMap({Key? key}) : super(key: key);

  @override
  State<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  double? lat, lng;
  AddressModel? addressModel;

  @override
  void initState() {
    super.initState();
    CheckPermisson();
  }

  Future<void> CheckPermisson() async {
    bool locationService;
    LocationPermission locationPermission;

    locationService = await Geolocator.isLocationServiceEnabled();
    if (locationService) {
      print('ตำแหน่งที่ตั้งเปิดอยู่');

      locationPermission = await Geolocator.checkPermission();
      if (locationPermission == LocationPermission.denied) {
        locationPermission = await Geolocator.requestPermission();
        if (locationPermission == LocationPermission.deniedForever) {
          MyDialog().alertLocationService(
              context, 'คุณไม่ได้อนุญาตให้แชร์ Location', 'กรุณาแชร์ Location');
        } else {
          // Find latlng
          findLatLng();
        }
      } else {
        if (locationPermission == LocationPermission.deniedForever) {
          MyDialog().alertLocationService(
              context, 'คุณไม่ได้อนุญาตให้แชร์ ', 'กรุณาแชร์ Location');
        } else {
          // Find latlng
          findLatLng();
        }
      }
    } else {
      print('ตำแหน่งที่ตั้งถูกปิดอยู่');
      MyDialog().alertLocationService(context, 'Location Service ปิดอยู่ ?',
          'กรุณาเปิด Location Service ของคุณ');
    }
  }

  Future<void> findLatLng() async {
    print('findLatLng ==> work');
    Position? position = await findPostion();

    lat = position!.latitude;
    lng = position.longitude;
    print('lat' '$lat' 'lng' '$lng');
    addressModel = await AppService().findDataAddress(lat: lat!, lng: lng!);

    setState(() {});
  }

  Future<Position?> findPostion() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition();
      return position;
    } catch (e) {
      return null;
    }
  }

  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          buildMap(),
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          lat == null
              ? const SizedBox()
              : Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: BuildEnter(
                    size: size,
                    lat: lat!,
                    lng: lng!,
                  ),
                ),
        ],
      ),
    );
  }

  Set<Marker> setMarker() => <Marker>[
        Marker(
            markerId: MarkerId('id'),
            position: LatLng(lat!, lng!),
            infoWindow: InfoWindow(
                title: 'คุณอยู่ที่นี่',
                snippet: addressModel == null ? '' : '${addressModel!.road}')),
      ].toSet();

  Container buildMap() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: lat == null
          ? ShowProgress()
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(lat!, lng!),
                zoom: 16,
              ),
              onMapCreated: (controller) {},
              onTap: (LatLng latLng) {
                setState(() {
                  lat = latLng.latitude;
                  lng = latLng.longitude;
                });
              },
              markers: setMarker(),
            ),
    );
  }
}
