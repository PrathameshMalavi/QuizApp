import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  List<dynamic> users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Center(
          child: Text("Users",
              style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
      body: Center(
        child: ListView.builder(
          itemBuilder: (context, index) {
            final user = users[index];
            final email = user["email"];
            final age = user["registered"]["age"];
            final name = "${index + 1}.  " +
                user["name"]["title"] +
                user["name"]["first"] +
                user["name"]["last"];
            final image = user["picture"]["thumbnail"];
            return ListTile(
              leading: CircleAvatar(
                  child: Image.network(image)),
              title: Text(name),
              subtitle: Text(email),
              trailing: Container(
                width: 60 ,
                child: Row(
                  children: [
                    Text(age.toString()), Container(width: 20,),
                    Icon(Icons.remove_red_eye)
                  ],
                ),
              ),
            );
          },
          itemCount: users.length,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchUsers,
      ),
    );
  }

  Future<void> fetchUsers() async {
    print("FetchUsers");
    const url = "https://randomuser.me/api/?results=10";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    setState(() {
      users = json['results'];
    });

    print("fetchUsers Completed");
  }
}
