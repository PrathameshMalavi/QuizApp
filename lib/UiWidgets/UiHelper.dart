import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Util/UtilityMethods.dart';

class UiHelper {
  static CustomTextField(TextEditingController controller, String text,
      IconData iconData, bool hide) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: TextField(
        controller: controller,
        obscureText: hide,
        decoration: InputDecoration(
            hintText: text,
            suffixIcon: Icon(iconData),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
            )),
      ),
    );
  }

  static CustomButton(VoidCallback voidCallback, String text) {
    return SizedBox(
        height: 50,
        width: 320,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: MaterialStateColor.resolveWith((states) {
                  if (states == MaterialState.disabled) {
                    return Colors.blueAccent;
                  } else if (states == MaterialState.pressed) {
                    return Colors.blue;
                  }
                  return Colors.blueAccent;
                }),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25))),
            onPressed: voidCallback,
            child: Text(
              text,
              style: TextStyle(color: Colors.black, fontSize: 20),
            )));
  }

  static CustomAlertBox(BuildContext context, String text ) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              text,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
            icon: Icon(Icons.crisis_alert, color: Colors.black, size: 35),
            backgroundColor: Colors.lightBlueAccent.shade100,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            actions: [
              Center(
                child: ElevatedButton(
                    onPressed: () {

                      Navigator.pop(context);
                    },
                    child: Text("OK")),
              )
            ],
          );
        });
  }


  static CustomAlertBoxwithNextPage(BuildContext context, String text , Widget widget ) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              text,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
            icon: Icon(Icons.crisis_alert, color: Colors.black, size: 35),
            backgroundColor: Colors.lightBlueAccent.shade100,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            actions: [
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      UiHelper.Customavigator(context, widget);
                    },
                    child: Text("OK")),
              )
            ],
          );
        });
  }

  static CustomAppBar(String text) {
    return AppBar(
      backgroundColor: Colors.blueAccent,
      title: Text(
        text,
      ),
    );
  }

  static Customavigator(BuildContext context, Widget widget) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => widget));
  }

  static CustomavigatorWithoutReplacement(BuildContext context, Widget widget) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
  }

  // static CustomColor(String colorHex){
  //   return Color(int.parse(hexColor.substring(1, 7), radix: 16) + colorHex);
  // }

  static customOtpUi(
      VoidCallback vaidatorCallback, VoidCallback onCompletedCallback) {
    return ();
  }

  static newCustomTextField(TextEditingController controller, String text,
      IconData iconData, bool hide) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: TextField(
        controller: controller,
        obscureText: hide,
        decoration: InputDecoration(
            hintText: text,
            suffixIcon: Icon(iconData),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
            )),
      ),
    );
  }

  static newCustomButton(VoidCallback voidCallback, String text, double opacity) {
    return SizedBox(
        height: 50,
        width: 320,
        child: Opacity(
          opacity: opacity,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: MaterialStateColor.resolveWith((states) {
                    if (states == MaterialState.disabled) {
                      return Colors.blueAccent;
                    } else if (states == MaterialState.pressed) {
                      return Colors.blue;
                    }
                    return Colors.blueAccent;
                  }),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25))),
              onPressed: voidCallback,
              child: Text(
                text,
                style: TextStyle(color: Colors.black, fontSize: 20),
              )),
        ));
  }

  static newCustomAlertBox(BuildContext context, String text) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              text,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
            icon: Icon(Icons.crisis_alert, color: Colors.black, size: 35),
            backgroundColor: Colors.lightBlueAccent.shade100,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            actions: [
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("OK")),
              )
            ],
          );
        });
  }

  static newCustomAlertBoxwithNextPage(
      BuildContext context, String text, Widget widget) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              text,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
            icon: Icon(Icons.crisis_alert, color: Colors.black, size: 35),
            backgroundColor: Colors.lightBlueAccent.shade100,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            actions: [
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigation.pushReplacementNavigation(context, widget);
                    },
                    child: Text("OK")),
              )
            ],
          );
        });
  }

  static newCustomAppBar(String text) {
    return AppBar(
      backgroundColor: Colors.blueAccent,
      title: Text(
        text,
      ),
    );
  }

  static newCustomSnackBar(BuildContext context, String snackBarText ,IconData snackBarIcon ){
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(snackBarIcon),
          Container(
            width: 20,
          ),
          Text(snackBarText)
        ],
      ),
      duration: Duration(seconds: 2),
      showCloseIcon: false,
    ));
  }


// static final defaultPinTheme = PinTheme(
  //   width: 56,
  //   height: 56,
  //   textStyle: TextStyle(
  //       fontSize: 20,
  //       color: Color.fromRGBO(30, 60, 87, 1),
  //       fontWeight: FontWeight.w600),
  //   decoration: BoxDecoration(
  //     border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
  //     borderRadius: BorderRadius.circular(20),
  //   ),
  // );
  //
  // static final focusedPinTheme = PinTheme(
  //   width: 56,
  //   height: 56,
  //   textStyle: TextStyle(
  //       fontSize: 20,
  //       color: Color.fromRGBO(30, 60, 87, 1),
  //       fontWeight: FontWeight.w600),
  //   decoration: BoxDecoration(
  //     border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
  //     borderRadius: BorderRadius.circular(8),
  //   ),
  // );
  //
  // static final submittedPinTheme = PinTheme(
  //   width: 56,
  //   height: 56,
  //   textStyle: TextStyle(
  //       fontSize: 20,
  //       color: Color.fromRGBO(30, 60, 87, 1),
  //       fontWeight: FontWeight.w600),
  //   decoration: BoxDecoration(
  //     color: Color.fromRGBO(234, 239, 243, 1),
  //     border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
  //     borderRadius: BorderRadius.circular(20),
  //   ),
  // );
}
