import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:flutter_app/Features/LeaderBoard.dart';
import 'package:flutter_app/Features/YourScore.dart';
import 'package:flutter_app/Login_SIgnUp/HomeScreen.dart';
import 'package:flutter_app/UiWidgets/UiHelper.dart';
import 'package:flutter_app/screen/McqScreen.dart';
import 'package:flutter_app/screen/Question.dart';
import 'package:lottie/lottie.dart';

import '../Login_SIgnUp/ProfileSreen.dart';
import '../Util/UtilityMethods.dart';

class NewHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NewHomeState();
  }
}

class _NewHomeState extends State<NewHome> {
  bool noResumeGame = true;

  bool factsQuizGameExits = false;
  bool McQQuizGameExits = false;

  bool buttonClicked = false;

  @override
  void initState() {
    // TODO: implement initState
    getGameStatus();
    super.initState();
  }

  void onResumed() {}

  getGameStatus() {
    setState(() {
      buttonClicked = false;
    });
    FirebaseFirestore.instance
        .collection("GameExits")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get()
        .then((value) {
      if (value.exists) {
        if (value["FactsContinue"] == true) {
          setState(() {
            noResumeGame = false;
            factsQuizGameExits = true;
          });
        }
        if (value["QuizContinue"] == true) {
          setState(() {
            noResumeGame = false;
            McQQuizGameExits = true;
          });
        }
      }
    });
  }

