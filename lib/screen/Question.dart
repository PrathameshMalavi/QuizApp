import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

import '../model/TF_Question.dart';

class TFQuestionScreen extends StatefulWidget {

  int val;
  bool newGame;


  TFQuestionScreen({required this.val , required this.newGame});

  @override
  State<StatefulWidget> createState() {
    return _TFQuestionScreenState();
  }
}

class _TFQuestionScreenState extends State<TFQuestionScreen> {
  List<TF_Question> questionList = [];

  List<TF_Question> usersList = [];

  bool? newGame;
  bool? GameExits;
  int? HighScore = 0;


  int currentIndex = 0;

  bool answered = false;

  Color colorBulb = Colors.blueGrey;
  bool nextANim = false;
  bool flag = false;
  bool? ansQuestion;
  bool yourAns = false;
  int currentScore = 0;
  String currentQuestion = "Wait Loading";

  @override
  void initState() {
    newGame = widget.newGame;
    getGameStatus();
    checkHighScore();
    setState(() {
      nextANim = false;
    });
    fetchUsers();
    // Timer(Duration(seconds: 0), () {
    //   print("Timer Print");
    //   print(questionList);
    //   if (questionList != null) {
    //     setState(() {
    //       nextANim = false;
    //       currentIndex = 0;
    //       currentQuestion = questionList[0].question;
    //       ansQuestion = questionList[0].ans;
    //       currentScore = 0;
    //     });
    //   }
    // });
    super.initState();
  }

  @override
  void deactivate() {
    saveGameStatus();
    super.deactivate();
  }

  saveGameStatus(){
    FirebaseFirestore.instance.collection("GameExits").doc(FirebaseAuth.instance.currentUser!.email).update({
      "FactsContinue": true,
    }).then((value) {
    }).onError((error, stackTrace) {});

    FirebaseFirestore.instance.collection("GameCredentialResume").doc(FirebaseAuth.instance.currentUser!.email).collection("Facts").doc("Stats").update({
      "Score" : currentScore,
      "currFacts" : currentIndex,
    }).then((value) {
    }).onError((error, stackTrace) {});
  }


  getGameStatus(){
    FirebaseFirestore.instance
        .collection("GameExits")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get()
        .then((value) {
      if (value.exists) {
        if (value["FactsContinue"] == true) {
          setState(() {
            GameExits = true;
            if(GameExits! && !newGame!){
              getGameDetails();
            }
          });
        }
      }
    });
  }

