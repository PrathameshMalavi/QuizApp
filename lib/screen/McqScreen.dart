import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';

import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

import '../model/MultipleChoiceQuestion.dart';
import '../model/TF_Question.dart';

class McqScreen extends StatefulWidget {


  bool newGame;

  McqScreen({super.key , required this.newGame});

  @override
  State<McqScreen> createState(){
    return _McqScreenState();
  }
}

class _McqScreenState extends State<McqScreen> {
  List<MultipleChoiceQuestion> mcq = [];

  bool? newGame;
  bool? GameExits;
  int? HighScore = 0;



  bool optionSelected = false;
  int currentIndex = 0;
  String currentQuestion = "Wait Loading";
  String optionA = "Wait Loading";
  String optionB = "Wait Loading";
  String optionC = "Wait Loading";
  String optionD = "Wait Loading";
  String correctAns = "Wait Loading";

  bool checkselection = false;

  String yourAns = "Null";
  bool isAnsCorrect = false;
  Color ansColor = Colors.cyanAccent;
  String animationUrl = "assets/animations/Quiz_logo.json";

  int currentScore = 0;

  bool nextANim = false;




  @override
  void initState() {
    newGame = widget.newGame;
    getGameStatus();
    checkHighScore();
    fetchQuestion();
    setState(() {
      optionSelected = false;
      nextANim = false;
    });
    // Timer(Duration(seconds: 2), () {
    //   print(mcq.length);
    //   print(mcq[1].ansOption + " : " + mcq[1].correctAns);
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
      "QuizContinue": true,
    }).then((value) {
    }).onError((error, stackTrace) {});

    FirebaseFirestore.instance.collection("GameCredentialResume").doc(FirebaseAuth.instance.currentUser!.email).collection("Quiz").doc("Stats").update({
      "Score" : currentScore,
      "currQuiz" : currentIndex,
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
        if (value["QuizContinue"] == true) {
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
    FirebaseFirestore.instance.collection("GameCredentialResume").doc(FirebaseAuth.instance.currentUser!.email).collection("Quiz").doc("Stats").get().then((value) {
      if(value.exists){
        setState(() {
          currentIndex = value["currQuiz"];
          currentScore = value["Score"];
          if(mcq.length >= currentIndex){
            currentQuestion = mcq[currentIndex].question;
            optionA = mcq[currentIndex].A;
            optionB = mcq[currentIndex].B;
            optionC = mcq[currentIndex].C;
            optionD = mcq[currentIndex].D;
            correctAns = MultipleChoiceQuestion.getStringFromOption(
                mcq[currentIndex].ansOption, optionA, optionB, optionC, optionD);
          }
        });
      }
    },);
  }


  fetchQuestion() async {
    String url =
        "https://gist.githubusercontent.com/cmota/f7919cd962a061126effb2d7118bec72/raw/96ae8cbebd92c97dfbe53ad8927a45a28f8d2358/questions.json";
    Uri uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);

    if(!newGame!){
      setState(() {
        currentQuestion = json[currentIndex]["question"];
        optionA = json[currentIndex]["A"];
        optionB = json[currentIndex]["B"];
        optionC = json[currentIndex]["C"];
        optionD = json[currentIndex]["D"];
        correctAns = MultipleChoiceQuestion.getStringFromOption(
            json[currentIndex]["answer"], optionA, optionB, optionC, optionD);
      });
    }else{
      setState(() {
        currentIndex = 0;
        currentQuestion = json[currentIndex]["question"];
        optionA = json[currentIndex]["A"];
        optionB = json[currentIndex]["B"];
        optionC = json[currentIndex]["C"];
        optionD = json[currentIndex]["D"];
        correctAns = MultipleChoiceQuestion.getStringFromOption(
            json[currentIndex]["answer"], optionA, optionB, optionC, optionD);
      });
    }


    //print(json[0]["question"]);
    MultipleChoiceQuestion multipleChoiceQuestion;

    int i = 0;
    while (json[i] != null) {
      multipleChoiceQuestion = new MultipleChoiceQuestion(
          question: json[i]["question"],
          A: json[i]["A"],
          B: json[i]["B"],
          C: json[i]["C"],
          D: json[i]["D"],
          ansOption: json[i]["answer"]);
      mcq.add(multipleChoiceQuestion);
      i++;
    }
  }

  checkScore(bool ans) {
    if(optionSelected){
      setState(() {
        if (ans) {
          currentScore = currentScore + 100;
        } else if (!ans && currentScore > 0) {
          currentScore = currentScore - 100;
        }
      });
      if(HighScore! <= currentScore){
        setNewHighScore(currentScore);
      }
    }
  }

  checkHighScore(){
    FirebaseFirestore.instance.collection("Scores").doc(FirebaseAuth.instance.currentUser!.email).get().then((value) {
      if(value.exists){
        setState(() {
          HighScore = value["Quiz"];
        });
      }
    },);
  }

  setNewHighScore(int s){
    HighScore = s;
    FirebaseFirestore.instance.collection("Scores").doc(FirebaseAuth.instance.currentUser!.email).update({
      "Quiz": s,
    }).then((value) {
    }).onError((error, stackTrace) {});

    FirebaseFirestore.instance.collection("LeaderBoard").doc(FirebaseAuth.instance.currentUser!.email).update({
      "Quiz " : s,
    }).then((value) {
    }).onError((error, stackTrace) {});
  }

  nextQuestion() {
    if (optionSelected) {
      setState(() {
        currentIndex++;
        currentQuestion = mcq[currentIndex].question;
        optionA = mcq[currentIndex].A;
        optionB = mcq[currentIndex].B;
        optionC = mcq[currentIndex].C;
        optionD = mcq[currentIndex].D;
        correctAns = MultipleChoiceQuestion.getStringFromOption(
            mcq[currentIndex].ansOption, optionA, optionB, optionC, optionD);
        yourAns = "Null";
        isAnsCorrect = false;
        ansColor = Colors.cyanAccent;
        animationUrl = "assets/animations/Quiz_logo.json";
        nextANim = false;
        checkselection = false;
        optionSelected = false;
        checkselection = false;
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
        duration: Duration(seconds: 2),
        showCloseIcon: false,
      ));
      //
    }
  }

  checkAnswer(String ans) {
    if (!optionSelected) {
      optionSelected = true;
      setState(() {
        yourAns = ans;
        nextANim = true;
      });
      if (ans == mcq[currentIndex].correctAns) {
        setState(() {
          isAnsCorrect = true;
          ansColor = Colors.green.shade400;
          animationUrl = "assets/animations/sucess_anim.json";
          checkScore(true);
        });
      } else {
        setState(() {
          isAnsCorrect = false;
          ansColor = Colors.red.shade400;
          animationUrl = "assets/animations/faliure_anim.json";
          checkScore(false);
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_alert),
            Container(
              width: 20,
            ),
            Text("You already Answered the question 🙄")
          ],
        ),
        duration: Duration(seconds: 2),
        showCloseIcon: false,
      ));
      //
    }
  }

  getBulbString() {
    if (optionSelected) {
      if (yourAns == correctAns) {
        return "Your Answer is Correct : ${mcq[currentIndex].correctAns}";
      } else if (yourAns != mcq[currentIndex].correctAns) {
        return "Your Answer is Wrong The Correct Answer is ${mcq[currentIndex].correctAns}";
      }
    }
    return "Do answer the question 🙄";
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
              Container(
                height: 20,
              ),
              SizedBox(
                  height: 130,
                  width: 130,
                  child: Lottie.asset(
                    animationUrl,
                    reverse: true,
                    frameRate: FrameRate(16),
                  )),
              Container(
                height: 10,
              ),
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
                            "                                                       Question No : ${currentIndex + 1} / ${mcq.length + 1}",
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
              Container(
                height: 15,
              ),
              Visibility(
                visible: !optionSelected,
                child: AnimatedButton(
                  isSelected: optionSelected,
                  height: 50,
                  width: 280,
                  text: optionA,
                  isReverse: true,
                  selectedTextColor: Colors.white,
                  transitionType: TransitionType.LEFT_TO_RIGHT,
                  textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                  backgroundColor: Colors.blue.shade200,
                  borderColor: Colors.blue.shade700,
                  borderRadius: 50,
                  borderWidth: 1.75,
                  selectedBackgroundColor: Colors.blue.shade700,
                  animationDuration: (!checkselection)
                      ? Duration(seconds: 1)
                      : Duration(minutes: 5),
                  selectedText: "Lets Check the ans",
                  onPress: () {
                    checkselection = true;
                    Timer(Duration(seconds: 1), () {
                      checkAnswer(optionA);
                    });
                  },
                ),
              ),
              Container(
                height: 10,
              ),
              Visibility(
                visible: !optionSelected,
                child: AnimatedButton(
                  isSelected: optionSelected,
                  height: 50,
                  width: 280,
                  text: optionB,
                  isReverse: true,
                  selectedTextColor: Colors.white,
                  transitionType: TransitionType.LEFT_TO_RIGHT,
                  textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                  backgroundColor: Colors.blue.shade200,
                  borderColor: Colors.blue.shade700,
                  borderRadius: 50,
                  borderWidth: 1.75,
                  selectedBackgroundColor: Colors.blue.shade700,
                  animationDuration: (!checkselection)
                      ? Duration(seconds: 1)
                      : Duration(minutes: 5),
                  selectedText: "Lets Check the ans",
                  onPress: () {
                    checkselection = true;
                    Timer(Duration(seconds: 1), () {
                      checkAnswer(optionB);
                    });
                  },
                ),
              ),
              Container(
                height: 10,
              ),
              Visibility(
                visible: !optionSelected,
                child: AnimatedButton(
                  isSelected: optionSelected,
                  height: 50,
                  width: 280,
                  text: optionC,
                  isReverse: false,
                  selectedTextColor: Colors.white,
                  transitionType: TransitionType.LEFT_TO_RIGHT,
                  textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                  backgroundColor: Colors.blue.shade200,
                  borderColor: Colors.blue.shade700,
                  borderRadius: 50,
                  borderWidth: 1.75,
                  selectedBackgroundColor: Colors.blue.shade700,
                  animationDuration: (!checkselection)
                      ? Duration(seconds: 1)
                      : Duration(minutes: 5),
                  selectedText: "Lets Check the ans",
                  onPress: () {
                    checkselection = true;
                    Timer(Duration(seconds: 1), () {
                      checkAnswer(optionC);
                    });
                  },
                ),
              ),
              Container(
                height: 10,
              ),
              Visibility(
                visible: !optionSelected,
                child: AnimatedButton(
                  isSelected: optionSelected,
                  height: 50,
                  width: 280,
                  text: optionD,
                  isReverse: false,
                  selectedTextColor: Colors.white,
                  transitionType: TransitionType.LEFT_TO_RIGHT,
                  textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                  backgroundColor: Colors.blue.shade200,
                  borderColor: Colors.blue.shade700,
                  borderRadius: 50,
                  borderWidth: 1.75,
                  selectedText: "Lets Go",
                  selectedBackgroundColor: Colors.blue.shade700,
                  animationDuration: (!checkselection)
                      ? Duration(seconds: 1)
                      : Duration(minutes: 5),
                  onPress: () {
                    checkselection = true;
                    Timer(Duration(seconds: 1), () {
                      checkAnswer(optionD);
                    });
                  },
                ),
              ),
              Visibility(
                visible: optionSelected,
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 5),
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: Colors.cyanAccent,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.black, width: 2)),
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      maxLines: 2,
                      enabled: false,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.black),
                        suffixIconColor: Colors.black,
                        contentPadding: const EdgeInsets.only(
                            left: 20, right: 0, top: 0, bottom: 0),
                        hintText: "The Correct Answer is : " + correctAns,
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(
                              left: 0, right: 20, top: 0, bottom: 0),
                          child: Icon(
                            Icons.info,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: optionSelected,
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 5),
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: ansColor,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.black, width: 2)),
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      maxLines: 2,
                      enabled: false,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.black),
                        suffixIconColor: Colors.black,
                        contentPadding: const EdgeInsets.only(
                            left: 20, right: 0, top: 0, bottom: 0),
                        hintText: "Your Answer is : " + yourAns,
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(
                              left: 0, right: 20, top: 0, bottom: 0),
                          child: Icon(
                            Icons.ac_unit,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 15,
              ),
              Text(
                getBulbString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.black),
              ),
              Container(
                height: 50,
              ),
              Visibility(
                visible: optionSelected,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (nextANim)
                        ? SizedBox(
                            height: 55,
                            width: 55,
                            child: Lottie.asset(
                                "assets/animations/next_anim.json",
                                frameRate: FrameRate(3)))
                        : Container(),
                    Container(
                      width: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigoAccent.shade200),
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
}
