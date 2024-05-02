

import 'package:flutter/material.dart';

class MultipleChoiceQuestion{
  String question;
  String A;
  String B;
  String C;
  String D;
  String ansOption;
  String correctAns = "null";



  MultipleChoiceQuestion({required this.question ,required this.A ,required this.B ,required this.C ,required this.D ,required this.ansOption  }){
    correctAns = getStringFromOption(ansOption , A , B , C , D);
  }

  // factory MultipleChoiceQuestion.fromJson(Map<String, dynamic> json){
  //   return MultipleChoiceQuestion(question: json[0], ans: json[1]);
  // }

  static getStringFromOption(String ansOption , String A ,String B,String C, String D){
    if(ansOption == "A"){
      return A;
    }else if(ansOption == "B"){
      return B;
    }else if(ansOption == "C"){
      return C;
    }else if(ansOption == "D"){
      return D;
    }
    return "null";
  }



}