

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Login_SIgnUp/CheckUser.dart';
import '../screen/HomeScreen.dart';
import 'ForgotPassword.dart';
import 'package:flutter_app/UiWidgets/UiHelper.dart';

import 'ProfileSreen.dart';
import 'SignUp.dart';

class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController emailControler = TextEditingController();
  TextEditingController passController = TextEditingController();

  LogIn(String email , String password) async {
    print("Authentication Sign Up");
    if(email == "" && password== ""){
      UiHelper.CustomAlertBox(context, "Enter Required Fields");
    }else{
      //it can be null
      UserCredential? userCredential;
      try{
        userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value) {
          print("Uid " + value.user!.uid);
          bool profileComplete = false;
          FirebaseFirestore.instance.collection("Users").doc(value.user!.email).get().then((value){
            profileComplete = value["profileComplete"];
          });
          if(value.user!.emailVerified){
            if(profileComplete){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                return NewHome();
              }));
            }else{
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder:
                      (context) =>
                      ProfileScreen(editProfile: true ,email: value.user!.email.toString())
                  )
              );
            }
          }else{
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
              return CheckUser();
              //return ProfileScreen( editProfile: true, email: user.email.toString());
            }));
          }
        });
      } on FirebaseAuthException catch(ex){
        UiHelper.CustomAlertBox(context, ex.code.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: UiHelper.CustomAppBar("Login Page"),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 75,
            ),
            UiHelper.CustomTextField(emailControler, "Email", Icons.mail, false),

            UiHelper.CustomTextField(passController, "Password", Icons.password, true),
            Container(
              height: 50,
            ),
            UiHelper.CustomButton(() {
              LogIn(emailControler.text.toString(), passController.text.toString());
            }, "Login"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Dont Have an Account",  style: TextStyle(fontSize: 16 , fontWeight: FontWeight.w400)),
                TextButton(onPressed: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Signup(),));
                }, child: Text("Sign Up" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w500),))
              ],
            ),
            SizedBox(height: 1,),
            TextButton(onPressed: (){
              print("Inside Email");
              String email;
              if(EmailValidator.validate(emailControler.text.toString())){
                email = emailControler.text.toString();
                print("Correct Email");
              }else{
                email = "";
                print("inCorrect Email");
              }
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ForgotPassword.mail(email),));
            }, child: Text("Forgot Password" , style: TextStyle(fontSize: 15 , fontWeight: FontWeight.w500),))
          ],
        ),
      ),
    );
  }
}