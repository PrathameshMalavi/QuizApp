

class TF_Question{
  String question;
  bool ans;

  TF_Question({required this.question ,required this.ans});

  factory TF_Question.fromJson(Map<String, dynamic> json){
    return TF_Question(question: json[0], ans: json[1]);
  }



}