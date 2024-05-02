import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/UiWidgets/UiHelper.dart';
import 'package:flutter_app/model/Users.dart';

class OtherProfileScreen extends StatefulWidget {
  String email;
  int factsScore;
  int quizScore;

  OtherProfileScreen(
      {super.key,
      required this.email,
      required this.factsScore,
      required this.quizScore});

  @override
  State<OtherProfileScreen> createState() => _OtherProfileScreenState();
}

class _OtherProfileScreenState extends State<OtherProfileScreen> {
  DateTime? date;
  String? gender;
  newUser user = newUser(fullName: "", mobile: "", about: "", profilePic: "");

  String? birthDate;

  String? email;
  int quizS = 0;
  int factS = 0;

  @override
  void initState() {
    email = widget.email;
    factS = widget.factsScore;
    quizS = widget.quizScore;
    getUserDetails();
    // TODO: implement initState
    super.initState();
  }

  getUserDetails() {
    FirebaseFirestore.instance.collection("Users").doc(email).get().then(
      (value) {
        setState(() {
          user!.fullName = value["fullName"];
          user!.mobile = value["mobile"];
          user!.about = value["about"];
          user!.profilePic = value["profilePic"];
          user;
          gender = value["gender"];
          //date = DateTime.fromMillisecondsSinceEpoch(value["dateFormat"] * 1000);
          birthDate = value["birthDate"];
          //print(age);
          print(date);
          print(gender);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            height: 1000,
            child: Column(
              children: [
                Container(
                  height: 75,
                ),
                Text(
                  "Hey " + user!.fullName + " here!!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w700,
                      fontSize: 20),
                ),
                Container(
                  height: 10,
                ),
                Text(
                  " " + user!.about + " ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w700,
                      fontSize: 20),
                ),
                Container(
                  height: 25,
                ),
                ClipOval(
                  child: Image.network(
                    user.profilePic,
                    height: 250,
                    width: 250,
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  height: 25,
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        child: Text(
                          gender.toString(),
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                        onPressed: () {},
                        style: ButtonStyle(backgroundColor:
                        MaterialStateProperty.resolveWith<Color>((states) {
                          if (states.contains(MaterialState.hovered)) {
                            return Colors.red;
                          } else if (states.contains(MaterialState.pressed)) {
                            return Colors.blueAccent;
                          }
                          return Colors.indigo.shade200;
                        })),
                      ),
                      ElevatedButton(
                        child: Text(
                          birthDate.toString(),
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                        onPressed: () {},
                        style: ButtonStyle(backgroundColor:
                        MaterialStateProperty.resolveWith<Color>((states) {
                          if (states.contains(MaterialState.hovered)) {
                            return Colors.red;
                          } else if (states.contains(MaterialState.pressed)) {
                            return Colors.blueAccent;
                          }
                          return Colors.indigo.shade200;
                        })),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 8,
                ),
                ElevatedButton(
                  child: Text(
                    user.mobile.toString(),
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  onPressed: () {},
                  style: ButtonStyle(backgroundColor:
                  MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.hovered)) {
                      return Colors.red;
                    } else if (states.contains(MaterialState.pressed)) {
                      return Colors.blueAccent;
                    }
                    return Colors.indigo.shade200;
                  })),
                ),
                Container(
                  height: 30,
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 0),
                  child: TextField(
                    enabled: false,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2),
                      hintText: "Facts Game HighScore",
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 0),
                  child: ElevatedButton(
                    child: Text(
                      "** " + factS.toString() + " **",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    onPressed: () {},
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
                Container(
                  height: 0,
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 0),
                  child: TextField(
                    enabled: false,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2),
                      hintText: "Quiz Game HighScore",
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 0),
                  child: ElevatedButton(
                    child: Text(
                      "** " + quizS.toString() + " **",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    onPressed: () {},
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
                Container(
                  padding: EdgeInsets.all(30),
                  margin: EdgeInsets.all(10),
                  child: UiHelper.CustomButton(() {}, "Rate Profile"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
