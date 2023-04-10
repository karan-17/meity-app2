// import 'package:Flutter-with-Postgresql-using-Models-class-master/database/database.dart';

import '../database/app_database.dart';

class ModelsUsers {
  // Register Model Section
  String futureStudent = '';
  Future<String> registerNewStudent(
      String email, String password, String mobile, String fname, String lname, String aadhar, String avatar, String role, String father_name) async {
    futureStudent = await AppDatabase().registerStudent(email, password, mobile, fname, lname, aadhar, avatar, role, father_name);
    return futureStudent;
  }

  // String futureBuyer = '';
  // Future<String> registerNewBuyer(
  //     String buyerEmail, String password, String fName, String lName) async {
  //   futureBuyer =
  //       await AppDatabase().registerBuyer(buyerEmail, password, fName, lName);
  //   return futureBuyer;
  // }

  /// Login Model Section
  String loginFuture = '';
  Future<String> userLoginModel(String email, String password) async {
    loginFuture = await AppDatabase().loginStudent(email, password);
    return loginFuture;
  }



  //Update student details, email, password, phone, avatar
  String sellerUpdateFuture = '';
  Future<String> updateSellerDetails(String companyFieldValue,
      String fNameFieldValue, String logoValue) async {
    sellerUpdateFuture = await AppDatabase().updateStudent(
        companyFieldValue, fNameFieldValue, logoValue);

    return sellerUpdateFuture;
  }

  // Fetch Student Data

  List<dynamic> studentDataFuture = [];
  Future<List<dynamic>> fetchSellerData(String emailValue) async{
    studentDataFuture = await AppDatabase().fetchStudentData(emailValue);
  return studentDataFuture ;
  }
}
