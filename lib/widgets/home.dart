import 'package:flutter/material.dart';
import 'package:flutter_db/database/app_database.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    //application ID text field
    final _appController = TextEditingController().obs;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff422E53),
        title: Text('Home'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                controller: _appController.value,
                decoration: InputDecoration(
                  labelText: 'Application ID',
                  hintText: 'Enter your Application ID',
                  focusColor: Color(0xff422E53),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(
                      color: Color(0xff422E53),
                      style: BorderStyle.solid,
                      width: 2.0,
                    ),
                  ),
                ),
      ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff422E53),
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onPressed:()async{
                  if(_appController.value.text.isEmpty){
                    Get.snackbar(
                      'Error',
                      'Application ID cannot be empty',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                  else{
                    AppDatabase db = AppDatabase();
                    CircularProgressIndicator();
                    String status = await db.getStudentStatus(_appController.value.text);
                    print('Status: $status');
                    Get.toNamed('/status', arguments: [status, _appController.value.text]);
                  }
                  // AppDatabase db = AppDatabase();
                  // CircularProgressIndicator();
                  // String status = await db.getStudentStatus(_appController.value.text);
                  // print('Status: $status');
                  // Get.toNamed('/status', arguments: [status, _appController.value.text]);
                }, child: Text('Check Status'),
              )
            ],
          ),
        ),
    )
    );
  }
}
