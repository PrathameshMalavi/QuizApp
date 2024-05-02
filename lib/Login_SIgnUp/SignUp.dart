
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Login_SIgnUp/CheckUser.dart';
import 'package:flutter_app/screen/HomeScreen.dart';
import 'package:flutter_app/screen/home.dart';
import '../UiWidgets/UiHelper.dart';
import 'HomeScreen.dart';

class Signup extends StatefulWidget {

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController emailControler = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmpassController = TextEditingController();



  signUp(String email , String password ,String confirmPassword) async {
    print("Authentication Sign Up");
    if(email == "" && password== ""){
      UiHelper.CustomAlertBox(context, "Enter Required Fields");
    }else if(password != confirmPassword){
      UiHelper.CustomAlertBox(context, "Your Password dont match");
    }
    else{
      //it can be null
      UserCredential? userCredential;
      try{
        userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((value) {
          print("Uid " + value.user!.uid);
          FirebaseFirestore.instance.collection("Users").doc(value.user?.email).set({
            "profileComplete" : false
          });
          if(value.user!.emailVerified){
            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) {
              return NewHome();
            },));
          }else{
            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) {
              return CheckUser();
            },));
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
        appBar: UiHelper.CustomAppBar("Sign Up Page"),
        body:SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 75,
              ),
              UiHelper.CustomTextField(emailControler, "Email", Icons.mail, false),

              UiHelper.CustomTextField(passController, "Password", Icons.password, true),

              UiHelper.CustomTextField(confirmpassController, "Confirm Password", Icons.password, true),
              Container(
                height: 50,
              ),
              UiHelper.CustomButton( (){
                String email;
                if(EmailValidator.validate(emailControler.text.toString())){
                  email = emailControler.text.toString();
                  print("Correct Email");
                }else{
                  email = "";
                  print("inCorrect Email");
                }

                signUp(emailControler.text.toString() , passController.text.toString() , confirmpassController.text.toString());
              }, "Sign Up"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an Account",  style: TextStyle(fontSize: 16 , fontWeight: FontWeight.w400)),
                  TextButton(onPressed: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage(),));
                  }, child: Text("Login" , style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w500),))
                ],
              )
            ],
          ),
        ),
    );
  }
}