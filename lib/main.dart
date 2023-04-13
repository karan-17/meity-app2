import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widgets/home.dart';
import 'widgets/status.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyAppDesign();
  }
}

class MyAppDesign extends StatelessWidget {
  const MyAppDesign({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      color: Color(0xff422E53),
      initialRoute: '/',
      routes: {
        '/':(context)=> Home(),
        '/status':(context)=> Status(),
        // '/login':(context)=> Login(),
        // "/register":(context)=> Register(),
        // "/buyerAccount":(context)=> BuyerAccount(),
        // "/sellerAccount":(context)=> SellerAccount(),
        // '/sellerShop':(context)=> SellerShop(),
      },
    );
  }
}
