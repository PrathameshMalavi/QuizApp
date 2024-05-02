import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class YourHighScore extends StatefulWidget {
  const YourHighScore({super.key});

  @override
  State<YourHighScore> createState() => _YourHighScoreState();
}

class _YourHighScoreState extends State<YourHighScore> {

  int? factHighScore;
  int? quizHighScore;

  @override
  void initState() {
    getUserHighScore();
    // TODO: implement initState
    super.initState();
  }

  getUserHighScore(){
    FirebaseFirestore.instance.collection("Scores").doc(FirebaseAuth.instance.currentUser!.email).get().then((value) {
      if(value.exists){
        setState(() {
          quizHighScore = value["Quiz"];
        });
      }
    },);
    FirebaseFirestore.instance.collection("Scores").doc(FirebaseAuth.instance.currentUser!.email).get().then((value) {
      if(value.exists){
        setState(() {
          factHighScore = value["Facts"];
        });
      }
    },);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: 800,
          child: Column(
            children: [
              Container(
                height: 0,
              ),
              SizedBox(
                  height: 400,
                  width: 400,
                  child: Lottie.asset(
                    "assets/animations/highScore_anim.json",
                    reverse: true,
                    frameRate: FrameRate(16),
                  )),
              Container(height: 0,),
              Padding(
                padding: EdgeInsets.only(
                    top: 5, left: 10, right: 10, bottom: 0),
                child: TextField(
                  enabled: false,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2
                    ),
                    hintText: "Facts Game HighScore",
                  ),
                ),
              ),
              Padding(
                padding:
                EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 0),
                child: ElevatedButton(
                  child: Text(
                      "** " + factHighScore.toString() + " **",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  onPressed: () {
                  },
                  style: ButtonStyle(backgroundColor:
                  MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.hovered)) {
                      return Colors.red;
                    } else if (states.contains(MaterialState.pressed)) {
                      return Colors.blueAccent;
                    }
                    return Colors.cyanAccent.shade100;
                  })),
                ),
              ),
              Container(height: 15,),
              Padding(
                padding: EdgeInsets.only(
                    top: 10, left: 10, right: 10, bottom: 0),
                child: TextField(
                  enabled: false,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2
                    ),
                    hintText: "Quiz Game HighScore",
                  ),
                ),
              ),
              Padding(
                padding:
                EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 0),
                child: ElevatedButton(
                  child: Text(
                    "** " + quizHighScore.toString() + " **",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  onPressed: () {
                  },
                  style: ButtonStyle(backgroundColor:
                  MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.hovered)) {
                      return Colors.red;
                    } else if (states.contains(MaterialState.pressed)) {
                      return Colors.blueAccent;
                    }
                    return Colors.cyanAccent.shade100;
                  })),
                ),
              ),
              Container(height: 10,),
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: Text("Do Play and increase your Score to be in LeaderBoard 🙄 " , textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,fontWeight: FontWeight.w500 , fontSize: 16
                  ),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
