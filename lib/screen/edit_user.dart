import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:numfu/model/user_model.dart';
import 'package:numfu/utility/app_service.dart';
import 'package:numfu/utility/my_constant.dart';
import 'package:numfu/utility/my_dialog.dart';
import 'package:numfu/widgets/show_image.dart';
import 'package:numfu/widgets/show_progress.dart';
import 'package:numfu/widgets/show_title.dart';

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  UserModel? userModel;
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  File? file;

  @override
  void initState() {
    super.initState();
    findUser();
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
          firstnameController.text = userModel!.cust_firstname;
          lastnameController.text = userModel!.cust_lastname;
          phoneController.text = userModel!.cust_phone;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print('### --> ');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black87,
        ),
        centerTitle: true,
        title: Text(
          'เเก้ไขข้อมูลส่วนตัว',
          style: MyCostant().h2Style(),
        ),
        actions: [
          IconButton(
            onPressed: () => processEditProfileSeller(),
            icon: Icon(
              Icons.edit,
              color: MyCostant.primary,
            ),
            tooltip: 'เเก้ไขข้อมูลส่วนตัว',
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Form(
            key: formKey,
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                buildProfileimg(constraints),
                buildfirstname(constraints),
                buildlastname(constraints),
                buildPhone(constraints),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> processEditProfileSeller() async {
    print('processEditProfileSeller Work');

    MyDialog().showProgressDialog(context);

    if (formKey.currentState!.validate()) {
      if (file == null) {
        print('## User Current Avatar');
        editValueToMySQL(userModel!.profile_picture);
      } else {
        String apiSaveAvatar = '${MyCostant.domain}/customer_save_cust_Img.php';

        List<String> nameAvatars = userModel!.profile_picture.split('/');
        String nameFile = nameAvatars[nameAvatars.length - 1];
        nameFile = 'edit${Random().nextInt(100)}$nameFile';

        print('## User New Avatar nameFile ==>>> $nameFile');

        Map<String, dynamic> map = {};
        map['file'] =
            await MultipartFile.fromFile(file!.path, filename: nameFile);
        FormData formData = FormData.fromMap(map);
        await Dio().post(apiSaveAvatar, data: formData).then((value) {
          print('Upload Succes');
          String pathCustImg = '/CutImg/$nameFile';
          editValueToMySQL(pathCustImg);
        });
      }
    }
  }

  Future<Null> editValueToMySQL(String pathCustImg) async {
    print('## pathCustImg ==> $pathCustImg');
    String apiEditProfile =
        '${MyCostant.domain}/customer_editProfileWhereCustId.php?isAdd=true&cust_id=${userModel!.cust_id}&cust_firstname=${firstnameController.text}&cust_lastname=${lastnameController.text}&profile_picture=$pathCustImg&cust_phone=${phoneController.text}';
    await Dio().get(apiEditProfile).then((value) {
      print('Upload = $value');
      Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  Future<Null> createAvatar({ImageSource? source}) async {
    try {
      var result = await ImagePicker().getImage(
        source: source!,
        maxWidth: 800,
        maxHeight: 800,
      );
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {}
  }

  Row buildProfileimg(BoxConstraints constraints) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            onPressed: () => createAvatar(source: ImageSource.camera),
            icon: Icon(
              Icons.add_a_photo_outlined,
              size: 30,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: constraints.maxWidth * 0.6,
          height: constraints.maxWidth * 0.6,
          child: userModel == null
              ? ShowProgress()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: userModel!.profile_picture == null
                      ? const ShowImage(path: 'img/logo.png')
                      : file == null
                          ? buildShowImageNetwork()
                          : Image.file(file!),
                ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconButton(
            onPressed: () => createAvatar(source: ImageSource.gallery),
            icon: Icon(
              Icons.add_photo_alternate_outlined,
              size: 30,
            ),
          ),
        ),
      ],
    );
  }

  CachedNetworkImage buildShowImageNetwork() {
    return CachedNetworkImage(
      imageUrl: '${MyCostant.domain}${userModel!.profile_picture}',
      placeholder: (context, url) => ShowProgress(),
      errorWidget: (context, url, error) => Icon(
        Icons.person_outline_outlined,
        size: 200,
        color: Colors.grey,
      ),
    );
  }

  Row buildfirstname(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 30),
          width: constraints.maxWidth * 0.9,
          child: TextFormField(
            controller: firstnameController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกชื่อของคุณ';
              } else {}
            },
            maxLength: 255,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelStyle: MyCostant().h3Style(),
              hintStyle: MyCostant().h4d80Style(),
              labelText: 'ชื่อจริง',
              hintText: 'กรุณากรอกชื่อของคุณ',
              contentPadding: EdgeInsets.only(left: 20),
              suffixIcon: Icon(
                Icons.person_outline,
                color: Colors.black,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyCostant.light),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildlastname(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constraints.maxWidth * 0.9,
          child: TextFormField(
            controller: lastnameController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกชื่อร้านค้าของท่าน';
              } else {}
            },
            maxLength: 255,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelStyle: MyCostant().h3Style(),
              hintStyle: MyCostant().h4d80Style(),
              labelText: 'นามสกุล',
              hintText: 'กรุณากรอกนามสกุลของคุณ',
              contentPadding: EdgeInsets.only(left: 20),
              suffixIcon: Icon(
                Icons.person,
                color: Colors.black,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyCostant.light),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildPhone(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 16),
          width: constraints.maxWidth * 0.9,
          child: TextFormField(
            controller: phoneController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอกเบอร์โทรศัพท์ของท่าน';
              } else {}
            },
            maxLength: 10,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelStyle: MyCostant().h3Style(),
              hintStyle: MyCostant().h4d80Style(),
              labelText: 'โทรศัพท์',
              hintText: 'กรุณากรอกเบอร์โทรศัพท์ของคุณ',
              contentPadding: EdgeInsets.only(left: 20),
              suffixIcon: Icon(
                Icons.smartphone_outlined,
                color: Colors.black,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(30),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyCostant.light),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }

  ShowTitle buildTitle(String title) {
    return ShowTitle(
      title: title,
      textStyle: MyCostant().h2Style(),
    );
  }
}
