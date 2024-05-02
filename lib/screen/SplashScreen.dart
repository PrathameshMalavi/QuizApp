import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Login_SIgnUp/CheckUser.dart';
import 'package:flutter_app/Login_SIgnUp/HomeScreen.dart';
import 'package:flutter_app/model/Users.dart';
import 'package:flutter_app/screen/home.dart';
import 'package:lottie/lottie.dart';
import '../model/Users.dart';
import '../Login_SIgnUp/ProfileSreen.dart';
import '../model/Users.dart';
import '../model/Users.dart';
import 'HomeScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  late User user;
  bool isEmailVerified = false;
  bool checkUserRegistration = false;

  bool profileComplete = false;

  @override
  void initState() {
    checkUserRegistration = FirebaseAuth.instance.currentUser != null ? true : false;
    if(checkUserRegistration){
      chechkUserEmailVerified();
      FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser?.email.toString()).get().then((value) {
        profileComplete = value["profileComplete"];
      },);
    }

    Timer(Duration(seconds: 5), () {
      if(checkUserRegistration){
        user = FirebaseAuth.instance.currentUser!;
        if(isEmailVerified){
          if(profileComplete){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
              return NewHome();
            }));
          }else{
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder:
                    (context) =>
                    ProfileScreen(editProfile: true ,email: user.email.toString())
                )
            );
          }
        }else{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
            return CheckUser();
            //return ProfileScreen( editProfile: true, email: user.email.toString());
          }));
        }
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return MyHomePage();
        }));
      }

    });
    super.initState();
  }



  // void showSplashScreen(bool autoNavigation) {
  //   Timer(Duration(seconds: 2), () {
  //     if (checkUserRegistration && autoNavigation) {
  //       Navigation.pushReplacementNavigation(
  //           context, MyHomePage(title: "Main"));
  //     } else if (!checkUserRegistration && !autoNavigation){
  //       Navigation.pushReplacementNavigation(context, LoginScreen());
  //     }
  //   });
  // }

  chechkUserEmailVerified(){
    final user = FirebaseAuth.instance.currentUser;
    isEmailVerified = user!.emailVerified ;
    // if(isEmailVerified){
    //   Navigator.pushReplacement(context,
    //       MaterialPageRoute(builder:
    //           (context) =>
    //           ProfileScreen(editProfile: false,email: user.email.toString())
    //       )
    //   );
    // }else{
    //   user.sendEmailVerification();
    // }
  }
  
  
  @override
  Widget build(BuildContext context) {
    
    
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset("assets/animations/Quiz_Splash.json", reverse: true,
            ),
            Container(height: 25,),
            Text("QUIZ APP", style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                letterSpacing: 7.0,
                fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );
  }
}

