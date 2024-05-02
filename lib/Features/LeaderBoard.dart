import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Features/OtherProfile.dart';
import 'package:flutter_app/model/Users.dart';
import 'package:flutter_app/model/leaderBoardModel.dart';
import 'package:lottie/lottie.dart';
import 'package:sortedmap/sortedmap.dart';

import '../Login_SIgnUp/ProfileSreen.dart';

class LeaderBoard extends StatefulWidget {
  const LeaderBoard({super.key});

  @override
  State<LeaderBoard> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  Map<String, dynamic> sortedFactList = {};

  List<bool> isSelected = [true, false];

  // new SortedMap(Ordering.byValue());
  List<leaderBoardModel> userDataOrderFacts = [];
  List<leaderBoardModel> userDataOrderQuiz = [];
  List<leaderBoardModel> currentDisplayList = [];

  bool currPageisFacts = true;

  @override
  void initState() {
    getListOfPlayers();
    if (currPageisFacts) {
      currentDisplayList = userDataOrderFacts;
    }
    //factsList();
    super.initState();
  }

  getListOfPlayers() {
    print("Hello Inside");

    leaderBoardModel modelFacts;
    FirebaseFirestore.instance
        .collection("LeaderBoard")
        .orderBy(" Facts ", descending: true)
        .get()
        .then(
      (value) {
        print(userDataOrderFacts);
        print("Hello facts" + value.docs.elementAt(0)["profilePic"].toString());
        value.docs.forEach((element) {
          modelFacts = new leaderBoardModel(
              profilePic: element["profilePic"],
              mobile: element["mobile"],
              fullName: element["fullName"],
              about: element["about"],
              Quiz: element["Quiz "],
              Facts: element[" Facts "]);
          setState(() {
            userDataOrderFacts.add(modelFacts);
          });
        });
        setState(() {
          userDataOrderFacts;
          currentDisplayList;
        });
      },
    );

    leaderBoardModel modelQuiz;
    FirebaseFirestore.instance
        .collection("LeaderBoard")
        .orderBy("Quiz ", descending: true)
        .get()
        .then(
      (value) {
        print(userDataOrderQuiz);
        //print("Hello quiz" + value.docs.elementAt(0)["profilePic"].toString());
        value.docs.forEach((element) {
          modelQuiz = new leaderBoardModel(
              profilePic: element["profilePic"],
              mobile: element["mobile"],
              fullName: element["fullName"],
              about: element["about"],
              Quiz: element["Quiz "],
              Facts: element[" Facts "]);
          setState(() {
            userDataOrderQuiz.add(modelQuiz);
          });
        });
        setState(() {
          userDataOrderFacts;
          currentDisplayList;
        });
      },
    );
  }

