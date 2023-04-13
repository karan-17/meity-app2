import 'package:postgres/postgres.dart';

class AppDatabase {
  String reg_id = '';
  String email = '';
  String password = '';
  String mobile = '';
  String fname = '';
  String lname = '';
  String aadhar = '';
  String avatar = '';
  String status = '';
  String role = '';
  String father_name = '';
  late DateTime reg_date;
  static String? studentEmailAddress;

  PostgreSQLConnection? connection;
  PostgreSQLResult? newStudentRegisterResult, studentAlreadyRegistered;
  PostgreSQLResult? loginResult, userRegisteredResult;
  PostgreSQLResult? updateStudentResult;
  PostgreSQLResult? _fetchStudentDataResult,_getStudentStatusResult;

  AppDatabase() {
    connection = (connection == null || connection!.isClosed == true
        ? PostgreSQLConnection(
      // for external device like mobile phone use domain.com or
      // your computer machine IP address (i.e,192.168.0.1,etc)
      // when using AVD add this IP 10.0.2.2
      '10.0.2.2',
      5400,
      'students',
      username: 'sup_admin',
      password: 'karan',
      timeoutInSeconds: 30,
      queryTimeoutInSeconds: 30,
      timeZone: 'UTC',
      useSSL: false,
      isUnixSocket: false,
    )
        : connection);
  }

  String newStudentFuture = '';

  Future<String> registerStudent(String email, String password,
      String mobile,String fname, String lname, String aadhar, String avatar, String role, String father_name) async {
    try {
      await connection!.open();
      await connection!.transaction((newStudentConn) async {
        //Stage 1 : Make sure email or mobile not registered.
        studentAlreadyRegistered = await newStudentConn.query(
          'select * from myAppData.student where email = @email OR mobile = @mobile',
          substitutionValues: {'email': email, 'mobile': mobile},
          allowReuse: true,
          timeoutInSeconds: 30,
        );
        if (studentAlreadyRegistered!.affectedRowCount > 0) {
          newStudentFuture = 'alr';
        } else {
          //Stage 2 : If user not already registered then we start the registration
          newStudentRegisterResult = await newStudentConn.query(
            'insert into myAppData.student(reg_id, fname, lname, email,password,mobile,register_date, father_name, aadhar,role, avatar) '
                'values(@reg_id, @fname, @lname, @email ,@password,@mobile,@register_date, @father_name, @aadhar,@role,@avatar )',
            substitutionValues: {
              'reg_id': 'STU${DateTime
                  .now()
                  .millisecondsSinceEpoch}',
              'fname': fname,
              'lname': lname,
              'father_name': father_name,
              'aadhar': aadhar,
              'avatar': avatar,
              'email': email,
              'password': password,
              'mobile': mobile,
              // 'status': 'under process',
              'role': 'STUDENT',
              'register_date': DateTime.now(),
            },
            allowReuse: true,
            timeoutInSeconds: 30,
          );
          newStudentFuture =
          (newStudentRegisterResult!.affectedRowCount > 0 ? 'reg' : 'nop');
        }
      });
    } catch (exc) {
      newStudentFuture = 'exc';
      exc.toString();
    }
    return newStudentFuture;
  }

  Future<String> loginStudent(String email, String password) async {
    try {
      await connection!.open();
      await connection!.transaction((loginConn) async {
        loginResult = await loginConn.query(
          'select * from myAppData.student where email = @email and password = @password',
          substitutionValues: {'email': email, 'password': password},
          allowReuse: true,
          timeoutInSeconds: 30,
        );
        if (loginResult!.affectedRowCount > 0) {
          studentEmailAddress = email;
          userRegisteredResult = await loginConn.query(
            'select * from myAppData.student where email = @email',
            substitutionValues: {'email': email},
            allowReuse: true,
            timeoutInSeconds: 30,
          );
          if (userRegisteredResult!.affectedRowCount > 0) {
            newStudentFuture = 'log';
          } else {
            newStudentFuture = 'nop';
          }
        } else {
          newStudentFuture = 'nop';
        }
      });
    } catch (exc) {
      newStudentFuture = 'exc';
      exc.toString();
    }
    return newStudentFuture;
  }

  Future<String> updateStudent(String email, String password,
      String mobile) async {
    try {
      await connection!.open();
      await connection!.transaction((updateStudentConn) async {
        updateStudentResult = await updateStudentConn.query(
          'update myAppData.student set password = @password, mobile = @mobile where email = @email',
          substitutionValues: {
            'email': email,
            'password': password,
            'mobile': mobile,
          },
          allowReuse: true,
          timeoutInSeconds: 30,
        );
        newStudentFuture =
        (updateStudentResult!.affectedRowCount > 0 ? 'upd' : 'nop');
      });
    } catch (exc) {
      newStudentFuture = 'exc';
      exc.toString();
    }
    return newStudentFuture;
  }

