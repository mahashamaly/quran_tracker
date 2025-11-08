import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_tracker/presentaion/screens/Admin_home.dart';
import 'package:quran_tracker/presentaion/screens/tutor_home.dart';
import 'package:quran_tracker/presentaion/screens/addStudent.dart';
import 'package:quran_tracker/presentaion/screens/login_Screen.dart';
import 'package:quran_tracker/presentaion/screens/register_screen.dart';
import 'package:quran_tracker/presentaion/screens/routes.dart';
import 'package:quran_tracker/presentaion/screens/splash_Screen.dart';
import 'package:quran_tracker/presentaion/screens/student_home.dart';


void main() {
    WidgetsFlutterBinding.ensureInitialized(); // مهم!

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>TutorsProvider() ,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'تحفيظ',
        theme: ThemeData(
      
        ),
      
      
       initialRoute: Routes.splash,
      
      routes: {
      Routes.splash:(context)=>const SplashScreen(),
      Routes.registerPage:(context)=>const RegisterPage(),
      Routes.login:(context)=>const LoginPage(),
      Routes.teacherHomePage:(context)=>const TutorHomePage (),
      Routes.studentHome:(context)=>const StudentHomePage(),
      Routes.adminHome:(context)=>const AdminHomePage(),
      },
      
      

      
   
      
      
      
      
      ),
    );
  }
}