  listTapped(int index){
    if(currentDisplayList[index].mobile == FirebaseAuth.instance.currentUser!.email){
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder:
              (context) =>
              ProfileScreen(editProfile: false ,email: FirebaseAuth.instance.currentUser!.email.toString())
          )
      );
    }else{
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder:
              (context) =>
              OtherProfileScreen(email: currentDisplayList[index].mobile , factsScore: currentDisplayList[index].Facts, quizScore: currentDisplayList[index].Quiz,)
          )
      );
    }
  }

  // factsList(){
  //   FirebaseFirestore.instance.collection("LeaderBoard").doc("Facts").get().then((value) {
  //     if(value.exists){
  //       value.data()!.entries;
  //       for(var s in value.data()!.entries){
  //         sortedFactList[s.key] = s.value;
  //       }
  //       // int i = 0;
  //       // while(i <= sortedListFacts.length){
  //       //   getUserData(sortedListFacts.keys.elementAt(i).toString());
  //       //   i++;
  //       // }
  //     }
  //     print("Hello          "  + sortedFactList.toString());
  //     List<MapEntry<String,dynamic>> listMappedEntries = sortedFactList.entries.toList();
  //     listMappedEntries.sort((a,b)=> a.value.compareTo(b.value));
  //     sortedFactList = Map.fromEntries(listMappedEntries);
  //     //final Map<String,int> sortedMapData = Map.fromEntries(listMappedEntries);
  //     //sortedListFacts = reverseMap(sortedListFacts);
  //     print("Hello          "  + sortedFactList.toString());
  //     getUserData();
  //   },);
  //
  // }
  //
  // reverseMap(Map map) {
  //   Map newmap = {};
  //   for (String _key in map.keys.toList().reversed) {
  //     newmap[_key] = map[_key];
  //   }
  //   return newmap;
  // }
  //
  // getUserData(){
  //   newUser user;
  //   Iterable<String> usersMail = sortedFactList.keys;
  //   for(String s in  usersMail){
  //     FirebaseFirestore.instance.collection("Users").doc(s).get().then((value) {
  //       if(value.exists){
  //         user = newUser(fullName: value["fullName"], mobile: value["mobile"], about: value["about"], profilePic: value["profilePic"]);
  //         print(value["profilePic"]);
  //         setState(() {
  //           userData.add(user);
  //         });
  //       }
  //     },);
  //   }
  //   print(userData);
  // }
  //
  // getImage(String s){
  //   FirebaseFirestore.instance.collection("Users").doc(s).get().then((value) {
  //     if(value.exists){
  //       //user = newUser(fullName: value["fullName"], mobile: value["mobile"], about: value["about"], profilePic: value["profilePic"]);
  //       print(value["profilePic"]);
  //       return value["profilePic"];
  //       // setState(() {
  //       //   userData.add(user);
  //       // });
  //     }
  //   },);
  // }

  //
  // quizList(){
  //   FirebaseFirestore.instance.collection("LeaderBoard").doc("Facts").get().then((value) {
  //     if(value.exists){
  //       value.data()!.entries;
  //       for(var s in value.data()!.entries){
  //         sortedListFacts[s.key] = s.value;
  //       }
  //     }
  //     print("Hello          "  + sortedListFacts.toString());
  //   },);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        child: Column(children: [
          Container(
            height: 30,
          ),
          SizedBox(
              height: 200,
              width: 200,
              child: Lottie.asset(
                "assets/animations/leaderboard_anim.json",
                reverse: true,
                frameRate: FrameRate(16),
              )),
          Text(
            "Here is the LeaderBoard ☺️ \n Do check your rank ",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500, fontSize: 16),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 5),
            child: ToggleButtons(
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      Icon(Icons.lightbulb),
                      Text('     Facts     ',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black)),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      Icon(Icons.key),
                      Text('     Quiz     ',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black)),
                    ],
                  ),
                ),
              ],
              borderRadius: BorderRadius.circular(50),
              onPressed: (int newIndex) {
                setState(() {
                  // looping through the list of booleans values
                  if (newIndex == 0) {
                    setState(() {
                      currentDisplayList = userDataOrderFacts;
                    });
                  } else {
                    setState(() {
                      currentDisplayList = userDataOrderQuiz;
                    });
                  }
                  for (int index = 0; index < isSelected.length; index++) {
                    if (index == newIndex) {
                      // toggling between the button to set it to true
                      isSelected[index] = !isSelected[index];
                    } else {
                      // other two buttons will not be selected and are set to false
                      isSelected[index] = false;
                    }
                  }
                });
              },
              isSelected: isSelected,
              selectedColor: Colors.indigo,
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: currentDisplayList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: (){
                    listTapped(index);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 2.0, top: 0, bottom: 0, right: 4),
                          child: CircleAvatar(
                            backgroundColor: Colors.cyanAccent.shade100,
                            radius: 15,
                            child: Text((index + 1).toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                                maxLines: 1),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          padding: EdgeInsets.all(2.0),
                          child: CircleAvatar(
                            radius: 30,
                            child: ClipOval(
                                child: Image.network(
                              currentDisplayList[index].profilePic,
                              //userData[index].profilePic,
                              height: 200,
                              width: 200,
                              fit: BoxFit.fill,
                            )),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 15.0, top: 1, bottom: 2, right: 3),
                            child: Text(currentDisplayList[index].fullName,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 19,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w500),
                                maxLines: 1),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 8.0, top: 1, bottom: 2, right: 3),
                          child: Text(
                              (isSelected[0] == true)
                                  ? currentDisplayList[index].Facts.toString()
                                  : currentDisplayList[index].Quiz.toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 19,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w600),
                              maxLines: 1),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(
                      top: 2, bottom: 2, left: 10, right: 10),
                  child: Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: 1,
                    color: Colors.black,
                  ),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
