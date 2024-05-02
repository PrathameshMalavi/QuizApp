import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Login_SIgnUp/ProfileSreen.dart';
import 'package:flutter_app/Login_SIgnUp/SignUp.dart';
import 'package:flutter_app/UiWidgets/UiHelper.dart';
import 'package:flutter_app/screen/home.dart';

import '../Util/UtilityMethods.dart';
import 'HomeScreen.dart';

class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {

  bool isEmailVerified = false;

  @override
  void initState() {
    chechkUserEmailVerified();
    // Timer.periodic(Duration(seconds: 2), (timer) {
    //   if(FirebaseAuth.instance.currentUser!.emailVerified){
    //     Navigation.pushReplacementNavigation(context, ProfileScreen( editProfile: true, email: FirebaseAuth.instance.currentUser!.email.toString()));
    //   }
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent.shade100,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("A Verification Email has Been Sent to You Please Verify Your Email 🙄 \n If Verified then Login " , textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,fontWeight: FontWeight.w500 , fontSize: 16
              ),),
              Container(height: 15,),
              // Container(
              //   padding: const EdgeInsets.all(10.0),
              //   child: UiHelper.CustomButton(() {
              //     chechkUserEmailVerified();
              //   }, "Email Verified"),
              // ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: UiHelper.CustomButton(() {
                  chechkUserEmailVerified();
                }, "Resend Verification Email"),
              ),
              Container(
                padding: const EdgeInsets.all(15.0),
                child: UiHelper.CustomButton(() {
                  UiHelper.Customavigator(context, MyHomePage());
                }, "Login"),
              )
            ],
          ),
        ),
      ),
    );
  }

  //for direct below one is for splashscreen no need of scaffold directly return on build method
  // chechkUser(){
  //   final user = FirebaseAuth.instance.currentUser;
  //   if(user != null){
  //     return Test();
  //   }else{
  //     return MyHomePage();
  //   }
  // }

  //for  splashscreen
  chechkUserEmailVerified(){
    final user = FirebaseAuth.instance.currentUser;
    isEmailVerified = user!.emailVerified ;
    if(user.emailVerified){
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder:
              (context) =>
              ProfileScreen(editProfile: true ,email: user.email.toString())
          )
      );
    }else{
      user.sendEmailVerification().whenComplete(() {
        if(user.emailVerified){
        }
      },);
    }
  }


}
