import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/UiWidgets/UiHelper.dart';

import 'HomeScreen.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword.mail(String this.emailFromPrev);

  ForgotPassword({super.key});

  String emailFromPrev = "";

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  void initState() {
    // TODO: implement initState
    if (widget.emailFromPrev == "") {
      changeEmail = true;
    }else{
      changeEmail = false;
    }
    super.initState();
  }

  bool changeEmail = true;
  TextEditingController emailController = TextEditingController();

  forgotPassword(String email)async{
    if(email == ""){
      setState(() {
        changeEmail = true;
      });
      return UiHelper.CustomAlertBox(context, "Enter an email to Reset Password");
    }else{
      FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value) {
        UiHelper.Customavigator(context, MyHomePage());
      });
    }
  }

  checkMail() {
    if (widget.emailFromPrev == "" || changeEmail == true) {
      return UiHelper.CustomTextField(
          emailController, "Email", Icons.email, false);
    } else {
      return Text("Is this your email ${widget.emailFromPrev}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),);
    }
  }

  changeEmailButton(){
    if(changeEmail == false){
      return TextButton(
          onPressed: () {
            setState(() {
              changeEmail = true;
            });
          },
          child: Text(
            "Change Email",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ));
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UiHelper.CustomAppBar("Forgot Password"),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          checkMail(),
          SizedBox(
            height: 20,
          ),
          UiHelper.CustomButton(() {
            if(changeEmail){
              forgotPassword(emailController.text.toString());
            }else{
              forgotPassword(widget.emailFromPrev);
            }
          }, "Forgot Password"),
          changeEmailButton(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Remenber Your Password",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyHomePage(),
                        ));
                  },
                  child: Text(
                    "Login In",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ))
            ],
          )
        ],
      ),
    );
  }
}
