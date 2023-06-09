import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyCostant {
  // general
  static String appName = 'Numfu';
  static String domain = 'https://www.androidthai.in.th/edumall';
  // Route
  static String routelogin = '/login';
  static String routeregister = '/register';
  static String routeOTP = '/OTP';
  static String routeOTP2 = '/OTP2';
  static String routeforgetpass = '/forgetpass';
  static String routeluncher = '/Launcher';
  static String routeEditProfile = '/EditProfile';

  static String google_api_key = "AIzaSyCiynXi8jsk-9TnZ77fQXoZUaFV_LKVTtI";

  // Image
  static String logo = 'img/logo.png';

  // Color
  static Color primary = Color(0xffff8126);
  static Color pritwo = Color(0xffFFC077);
  static Color dark = Color(0xff757575);
  static Color dark2 = Color.fromARGB(8, 215, 223, 207);
  static Color light = Color(0xffffb257);
  static Color black = Color(0xff000000);
  static Color white = Color(0xffffffff);
  static Color red = Color(0xffFF3326);
  static Color pri = Color(0xffC55200);
  static Color star = Color(0xffFFD233);
  static Color dark80 = Color(0xff666666);

  // Style
  TextStyle h1Style() => TextStyle(
        fontSize: 36,
        color: black,
        fontWeight: FontWeight.normal,
      );
  TextStyle h1pStyle() => TextStyle(
        fontSize: 36,
        color: primary,
        fontWeight: FontWeight.normal,
      );

  TextStyle h1tStyle() => TextStyle(
        fontSize: 36,
        color: black,
        fontWeight: FontWeight.normal,
      );

  TextStyle h2Style() => TextStyle(
        fontSize: 25,
        color: black,
        fontWeight: FontWeight.normal,
      );
  TextStyle h2wStyle() => TextStyle(
        fontSize: 25,
        color: white,
        fontWeight: FontWeight.normal,
      );
  TextStyle h2d80Style() => TextStyle(
        fontSize: 25,
        color: dark80,
        fontWeight: FontWeight.normal,
      );
  TextStyle h3Style() => TextStyle(
        fontSize: 18,
        color: black,
        fontWeight: FontWeight.normal,
      );
  TextStyle h3_1Style() => TextStyle(
        fontSize: 18,
        color: primary,
        fontWeight: FontWeight.normal,
      );
  TextStyle h3d80Style() => TextStyle(
        fontSize: 18,
        color: dark80,
        fontWeight: FontWeight.normal,
      );
  TextStyle h4Style() => TextStyle(
        fontSize: 16,
        color: dark,
        fontWeight: FontWeight.normal,
      );
  TextStyle h4d80Style() => TextStyle(
        fontSize: 16,
        color: dark80,
        fontWeight: FontWeight.normal,
      );
  TextStyle h4wStyle() => TextStyle(
        fontSize: 16,
        color: white,
        fontWeight: FontWeight.normal,
      );
  TextStyle h4pStyle() => TextStyle(
        fontSize: 16,
        color: primary,
        fontWeight: FontWeight.normal,
      );
  TextStyle h44Style() => TextStyle(
        fontSize: 18,
        color: dark,
        fontWeight: FontWeight.normal,
      );
  TextStyle headStyle() => TextStyle(
        fontSize: 36,
        color: black,
      );

  TextStyle h5button() => TextStyle(
        fontSize: 20,
        color: white,
        fontWeight: FontWeight.normal,
      );
  TextStyle h6button() => TextStyle(
        fontSize: 20,
        color: dark,
        fontWeight: FontWeight.normal,
      );
  TextStyle h6_1button() => TextStyle(
        fontSize: 20,
        color: white,
        fontWeight: FontWeight.normal,
      );
  TextStyle h6_2button() => TextStyle(
        fontSize: 20,
        color: black,
        fontWeight: FontWeight.normal,
      );
  TextStyle h6_3button() => TextStyle(
        fontSize: 18,
        color: dark,
        fontWeight: FontWeight.normal,
      );
  TextStyle h7button() => TextStyle(
        fontSize: 20,
        color: pri,
        fontWeight: FontWeight.normal,
      );

  // Button
  ButtonStyle myButtonStyle() => ElevatedButton.styleFrom(
        primary: MyCostant.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      );

  ButtonStyle mySignoutButtonStyle() => ElevatedButton.styleFrom(
        primary: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      );
}
