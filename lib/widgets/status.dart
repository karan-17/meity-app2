import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Status extends StatefulWidget {
  const Status({Key? key}) : super(key: key);

  @override
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> {


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff422E53),
        title: Text('Status'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('Application ID: ${Get.arguments[1]}'),
            Row(
              children: [
                Text('Status: '),
                Text(Get.arguments[0].toString().substring(1,(Get.arguments[0].toString().length - 1))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

