import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:numfu/model/address_model.dart';
import 'package:numfu/model/user_model.dart';
import 'package:numfu/screen/register.dart';
import 'package:numfu/utility/my_constant.dart';
import 'package:numfu/utility/my_dialog.dart';
import 'package:numfu/widgets/show_image.dart';
import 'package:numfu/widgets/show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../utility/app_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  double? lat, lng;
  AddressModel? addressModel;

  bool statusRedEye = true;
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _canSubmit = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(_updateButtonState);
    passwordController.addListener(_updateButtonState);
    CheckPermisson();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _canSubmit =
          emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BuildImages(size),
                  buildAppName(),
                  buildText(),
                  BuildUsers(size),
                  BuildPassword(size),
                  BuildLogin(size),
                  BuildCreateAccount(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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

  Row BuildCreateAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 40),
          child: ShowTitle(
            title: 'คุณเป็นสมาชิกเเล้วหรือไม่?',
            textStyle: MyCostant().h3Style(),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Register();
            }));
          },
          child: Text(
            'สมัครสมาชิก',
            style: TextStyle(
              color: MyCostant.primary,
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }

  Row BuildLogin(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 40),
          width: size * 0.9,
          height: 38,
          child: ElevatedButton(
            style: MyCostant().myButtonStyle(),
            onPressed: _canSubmit
                ? () {
                    String cust_email = emailController.text;
                    String password = passwordController.text;
                    checkAuthen(cust_email: cust_email, password: password);
                  }
                : null,
            child: Text(
              'เข้าสู่ระบบ',
              style: MyCostant().h5button(),
            ),
          ),
        ),
      ],
    );
  }

  Future<Null> checkAuthen({String? cust_email, String? password}) async {
    String apiCheckAuthen =
        '${MyCostant.domain}/getCustomerWhereUser.php?isAdd=true&cust_email=$cust_email';
    print('## apiCheck ---> $apiCheckAuthen');
    await Dio().get(apiCheckAuthen).then((value) async {
      if (value.toString() == 'null') {
        MyDialog().normalDialog(
            context, 'User False !!', 'ไม่มีข้อมูล $cust_email อยู่ในระบบ');
      } else {
        for (var item in json.decode(value.data)) {
          UserModel model = UserModel.fromMap(item);
          if (password == model.password) {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.setString('cust_id', model.cust_id);
            preferences.setString('cust_email', model.cust_email);

            var datas = <String>[];
            datas.add(model.cust_id);
            datas.add(model.cust_firstname);
            datas.add(model.cust_lastname);
            datas.add(model.lat);
            datas.add(model.lng);
            datas.add(model.cust_email);

            preferences.setStringList('datas', datas).then((value) {
              Navigator.pushNamedAndRemoveUntil(
                  context, MyCostant.routeluncher, (route) => false);
            });
          } else {
            MyDialog().normalDialog(
                context, 'Password Fail !!', 'กรุณากรอกรหัสผ่านอักครั้ง');
          }
        }
      }
    });
  }

  Row BuildUsers(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 40),
          width: size * 0.9,
          child: TextFormField(
            controller: emailController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกอีเมลของท่าน';
              } else {
                return null;
              }
            },
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelStyle: MyCostant().h4Style(),
              labelText: 'อีเมล',
              hintText: "กรอกอีเมลของคุณ",
              suffixIcon: Icon(Icons.email),
              contentPadding: EdgeInsets.only(left: 20),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyCostant.dark, width: 2),
                  borderRadius: BorderRadius.circular(30)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyCostant.light, width: 2),
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ),
      ],
    );
  }

  Row BuildPassword(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          width: size * 0.9,
          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกกรอกรหัสผ่านของท่าน';
              } else {
                return null;
              }
            },
            // controller: passwordController,
            controller: passwordController,
            obscureText: statusRedEye,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    statusRedEye = !statusRedEye;
                  });
                },
                icon: statusRedEye
                    ? Icon(
                        Icons.remove_red_eye,
                      )
                    : Icon(
                        Icons.remove_red_eye_outlined,
                      ),
              ),
              labelStyle: MyCostant().h4Style(),
              labelText: 'รหัสผ่าน',
              hintText: "กรอกรหัสผ่านของคุณ",
              contentPadding: EdgeInsets.only(left: 20),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyCostant.dark, width: 2),
                  borderRadius: BorderRadius.circular(30)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyCostant.light, width: 2),
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ),
      ],
    );
  }

  Column buildText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 40),
        ),
        ShowTitle(
          title: 'ยินดีต้อนรับ',
          textStyle: MyCostant().h2Style(),
        ),
        ShowTitle(
          title: 'กรุณากรอกบัญชีของคุณ',
          textStyle: MyCostant().h2Style(),
        ),
      ],
    );
  }

  Row BuildImages(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          width: size * 0.5,
          child: ShowImage(path: MyCostant.logo),
        ),
      ],
    );
  }
}

Row buildAppName() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      ShowTitle(
        title: MyCostant.appName,
        textStyle: MyCostant().h1Style(),
      ),
    ],
  );
}
