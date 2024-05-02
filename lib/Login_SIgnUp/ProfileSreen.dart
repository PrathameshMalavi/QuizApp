import 'dart:async';
import "dart:io";
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:flutter_app/UiWidgets/UiHelper.dart';
import 'package:flutter_app/screen/home.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:textfields/textfields.dart';
import 'package:flutter_app/Util/UtilityMethods.dart';

import 'package:intl/intl.dart';

import '../screen/HomeScreen.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen(
      {super.key, required this.editProfile, required String this.email});

  bool editProfile;
  String email;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? pickedImage;
  String urlProfile = "";

  List<bool> isSelected = [true, false];

  bool loadingAnim = false;
  bool imgSelected = false;
  bool savingProfile = false;

  DateTime? datePicked;
  String? formatedDate;

  String fullName = "";
  String about = "";
  String email = "";
  User? curretUser;

  String? gender = "MALE";

  File? file;

  TextEditingController fullNameController = TextEditingController();
  TextEditingController aboutController = TextEditingController();

  @override
  void initState() {
    getData();
    Timer((Duration(seconds: 1)), () {
      setState(() {
        loadingAnim = false;
        imgSelected = false;
        savingProfile = false;
        //pickedImage= file;
        urlProfile;
      });
    });
    super.initState();
  }

  getData() async {
    email = widget.email;
    curretUser = FirebaseAuth.instance.currentUser;
    try {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.email)
          .get()
          .then((value) {
        if (value.exists) {
          setState(() {
            if (!widget.editProfile) {
              //loadingAnim = true;
            }
          });
          print(value);
          var a = value.data();
          print("FullName another Method" + a?["about"]);
          setState(() {
            fullNameController.text = a?['fullName'];
            //print("FullName" + data['fullName']);
            aboutController.text = a?['about'];
            urlProfile = a?['profilePic'];
            //datePicked = a?["dateFormat"];
            datePicked = DateTime.now();
            formatedDate = a?["birthDate"];
            gender = a?["gender"];

            //pickedImage = ((urlProfile != "")? FirebaseMethods.urlToFile(urlProfile) : null);
            //pickedImage = FileImage(Image.network(a?['profilePic']) as File) as File?;
            //print(data['profilePic']);
          });
        }
      });

      file = await new FirebaseMethods().urlToFile(urlProfile);

      // if (urlProfile != "") {
      //   print("Url inside" + urlProfile);
      //   pickedImage = file;
      //   //print("FIle Path " + path.toString());
      // }

      // CollectionReference users = FirebaseFirestore.instance.collection('Users');
      // final snapshot = await users.doc(widget.mobileNumber).get();
      // final data = snapshot.data() as Map<String, dynamic>;
      // fullNameController.text = data['fullName'];
      // print("FullName" + data['fullName']);
      // aboutController.text = data['about'];
      // pickedImage = File.fromUri(Uri.parse(data['profilePic']));
      // print(data['profilePic']);
    } catch (e) {
      setState(() {
        pickedImage = null;
        fullNameController.text = "";
        aboutController.text = "";
      });
    }
  }

  showAlertDiaglogForImagePicker() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Pick a Image"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Camera"),
                leading: Icon(Icons.camera),
                onTap: () {
                  PermissionUser.requestPermission(Permission.camera, () {
                    pickImage(ImageSource.camera);
                    Navigator.pop(context);
                  }, () {
                    Navigator.pop(context);
                  });
                  //pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                title: Text("Gallery"),
                leading: Icon(Icons.image),
                onTap: () {
                  PermissionUser.requestPermission(Permission.mediaLibrary, () {
                    pickImage(ImageSource.gallery);
                    Navigator.pop(context);
                  }, () {
                    Navigator.pop(context);
                  });
                  // pickImage(ImageSource.gallery);
                  // Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  pickImage(ImageSource imageSource) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageSource);
      if (photo == null) return;

      final tempImage = File(photo.path);
      setState(() {
        pickedImage = tempImage;
        imgSelected = true;
      });
    } catch (e) {}
  }

  saveProfile() async {
    if (fullNameController.text == "") {
      UiHelper.newCustomSnackBar(
          context, "Please Enter The field Name", Icons.crisis_alert);
    } else if (aboutController.text == "") {
      UiHelper.newCustomSnackBar(
          context, "Please Enter The field About", Icons.crisis_alert);
    }
    // else if (pickedImage == null && urlProfile == "") {
    //   UiHelper.newCustomSnackBar(
    //       context, "Please select an Image", Icons.crisis_alert);
    // }
    else if (datePicked == null) {
      UiHelper.newCustomSnackBar(
          context, "Please pick your Birth Date", Icons.crisis_alert);
    }else {
      if(pickedImage == null && urlProfile == ""){
        final byteData = await rootBundle.load('assets/images/person.png');

        final file = File('${(await getTemporaryDirectory()).path}/images/person.png');
        await file.create(recursive: true);
        await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
        pickedImage = file;
      }
      fullName = fullNameController.text.toString();
      about = aboutController.text.toString();
      savingProfile = true;
      storeDataToFirebase();
    }
  }

  storeDataToFirebase() async {
    curretUser = FirebaseAuth.instance.currentUser;
    String url;

    if (imgSelected == true) {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref("Profile Pics")
          .child(widget.email)
          .putFile(pickedImage!);
      TaskSnapshot taskSnapshot = await uploadTask;
      url = await taskSnapshot.ref.getDownloadURL();
    } else if (urlProfile != null) {
      url = urlProfile;
    } else {
      url = "";
    }
    FirebaseFirestore.instance.collection("Users").doc(widget.email).update({
      "mobile": widget.email,
      "profilePic": url,
      "fullName": fullNameController.text.toString(),
      "about": aboutController.text.toString(),
      "birthDate" : formatedDate,
      "dateFormat" : datePicked,
      "gender" : gender,
      "profileComplete" : true,

    }).then((value) {
      setGame(url);
      setState(() {
        savingProfile = true;
      });
      Timer(Duration(seconds: 0), () {
        Navigation.pushReplacementNavigation(context, NewHome());
      });
    }).onError((error, stackTrace) {});
  }


  setGame(String url){
    FirebaseFirestore.instance.collection("Scores").doc(widget.email).set({
      "Facts": 0,
      "Quiz": 0,
    }).then((value) {
    }).onError((error, stackTrace) {});

    FirebaseFirestore.instance.collection("GameExits").doc(widget.email).set({
      "FactsContinue": false,
      "QuizContinue": false,
    }).then((value) {
    }).onError((error, stackTrace) {});

    FirebaseFirestore.instance.collection("GameCredentialResume").doc(widget.email).collection("Quiz").doc("Stats").set({
      "Score" : 0,
      "currQuiz" : 0,
    }).then((value) {
    }).onError((error, stackTrace) {});

    FirebaseFirestore.instance.collection("GameCredentialResume").doc(widget.email).collection("Facts").doc("Stats").set({
      "Score" : 0,
      "currFacts" : 0,
    }).then((value) {
    }).onError((error, stackTrace) {});

    FirebaseFirestore.instance.collection("LeaderBoard").doc(widget.email).set({
      "profilePic" : url,
      "mobile": widget.email,
      "fullName": fullNameController.text.toString(),
      "about": aboutController.text.toString(),
      "Quiz " : 0,
      " Facts " : 0,
    }).then((value) {
    }).onError((error, stackTrace) {});

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 15),
        child: SizedBox(
          height: 900,
          // height: (MediaQuery.of(context).size.height > 450)
          //     ? MediaQuery.of(context).size.height
          //     : 450,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(flex: 1, child: Container()),
              InkWell(
                borderRadius: BorderRadius.circular(90),
                child: CircleAvatar(
                  backgroundImage:
                      (pickedImage != null) ? FileImage(pickedImage!) : null,
                  child: (urlProfile != "")
                      ? ClipOval(
                          child: Image.network(
                            urlProfile,
                            height: 300,
                            width: 300,
                            fit: BoxFit.fill,
                          ),
                        )
                      : (pickedImage == null)
                          ? Icon(Icons.person, size: 120)
                          : null,
                  backgroundColor: Colors.indigo.shade50,
                  radius: 120,
                ),
                onTap: () {
                  if (widget.editProfile) {
                    showAlertDiaglogForImagePicker();
                  }
                },
              ),
              Visibility(
                visible: widget.editProfile,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 18, left: 5, right: 5),
                  child: Text("Your Profile Image 👆",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 0),
                child: TextField(
                  enabled: widget.editProfile,
                  controller: fullNameController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                        left: 20, right: 0, top: 0, bottom: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.black45, width: 4),
                    ),
                    hintStyle: TextStyle(color: Colors.black45),
                    suffixIconColor: Colors.black45,
                    hintText: "Your Full Name",
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(
                          left: 0, right: 20, top: 0, bottom: 0),
                      child: Icon(
                        Icons.person,
                        size: 30,
                      ),
                    ),
                    focusColor: Colors.indigo,
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 0),
                child: TextField(
                  enabled: widget.editProfile,
                  controller: aboutController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                        left: 20, right: 0, top: 0, bottom: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.black45, width: 4),
                    ),
                    hintStyle: TextStyle(color: Colors.black45),
                    suffixIconColor: Colors.black45,
                    hintText: "About",
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(
                          left: 0, right: 20, top: 0, bottom: 0),
                      child: Icon(
                        Icons.info,
                        size: 30,
                      ),
                    ),
                    focusColor: Colors.indigo,
                  ),
                ),
              ),
              Visibility(
                visible: widget.editProfile,
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 0),
                  child: ElevatedButton(
                    child: Text(
                      "Select Your Birth Date",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    onPressed: () async {
                      datePicked = (await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1950),
                          lastDate: DateTime.now()));

                      if (datePicked != null) {
                        setState(() {
                          datePicked;
                          formatedDate = DateFormat.yMMMEd().format(datePicked!);
                        });
                      }
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
              ),
              Container(
                child: (datePicked != null)
                    ? Padding(
                        padding: EdgeInsets.only(
                            top: 15, left: 10, right: 10, bottom: 0),
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(
                                left: 20, right: 0, top: 0, bottom: 0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:
                                  BorderSide(color: Colors.black45, width: 4),
                            ),
                            hintText: formatedDate,
                            hintStyle: TextStyle(color: Colors.black45),
                            suffixIconColor: Colors.black45,
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(
                                  left: 0, right: 20, top: 0, bottom: 0),
                              child: Icon(
                                Icons.date_range,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      )
                    : null,
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 20, left: 10, right: 10, bottom: 5),
                child: ToggleButtons(
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Row(children: [
                        Icon(Icons.male),
                        Text('MALE', style: TextStyle(fontSize: 16 , fontWeight: FontWeight.w400 ,color: Colors.black)),
                      ],),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12 , vertical: 10),
                      child: Row(children: [
                        Icon(Icons.female),
                        Text('FEMALE', style: TextStyle(fontSize: 16 , fontWeight: FontWeight.w400 ,color: Colors.black)),
                      ],),
                    ),
                  ],
                  borderRadius:  BorderRadius.circular(50),
                  onPressed: (int newIndex) {
                    if(widget.editProfile){
                      setState(() {
                        // looping through the list of booleans values
                        if(newIndex == 0){
                          gender = "MALE";
                        }else{
                          gender = "FEMALE";
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
                    }
                  },
                  isSelected: isSelected,
                  selectedColor: Colors.indigo,
                ),
              ),
              // Padding(padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
              //     child: Center(child: SingleChildScrollView(child: Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         ToggleSwitch(
              //           customWidths: [90.0, 50.0],
              //           cornerRadius: 20.0,
              //           activeBgColors: [ [Colors.cyan], [Colors.redAccent]],
              //           activeFgColor: Colors.white,
              //           inactiveBgColor: Colors.grey,
              //           inactiveFgColor: Colors.white,
              //           totalSwitches: 2,
              //           labels: ['YES', ''],
              //           icons: [null, FontAwesomeIcons.times],),
              //       ],),),)),
              Padding(
                padding:
                    EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 0),
                child: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(
                        left: 20, right: 0, top: 0, bottom: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: Colors.black45, width: 4),
                    ),
                    hintText: email,
                    hintStyle: TextStyle(color: Colors.black45),
                    suffixIconColor: Colors.black45,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(
                          left: 0, right: 20, top: 0, bottom: 0),
                      child: Icon(
                        Icons.email,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: loadingAnim,
                child: SizedBox(
                    height: 120,
                    width: 120,
                    child: Lottie.asset('assets/animations/loading_anim.json',
                        reverse: false)),
              ),
              Expanded(flex: 1, child: Container()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0 , vertical: 20),
                child: Visibility(
                  visible: widget.editProfile,
                  child: UiHelper.CustomButton(() {
                    saveProfile();
                  }, "Save Profile"),
                  // child: AnimatedButton(
                  //   height: 40,
                  //   width: 200,
                  //   text: 'Save Profile',
                  //   isReverse: true,
                  //   selectedTextColor: Colors.white,
                  //   transitionType: TransitionType.LEFT_TO_RIGHT,
                  //   textStyle: TextStyle(
                  //       fontSize: 16,
                  //       fontWeight: FontWeight.w500,
                  //       color: Colors.black),
                  //   backgroundColor: Colors.blue.shade200,
                  //   borderColor: Colors.blue.shade700,
                  //   borderRadius: 50,
                  //   borderWidth: 1.75,
                  //   selectedBackgroundColor: Colors.blue.shade700,
                  //   animationDuration: Duration(seconds: 2),
                  //   selectedText: "Profile Saved",
                  //   onPress: () {
                  //     saveProfile();
                  //   },
                  // ),
                ),
              ),
              Visibility(
                visible: savingProfile,
                child: SizedBox(
                    height: 120,
                    width: 120,
                    child: Lottie.asset('assets/animations/loading_anim.json',
                        reverse: false)),
              ),
              Expanded(flex: 2, child: Container()),
            ],
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: !widget.editProfile,
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
              side: BorderSide(color: Colors.indigo, width: 2)),
          child: Icon(Icons.edit),
          onPressed: () {
            Navigation.pushReplacementNavigation(
                context,
                ProfileScreen(
                  editProfile: true,
                  email: email,
                ));
          },
        ),
      ),
    );
  }
}