//  Update Student Record
  Future<String> updateStudentRecord(String reg_id, String fname, String lname,
      String father_name, String aadhar, String avatar) async {
    try {
      await connection!.open();
      await connection!.transaction((updateStudentRecordConn) async {
        updateStudentResult = await updateStudentRecordConn.query(
          'update myAppData.student set fname = @fname, lname = @lname, father_name = @father_name, aadhar = @aadhar, avatar = @avatar where reg_id = @reg_id',
          substitutionValues: {
            'reg_id': reg_id,
            'fname': fname,
            'lname': lname,
            'father_name': father_name,
            'aadhar': aadhar,
            'avatar': avatar,
          },
          allowReuse: true,
          timeoutInSeconds: 30,
        );
        newStudentFuture =
        (updateStudentResult!.affectedRowCount > 0 ? 'upd' : 'nop');
      });
    } catch (exc) {
      newStudentFuture = 'exc';
      exc.toString();
    }
    return newStudentFuture;
  }

  List<dynamic> fetchDataFuture = [];
  Future<List> fetchStudentData(String email) async {
    try {
      await connection!.open();
      await connection!.transaction((fetchStudentDataConn) async {
        _fetchStudentDataResult = await fetchStudentDataConn.query(
          'select * from myAppData.student where email = @email',
          substitutionValues: {'email': email},
          allowReuse: true,
          timeoutInSeconds: 30,
        );
        if (_fetchStudentDataResult!.affectedRowCount > 0) {
          fetchDataFuture = _fetchStudentDataResult!.first.toList(growable: true);
          // reg_id = _fetchStudentDataResult!.first['reg_id'];
          // email = _fetchStudentDataResult!.first['email'];
          // password = _fetchStudentDataResult!.first['password'];
          // mobile = _fetchStudentDataResult!.first['mobile'];
          // fname = _fetchStudentDataResult!.first['fname'];
          // lname = _fetchStudentDataResult!.first['lname'];
          // father_name = _fetchStudentDataResult!.first['father_name'];
          // aadhar = _fetchStudentDataResult!.first['aadhar'];
          // avatar = _fetchStudentDataResult!.first['avatar'];
          // status = _fetchStudentDataResult!.first['status'];
          // role = _fetchStudentDataResult!.first['role'];
          // reg_date = _fetchStudentDataResult!.first['register_date'];
          newStudentFuture = 'fet';
        } else {
          fetchDataFuture = [];
          newStudentFuture = 'nop';
        }
      });
    } catch (exc) {
      newStudentFuture = 'exc';
      exc.toString();
    }
    return fetchDataFuture;
  }

//  Get status column of student using reg_id
String fetchStatus = '';
  Future<String> getStudentStatus(String reg_id) async {
    try {
      await connection!.open();
      await connection!.transaction((getStudentStatusConn) async {
        _getStudentStatusResult = await getStudentStatusConn.query(
          'select status from myAppData.student where reg_id = @reg_id',
          substitutionValues: {'reg_id': reg_id},
          allowReuse: true,
          timeoutInSeconds: 30,
        );
        if (_getStudentStatusResult!.affectedRowCount > 0) {
          fetchStatus = _getStudentStatusResult!.first.toString();
          // print(fetchStatus.toString().substring(1,(fetchStatus.toString().length - 1)));
          newStudentFuture = 'fet';
        } else {
          fetchStatus = '_Application Not Submitted_';
          newStudentFuture = 'nop';
        }
      });
    } catch (exc) {
      newStudentFuture = 'exc';
      fetchStatus = '_Something Went Wrong, try again later_';
      exc.toString();
    }
    // print(fetchStatus.toString());
    print(newStudentFuture);
    return fetchStatus;
  }
}

