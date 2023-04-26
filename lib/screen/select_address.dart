// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:numfu/model/address_model.dart';
import 'package:numfu/model/user_model.dart';

import 'package:numfu/screen/Launcher.dart';
import 'package:numfu/screen/index.dart';
import 'package:numfu/screen/profile.dart';
import 'package:numfu/utility/app_service.dart';
import 'package:numfu/utility/my_constant.dart';
import 'package:numfu/utility/my_dialog.dart';
import 'package:numfu/widgets/show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Select_a extends StatefulWidget {
  @override
  State<Select_a> createState() => _Select_aState();

  final double lat;
  final double lng;

  const Select_a({
    Key? key,
    required this.lat,
    required this.lng,
  }) : super(key: key);
}

class _Select_aState extends State<Select_a> {
  final formKey = GlobalKey<FormState>();
  UserModel? userModel;
  TextEditingController addressnameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController addressdetailsController = TextEditingController();
  AddressModel? addressModel;
  //TextEditingController textEditingController1 = TextEditingController();

  @override
  void initState() {
    super.initState();
    processFindAddress();
    findUser();
  }

  Future<void> processFindAddress() async {
    addressModel =
        await AppService().findDataAddress(lat: widget.lat, lng: widget.lng);
    addressController.text =
        '${addressModel!.road} ${addressModel!.subdistrict} ${addressModel!.district} ${addressModel!.province}';
  }

  Future<void> findUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String cust_email = preferences.getString('cust_email')!;
    print('## cust_emai --> $cust_email');
    String apiGetUser =
        '${MyCostant.domain}/getCustomerWhereUser.php?isAdd=true&cust_email=$cust_email';
    await Dio().get(apiGetUser).then((value) {
      print('value from API ==>> $value');
      for (var item in json.decode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);
          addressController.text = userModel!.address;
          addressdetailsController.text = userModel!.address_details!;
          addressnameController.text = userModel!.address_name!;
        });
      }
    });
  }

  Future<Null> editValueToMySQL(String lat, String lng) async {
    print('## pathCustImg ==> $lat , $lng');
    String apiEditProfile =
        '${MyCostant.domain}/customer_insertAddressWhereCustId.php?isAdd=true&cust_id=${userModel!.cust_id}&address_name=${addressnameController.text}&address=${addressController.text}&address_details=${addressdetailsController.text}&lat=$lat&lng=$lng';
    await Dio().get(apiEditProfile).then((value) {
      print('Upload = $value');
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'เพิ่มที่อยู่',
          style: MyCostant().headStyle(),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.navigate_before,
              size: 38,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        behavior: HitTestBehavior.opaque,
        child: Form(
          key: formKey,
          child: ListView(
            //padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
            children: [
              buildtext('ชื่อสถานที่*'),
              buildNameAddress(size),
              buildAdressName(size),
              SizedBox(
                height: 25,
              ),
              buildtext('ที่อยู่*'),
              buildMap(),
              SizedBox(
                height: 25,
              ),
              buildtext('รายละเอียดที่อยู่(ถ้ามี)'),
              buildDetails(size),
              SizedBox(
                height: 25,
              ),
              //buildtext2('**สามารถบันทึกได้สูงสุด 5 สถานที่**'),
              buildSave(size),
            ],
          ),
        ),
      ),
    );
  }

  Row buildNameAddress(double size) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: 20, top: 10),
          width: size * 0.2,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(
              color: MyCostant.dark,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(20),
            color: MyCostant.dark2,
          ),
          child: TextButton(
            onPressed: () {
              setState(() {
                addressnameController.text = "บ้าน";
              });
            },
            child: Center(
              child: Text(
                "บ้าน",
                style: MyCostant().h6_2button(),
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        Container(
          margin: EdgeInsets.only(top: 10),
          width: size * 0.2,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(
              color: MyCostant.dark,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(20),
            color: MyCostant.dark2,
          ),
          child: TextButton(
            onPressed: () {
              setState(() {
                addressnameController.text = "ที่ทำงาน";
              });
            },
            child: Center(
              child: Text(
                "ที่ทำงาน",
                style: MyCostant().h6_2button(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Padding buildMap() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
      child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Color(0xff525252),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: addressController,
              maxLines: 6, //or null
              decoration:
                  InputDecoration.collapsed(hintText: "ใส่ข้อเสนอแนะของคุณ"),
            ),
          )),
    );
  }

  Container buildtext(String title) {
    return Container(
      margin: EdgeInsets.only(left: 20),
      child: Column(
        children: [
          Row(
            children: [
              ShowTitle(title: title, textStyle: MyCostant().h3Style()),
            ],
          ),
        ],
      ),
    );
  }

  Container buildtext2(title2) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShowTitle(title: title2, textStyle: MyCostant().h3_1Style()),
        ],
      ),
    );
  }

  Row buildAdressName(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          width: size * 0.9,
          child: TextFormField(
            controller: addressnameController,
            validator: RequiredValidator(errorText: 'กรุณากรอกชื่อที่อยู่'),
            decoration: InputDecoration(
              labelStyle: MyCostant().h4Style(),
              hintText: "ตั้งชื่อที่อยู่ เช่น บ้าน ที่ทำงาน คอนโด",
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
    );
  }

  Row buildDetails(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          width: size * 0.9,
          child: TextFormField(
            controller: addressdetailsController,
            decoration: InputDecoration(
              labelStyle: MyCostant().h4Style(),
              hintText: "เช่น ชั้น หมายเลขห้อง",
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
    );
  }

  Row buildSave(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 5),
          width: size * 0.9,
          child: ElevatedButton(
            style: MyCostant().myButtonStyle(),
            onPressed: () {
              String lat = widget.lat.toString();
              String lng = widget.lng.toString();

              print('$lat. $lng');
              if (addressnameController.text.isEmpty ||
                  addressController.text.isEmpty) {
                // แสดง Dialog เตือนว่าต้องกรอกข้อมูลให้ครบก่อน
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text('กรุณากรอกข้อมูลให้ครบ'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: Text('ตกลง'),
                      ),
                    ],
                  ),
                );
              } else {
                editValueToMySQL(lat, lng);
              }
            },
            child: ShowTitle(
              title: 'บันทึก',
              textStyle: MyCostant().h5button(),
            ),
          ),
        ),
      ],
    );
  }
}
