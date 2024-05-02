
import 'dart:io' ;
import 'dart:math';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Utils{
  static getMoth(int i){
    switch(i){
      case 1:

    }
  }
}

class Navigation{


  static pushReplacementNavigation(BuildContext context , Widget widget) {
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return widget;
      },
    ));
  }

  static pushNavigation(BuildContext context , Widget widget){
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return widget;
      },
    ));
  }

  static pushAndPotNavigation(BuildContext context , String name){
    Navigator.popAndPushNamed(context, name);
  }

  static CustomAlertDialogBox(){

  }
}

class PermissionUser{

  static Future<void> requestPermission(Permission permission, isGranted() , isDenined() ) async {
    if(await checkPermissionStatus(permission)){
      isGranted();
    }else{
      if (await permission.isDenied) {
        final result = await permission.request();

        if (result.isGranted) {
          isGranted();
          // Permission is granted
        } else if (result.isDenied) {
          isDenined();
          // Permission is denied
        } else if (result.isPermanentlyDenied) {
          // Permission is permanently denied
          isDenined();
          openSettings();
        }
      }
    }
  }

  static Future<void> requestPermissionRecurring(Permission permission) async {

    if (await permission.isDenied) {
      await permission.request();
    }
  }

  static Future<bool> checkPermissionStatus(Permission permission) async {

    return await permission.status.isGranted;
  }

  static void openSettings() {
    openAppSettings();
  }
}

class FirebaseMethods{

  static Future<User?> getCurrentUser() async {
    if(FirebaseAuth.instance.currentUser != null){
      return FirebaseAuth.instance.currentUser;
    }
    return null;
  }

  Future<File> urlToFile(String strURL) async {
    //PermissionUser.requestPermission(Permission.storage, () {}, () {});
    final http.Response responseData = await http.get(Uri.parse(strURL));
    Uint8List uint8list = responseData.bodyBytes;
    var buffer = uint8list.buffer;
    ByteData byteData = ByteData.view(buffer);
    var tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/img').writeAsBytes(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    print("Utility    " + file.path);
    print(file);
    return file;
  }
  // static Future<File> urlToFile(String imageUrl) async {
  //   // generate random number.
  //   var rng = new Random();
  //   // get temporary directory of device.
  //   Directory tempDir = await getTemporaryDirectory();
  //   // get temporary path from temporary directory.
  //   String tempPath = tempDir.path;
  //   print("Utility " + tempPath);
  //   // create a new file in temporary path with random file name.
  //   File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
  //   print("Utility " + file.path);
  //   // call http.get method and pass imageurl into it to get response.
  //   http.Response response = await http.get(Uri.parse(imageUrl));
  //   print("Utility " + response.body);
  //   // write bodybytes received in response to file.
  //   await file.writeAsBytes(response.bodyBytes);
  //   print("Utility " + file.path);
  //   // now return the file which is created with random name in
  //   // temporary directory and image bytes from response is written to // that file.
  //   return file;
  // }
}