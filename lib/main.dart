import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:Scaffold(
        appBar: AppBar(
          title: Text("Lista de Usuarios"),
        ),
        body: UserList(),
      )
    );
  }
}

class User{
  String name,username,photoavatar;
  User(this.name,this.username,this.photoavatar);
  User.fromJson(Map<String,dynamic> json)
   : name = json['name'],
    username = json['email'],
    photoavatar = json['picture'];
}

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<User> users;
  bool loading;

  void _loadUsers() async{
   final response = await http.get("http://www.json-generator.com/api/json/get/cfsXVKXcVu?indent=2");
   final json = jsonDecode(response.body);
   List<User> _users = [];
   for(var JsonObject in json){
    _users.add(User.fromJson(JsonObject));
   }
   setState(() {
     users = _users;
     loading = false;
   });
  }
  void initState() {
    users =[];
    loading = true;
    _loadUsers();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if(loading){
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView.builder(
     itemBuilder: (context,index){
       return ListTile(
         title: Text(users[index].name),
         subtitle: Text(users[index].username),
         leading: CircleAvatar(
           backgroundImage: NetworkImage(users[index].photoavatar),
         )
       );
     },
      itemCount: users.length,
    );
  }
}

