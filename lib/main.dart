import 'package:firebase_core/firebase_core.dart';
import 'package:poly_lingua_app/services/user_controller.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poly_lingua_app/database/database_helper.dart';
import 'package:poly_lingua_app/routes/app_routes.dart';
import 'package:poly_lingua_app/configs/firebase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Database database = await DatabaseHelper.instance.database;
  await Firebase.initializeApp(options: firebaseOptions);
  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final Database database;

  const MyApp({super.key, required this.database});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: BindingsBuilder(() {
        Get.put(UserController());
      }),
      title: 'Poly Lingua App',
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff6750a4)),
        useMaterial3: true,
        dialogTheme: const DialogTheme(
          backgroundColor: Colors.white,
        ),
      ),
      initialRoute: '/signin',
      getPages: getRoutes(database),
      debugShowCheckedModeBanner: false,
    );
  }
}