  NavigationToGame(bool newGame, int optionType) {
    if (newGame && optionType == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return TFQuestionScreen(val: -1, newGame: true);
      })).then(
        (value) {
          getGameStatus();
        },
      );
    } else if (newGame && optionType == 4) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return McqScreen(
          newGame: true,
        );
      })).then(
        (value) {
          getGameStatus();
        },
      );
    } else if (!newGame && optionType == 2 && !noResumeGame) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return TFQuestionScreen(val: -1, newGame: false);
      })).then(
        (value) {
          getGameStatus();
        },
      );
    } else if (!newGame && optionType == 4 && !noResumeGame) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return McqScreen(
          newGame: false,
        );
      })).then(
        (value) {
          getGameStatus();
        },
      );
    }
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 20,
            ),
            SizedBox(
                height: 300,
                width: 300,
                child: Lottie.asset(
                  "assets/animations/chilled_happy_anim.json",
                  reverse: true,
                  frameRate: FrameRate(16),
                )),
            Container(
              height: 1,
              color: Colors.black,
              width: MediaQuery.of(context).size.height,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Welcome back Mark 😘!!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 25,
                    color: Colors.indigo),
              ),
            ),
            Container(
              height: 1,
              color: Colors.black,
              width: MediaQuery.of(context).size.height,
            ),
            Visibility(
              visible: !noResumeGame,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: 10, left: 10, right: 10, bottom: 0),
                    child: TextField(
                      enabled: false,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                          color: Colors.black,
                        ),
                        hintText: "Resume Game",
                      ),
                    ),
                  ),
                  Container(
                    height: 15,
                  ),
                  Visibility(
                    visible: factsQuizGameExits,
                    child: AnimatedButton(
                      height: 45,
                      width: 250,
                      text: 'Resume Your Facts Game',
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
                      animationDuration: Duration(seconds: 2),
                      selectedText: "Continuing Your Facts Game",
                      onPress: () {
                        if (!buttonClicked) {
                          setState(() {
                            buttonClicked = true;

                            Timer(Duration(microseconds: 10), () {
                              NavigationToGame(false, 2);
                            });
                          });
                        } else {
                          UiHelper.newCustomSnackBar(context,
                              "Wait Your Game is Loading", Icons.timer);
                        }
                      },
                    ),
                  ),
                  Container(
                    height: 15,
                  ),
                  Visibility(
                    visible: McQQuizGameExits,
                    child: AnimatedButton(
                      height: 45,
                      width: 250,
                      text: 'Resume Your Quiz Game',
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
                      animationDuration: Duration(microseconds: 10),
                      selectedText: "Continuing Your Quiz Game",
                      onPress: () {
                        if (!buttonClicked) {
                          setState(() {
                            buttonClicked = true;
                            Timer(Duration(seconds: 2), () {
                              NavigationToGame(false, 4);
                            });
                          });
                        } else {
                          UiHelper.newCustomSnackBar(context,
                              "Wait Your Game is Loading", Icons.timer);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 15,
            ),
            Padding(
              padding: EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 0),
              child: TextField(
                enabled: false,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintStyle: TextStyle(
                    color: Colors.black,
                  ),
                  hintText: "New Game",
                ),
              ),
            ),
            Container(
              height: 15,
            ),
            AnimatedButton(
              height: 45,
              width: 250,
              text: 'Check Your Facts',
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
              animationDuration: Duration(seconds: 2),
              selectedText: "Facts New Game",
              onPress: () {
                if (!buttonClicked) {
                  setState(() {
                    buttonClicked = true;
                    Timer(Duration(microseconds: 10), () {
                      NavigationToGame(true, 2);
                    });
                  });
                } else {
                  UiHelper.newCustomSnackBar(
                      context, "Wait Your Game is Loading", Icons.timer);
                }
              },
            ),
            Container(
              height: 15,
            ),
            AnimatedButton(
              height: 45,
              width: 250,
              text: 'Check Your Knowledge',
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
              animationDuration: Duration(seconds: 2),
              selectedText: "Quiz New Game",
              onPress: () {
                if (!buttonClicked) {
                  setState(() {
                    buttonClicked = true;
                    Timer(Duration(microseconds: 10), () {
                      NavigationToGame(true, 4);
                    });
                  });
                } else {
                  UiHelper.newCustomSnackBar(
                      context, "Wait Your Game is Loading", Icons.timer);
                }
              },
            ),
            Container(
              height: 35,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigoAccent.shade200),
              onPressed: () {
                if (!buttonClicked) {
                  buttonClicked = true;
                  Navigator.push(context, MaterialPageRoute(builder: (context) => YourHighScore(),)).then((value){
                    buttonClicked = false;
                  });
                }else {
                  UiHelper.newCustomSnackBar(
                      context, "Wait Your Score is Loading", Icons.timer);
                }
              },
              child: Text("Check Your High Score",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.white)),
            ),
            Container(
              height: 3,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigoAccent.shade200),
              onPressed: () {
                if (!buttonClicked) {
                  buttonClicked = true;
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LeaderBoard(),)).then((value){
                    buttonClicked = false;
                  });
                }else {
                  UiHelper.newCustomSnackBar(
                      context, "Wait Your LeaderBoard is Loading", Icons.timer);
                }
              },
              child: Text("Check LeaderBoard",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.white)),
            ),
            Container(
              height: 3,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigoAccent.shade200),
              onPressed: () {
                if (!buttonClicked) {
                  setState(() {
                    buttonClicked = true;
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                              editProfile: false,
                              email: FirebaseAuth.instance.currentUser!.email
                                  .toString()))).then((value){
                    buttonClicked = false;
                  });
                }else {
                  UiHelper.newCustomSnackBar(
                      context, "Wait Your Profile is Loading", Icons.timer);
                }
              },
              child: Text("Your Profile",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.white)),
            ),
            Container(
              height: 3,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigoAccent.shade200),
              onPressed: () {
                if (!buttonClicked) {
                  buttonClicked = true;
                  FirebaseAuth.instance.signOut();
                  Navigation.pushReplacementNavigation(context, MyHomePage());
                }else {
                  UiHelper.newCustomSnackBar(
                      context, "Wait Your are Signing Out", Icons.timer);
                }
              },
              child: Text("Sign Out",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.white)),
            ),
            Container(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }
}