// Old Code Commented
// class AppDatabase {
//   String buyerEmailValue = '';
//   String sellerEmailValue = '';
//   String passwordValue = '';
//   String mobileValue = '';
//   String companyNameValue = '';
//   String landlineValue = '';
//   String fNameValue = '';
//   String lNameValue = '';
//
//   PostgreSQLConnection? connection;
//   PostgreSQLResult? newSellerRegisterResult, newBuyerRegisterResult;
//   PostgreSQLResult? sellerAlreadyRegistered, buyerAlreadyRegistered;
//
//   PostgreSQLResult? loginResult, userRegisteredResult;
//
//   PostgreSQLResult? updateBuyerResult;
//   PostgreSQLResult? updateSellerResult;
//
//   static String? sellerEmailAddress, buyerEmailAddress;
//
//   PostgreSQLResult? _fetchSellerDataResult;
//
//   AppDatabase() {
//     connection = (connection == null || connection!.isClosed == true
//         ? PostgreSQLConnection(
//             // for external device like mobile phone use domain.com or
//             // your computer machine IP address (i.e,192.168.0.1,etc)
//             // when using AVD add this IP 10.0.2.2
//             '10.0.2.2',
//             5400,
//             'students',
//             username: 'sup_admin',
//             password: 'karan',
//             timeoutInSeconds: 30,
//             queryTimeoutInSeconds: 30,
//             timeZone: 'UTC',
//             useSSL: false,
//             isUnixSocket: false,
//           )
//         : connection);
//
//     fetchDataFuture = [];
//   }
//
//   //Login Database Section
//   String userLoginFuture = '';
//   Future<String> loginUser(String email, String password) async {
//     try {
//       await connection!.open();
//       await connection!.transaction((loginConn) async {
//         //Step 1 : Check email registered or no
//         loginResult = await loginConn.query(
//           'select emailDB,passDB,isSellerDB from myAppData.register where emailDB = @emailValue order by idDB',
//           substitutionValues: {'emailValue': email},
//           allowReuse: true,
//           timeoutInSeconds: 30,
//         );
//         if (loginResult!.affectedRowCount > 0) {
//           // Usually we check if account expired or no ...but I will
//           // not add the code and skip here to simplify things
//           // We will check the entered credentials..and decide
//           // weather the user is a buyer or seller
//
//           sellerEmailAddress = loginResult!.first
//               .elementAt(0); //This to use when update seller details
//
//           if (loginResult!.first.elementAt(1).contains(password) == true &&
//               loginResult!.first.elementAt(2) == true) {
//             userLoginFuture = 'sel';
//           } else if (loginResult!.first.elementAt(1).contains(password) ==
//                   true &&
//               loginResult!.first.elementAt(2) == false) {
//             userLoginFuture = 'buy';
//           } else if (loginResult!.first.elementAt(1).contains(password) ==
//               false) {
//             userLoginFuture = 'fai';
//           } else {
//             userLoginFuture = 'exc';
//           }
//         } else {
//           userLoginFuture = 'not';
//         }
//       });
//     } catch (exc) {
//       userLoginFuture = 'exc';
//       exc.toString();
//     }
//     return userLoginFuture;
//   }
//
//   //Update Database Section
//   String futureBuyerUpdate = '';
//   Future<String> updateBuyerData(int ssn, String mobile) async {
//     try {
//       await connection!.open();
//       await connection!.transaction((updateBuyerConn) async {
//         print('update buyer');
//         // Mobile column in DB is unique..so we check the buyer mobile first
//         PostgreSQLResult checkBuyerMobile = await updateBuyerConn.query(
//           'select mobileDB from myAppData.register where mobileDB = @mobileValue',
//           substitutionValues: {'mobileValue': mobile},
//           allowReuse: false,
//           timeoutInSeconds: 30,
//         );
//         if (checkBuyerMobile.affectedRowCount > 0) {
//           futureBuyerUpdate = 'alr';
//         } else {
//           //If check fails ..then we update buyer data
//           updateBuyerResult = await updateBuyerConn.query(
//             'update myAppData.register set SSN_DB = @ssnValue, mobileDB = @mobileValue where emailDB = @emailValue',
//             substitutionValues: {
//               'ssnValue': ssn,
//               'mobileValue': mobile,
//               'emailValue': AppDatabase.sellerEmailAddress,
//             },
//             allowReuse: false,
//             timeoutInSeconds: 30,
//           );
//           print('update buyer 1');
//           futureBuyerUpdate =
//               (updateBuyerResult!.affectedRowCount > 0 ? 'upd' : 'nop');
//         }
//       });
//     } catch (exc) {
//       futureBuyerUpdate = 'exc';
//       exc.toString();
//     }
//     return futureBuyerUpdate;
//   }
//
//   String sellerDetailsFuture = '';
//   Future<String> updateSellerData(
//       String companyNameValue, String fNameValue, String logoImage) async {
//     try {
//       await connection!.open();
//       await connection!.transaction((sellerUpdateConn) async {
//         updateSellerResult = await sellerUpdateConn.query(
//           'update myAppData.register set companyDB = @companyValue , fNameDB = @fNameValue , avatar = @avatarValue where emailDB = @emailValue',
//           substitutionValues: {
//             'companyValue': companyNameValue,
//             'fNameValue': fNameValue,
//             'avatarValue': logoImage,
//             'emailValue': AppDatabase.sellerEmailAddress,
//           },
//           allowReuse: false,
//           timeoutInSeconds: 30,
//         );
//         sellerDetailsFuture =
//             (updateSellerResult!.affectedRowCount > 0 ? 'upd' : 'not');
//       });
//     } catch (exc) {
//       sellerDetailsFuture = 'exc';
//       exc.toString();
//     }
//     return sellerDetailsFuture;
//   }
//
//   // Fetch Data Section
//   //Retrieve User Information
//   List<dynamic> fetchDataFuture = [];
//   Future<List<dynamic>> fetchSellerData(String emailText) async {
//     try {
//       await connection!.open();
//       await connection!.transaction((fetchDataConn) async {
//         _fetchSellerDataResult = await fetchDataConn.query(
//           'select companydb,emaildb,fnamedb,mobiledb,avatar from myAppData.register where emailDB = @emailValue order by idDB',
//           substitutionValues: {'emailValue': emailText},
//           allowReuse: false,
//           timeoutInSeconds: 30,
//         );
//         if (_fetchSellerDataResult!.affectedRowCount > 0) {
//           fetchDataFuture = _fetchSellerDataResult!.first.toList(growable: true);
//         } else {
//           fetchDataFuture = [];
//         }
//       });
//     } catch (exc) {
//       fetchDataFuture = [];
//       exc.toString();
//     }
//
//     return fetchDataFuture;
//   }
// }
