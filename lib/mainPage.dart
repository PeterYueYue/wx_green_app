import 'package:flutter/material.dart';
import 'package:flutter_app/unit/request.dart';
import 'Tabs.dart';
import 'login.dart';
import 'unit/request.dart';

class ManiPage extends StatefulWidget{
  ManiPage({Key key}) : super (key:key);
  _ManiPageState createState() => _ManiPageState();

}

class _ManiPageState extends State<ManiPage>{
  var token = "";
  @override
  initState() {
    super.initState();
    setState(() {
      token = myToken;
    });

  }
  _editToken(token){
    print("///////////////////////*********//////////////////");
    print(token);

    setState(() {
      token = token;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: this.token == ""?Login(editToken: (token) => _editToken(token)):Tabs(),
    );
  }





}