// import 'package:driver/utility/app_controller.dart';
// import 'package:driver/utility/app_service.dart';
// import 'package:driver/utility/my_constant.dart';
// import 'package:driver/widgets/show_signout.dart';
// import 'package:driver/widgets/show_titles.dart';
// import 'package:driver/widgets/widget_image_network.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Profile extends StatefulWidget {
//   const Profile({Key? key}) : super(key: key);
//   @override
//   State<Profile> createState() => _ProfileState();
// }

// class _ProfileState extends State<Profile> {
//   @override
//   void initState() {
//     super.initState();
//     AppService().findCurrentUsermodel();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double size = MediaQuery.of(context).size.width;
//     return GetX(builder: (AppController appController) {
//       return Scaffold(
//         floatingActionButton: FloatingActionButton(
//           backgroundColor: MyConstant.primary,
//           child: Icon(Icons.edit),
//           onPressed: () =>
//               Navigator.pushNamed(context, MyConstant.routeEditProfile)
//                   .then((value) => AppService().findCurrentUsermodel()),
//         ),
//         backgroundColor: Colors.white,
//         body: appController.currentUserModels.isEmpty
//             ? const SizedBox()
//             : Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Center(
//                   child: GestureDetector(
//                     onTap: () =>
//                         FocusScope.of(context).requestFocus(FocusNode()),
//                     child: SingleChildScrollView(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           buildImage(size, appController: appController),
//                           buildTextname(appController: appController),
//                           buildTitle('เเก้ไขข้อมูล'),
//                           buildLastName(size, appController: appController),
//                           buildphone(size, appController: appController),
//                           buildAddress(size, appController: appController),
//                           ShowSignOut(),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//       );
//     });
//   }

//   Container buildTitle(String title) {
//     return Container(
//       alignment: Alignment.topLeft,
//       margin: EdgeInsets.only(top: 10),
//       child: ShowTitles(
//         title: title,
//         textStyle: TextStyle(
//           color: Colors.black,
//           fontFamily: "MN MINI Bold",
//           fontSize: 19,
//         ),
//       ),
//     );
//   }

//   Container buildTextname({required AppController appController}) {
//     return Container(
//       margin: EdgeInsets.only(top: 10),
//       child: Text(
//         appController.currentUserModels.last.driver_firstname,
//         style: TextStyle(
//             fontFamily: 'MN MINI', fontSize: 35, color: Color(0xffFF8126)),
//       ),
//     );
//   }

//   Row buildImage(double size, {required AppController appController}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         ClipOval(
//           child: WidgetImageNetwork(
//             url:
//                 '${MyConstant.domain}${appController.currentUserModels.last.profile_image}',
//             height: 130,
//             width: 130,
//             boxFit: BoxFit.cover,
//           ),
//         ),
//       ],
//     );
//   }

//   Row buildLastName(double size, {required AppController appController}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           margin: EdgeInsets.only(top: 10),
//           width: size * 0.9,
//           child: TextFormField(
//             enabled: false,
//             readOnly: true,
//             maxLength: 255,
//             maxLengthEnforcement: MaxLengthEnforcement.enforced,
//             initialValue: appController.currentUserModels.last.driver_lastname,
//             decoration: InputDecoration(
//               enabledBorder: UnderlineInputBorder(
//                 borderSide: BorderSide(
//                     width: 2, color: Color.fromARGB(255, 102, 102, 102)),
//               ),
//               labelStyle: MyConstant().h5Style(),
//               labelText: "นามสกุล",
//               hintText: "กรุณากรอกชื่อร้านของคุณ",
//               suffixIcon: Icon(Icons.person_2_outlined),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Row buildphone(double size, {required AppController appController}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           width: size * 0.9,
//           child: TextFormField(
//             enabled: false,
//             readOnly: true,
//             maxLength: 255,
//             maxLengthEnforcement: MaxLengthEnforcement.enforced,
//             initialValue: appController.currentUserModels.last.driver_telephone,
//             decoration: InputDecoration(
//               enabledBorder: UnderlineInputBorder(
//                 borderSide: BorderSide(
//                     width: 2, color: Color.fromARGB(255, 102, 102, 102)),
//               ),
//               labelStyle: MyConstant().h5Style(),
//               labelText: 'เบอร์โทรศัพท์',
//               suffixIcon: Icon(Icons.smartphone_outlined),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Row buildAddress(double size, {required AppController appController}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           width: size * 0.9,
//           child: TextFormField(
//             enabled: false,
//             readOnly: true,
//             maxLength: 255,
//             maxLengthEnforcement: MaxLengthEnforcement.enforced,
//             initialValue: appController.currentUserModels.last.address,
//             decoration: InputDecoration(
//               enabledBorder: UnderlineInputBorder(
//                 borderSide: BorderSide(
//                     width: 2, color: Color.fromARGB(255, 102, 102, 102)),
//               ),
//               labelStyle: MyConstant().h5Style(),
//               labelText: 'ที่อยู่',
//               suffixIcon: Icon(Icons.house_outlined),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