  getGameDetails(){
    FirebaseFirestore.instance.collection("GameCredentialResume").doc(FirebaseAuth.instance.currentUser!.email).collection("Facts").doc("Stats").get().then((value) {
      if(value.exists){
        setState(() {
          currentIndex = value["currFacts"];
          currentScore = value["Score"];
          if(questionList.length >= currentIndex){
            currentQuestion = questionList[currentIndex].question;
            ansQuestion = questionList[currentIndex].ans;
          }
        });
      }
    },);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Center(
          child: Text("QUIZ APP",
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                  height: 130,
                  width: 130,
                  child: Lottie.asset("assets/animations/Quiz_logo.json",reverse: true,
                      frameRate: FrameRate(16),
                  )),
              Container(height: 10,),
              FittedBox(
                fit: BoxFit.fitHeight,
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10, top: 10, bottom: 10),
                  width: 370,
                  child: Card(
                    color: Colors.blueGrey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 0.0, right: 0, top: 12, bottom: 0),
                          child: Text(
                            "                                                       Question No : ${currentIndex + 1} / ${questionList.length + 1}",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            currentQuestion,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 25.0, right: 25, top: 30, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: flag
                              ? getButtonColorAfterAns(true)
                              : getButtonColor()),
                      onPressed: () {
                        setState(() {
                          flag = true;
                          yourAns = true;
                        });
                      },
                      child: Text("True",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 25,
                              color: Colors.white)),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: flag
                              ? getButtonColorAfterAns(false)
                              : getButtonColor()),
                      onPressed: () {
                        setState(() {
                          flag = true;
                          yourAns = false;
                        });
                      },
                      child: Text("False",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 25,
                              color: Colors.white)),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (nextANim)
                      ? SizedBox(
                          height: 55,
                          width: 55,
                          child: Lottie.asset("assets/animations/next_anim.json",
                              frameRate: FrameRate(3)))
                      : Container(),
                  Container(
                    width: 10,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(backgroundColor: getButtonColor()),
                    onPressed: () {
                      nextQuestion();
                    },
                    child: Text("Next",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 25,
                            color: Colors.white)),
                  ),
                ],
              ),
              Container(
                height: 30,
              ),
              Text(
                getBulbString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Colors.black),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black,
                        width: 2,
                        style: BorderStyle.solid),
                    shape: BoxShape.circle,
                    color: colorBulb,
                  ),
                ),
              ),
              Container(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.blueAccent.shade200,
                ),
                child: Text(
                  "Your Score so far is : ${currentScore}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.black),
                ),
              ),
              Container(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchUsers() async {
    print("FetchQuestion");
    const url =
        "https://raw.githubusercontent.com/curiousily/simple-quiz/master/script/statements.json";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);

    // usersList = new TF_Question.fromJson(json);

    if(!newGame!){
      setState(() {
        currentQuestion = json[currentIndex][0];
        ansQuestion = json[currentIndex][1];
      });
    }else{
      setState(() {
        currentIndex = 0;
        currentQuestion = json[0][0];
        ansQuestion = json[0][1];
      });
    }

    TF_Question question;
    int i = 0;
    do {
      print(json[i].toString());
      question = new TF_Question(question: json[i][0], ans: json[i][1]);
      questionList.add(question);
      i++;
    } while (json[i] != null);

    final jsNew = json as List<dynamic>;
    usersList = jsNew.map((e) {
      print("inside");
      return TF_Question.fromJson(e);
    }).toList();

    print("fetchUsers Completed");
  }

  void onAction() {
    print("Button Print");
    int i = 0;
    while (i < questionList.length) {
      print("${i} " + questionList[i].question);
      print("${i} jS" + usersList[i].question);
      i++;
    }
  }

  MaterialStateProperty<Color?> getButtonColor() {
    return MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.pressed))
        return Colors.black38;
      else if (states.contains(MaterialState.disabled)) return Colors.black87;
      return Colors.black87;
    });
  }

  String getBulbString() {
    setState(() {
      nextANim = true;
      widget.val++;
    });
    if(!answered){
      if (flag) {
        if (ansQuestion == yourAns) {

          setState(() {
            colorBulb = Colors.green;
          });
          checkScore(true);
          answered = true;
          return "Your Answer is Correct";
        } else {
          setState(() {
            colorBulb = Colors.red;
          });
          checkScore(false);
          answered = true;
          return "Your Answer is Wrong";
        }

      }
    }else if(answered){
      return "You already answered this Question go to next";
    }

    return "The Bulb will change Color based on your Ans";

  }

  void nextQuestion() {
    if (flag) {
      setState(() {
        currentIndex++;
        currentQuestion = questionList[currentIndex].question;
        ansQuestion = questionList[currentIndex].ans;
        flag = false;
        nextANim = false;
        answered = false;
        colorBulb = Colors.blueGrey;
        saveGameStatus();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.crisis_alert_rounded),
            Container(
              width: 20,
            ),
            Text("Ans the question first")
          ],
        ),
        duration: Duration(seconds: 3),
        showCloseIcon: false,
      ));
      //
    }
  }

  checkScore(bool ans) {
    if(!answered){
      setState(() {
        if (ans) {
          currentScore = currentScore + 100;
        } else if (!ans && currentScore > 0) {
          currentScore = currentScore - 100;
        }
        if(currentScore > HighScore!){
          setNewHighScore(currentScore);
        }
      });
    }
  }

  checkHighScore(){
    FirebaseFirestore.instance.collection("Scores").doc(FirebaseAuth.instance.currentUser!.email).get().then((value) {
      if(value.exists){
        setState(() {
          HighScore = value["Facts"];
        });
      }
    },);

  }

  setNewHighScore(int s){
    HighScore = s;
    FirebaseFirestore.instance.collection("Scores").doc(FirebaseAuth.instance.currentUser!.email).update({
      "Facts": s,
    }).then((value) {
    }).onError((error, stackTrace) {});

    FirebaseFirestore.instance.collection("LeaderBoard").doc(FirebaseAuth.instance.currentUser!.email).update({
      " Facts " : s,
    }).then((value) {
    }).onError((error, stackTrace) {});
  }




  MaterialStateProperty<Color?> getButtonColorAfterAns(bool currAns) {
    if (ansQuestion == currAns) {
      return MaterialStateProperty.resolveWith((states) => Colors.green);
    } else {
      return MaterialStateProperty.resolveWith((states) => Colors.red);
    }
  }
}
