import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sawarnabindudc/Layouts/DashBoard.dart';
import 'package:sawarnabindudc/Layouts/Issuematerial.dart';

import 'Functions/UserData.dart';
import 'Functions/config.dart';
import 'Layouts/HomePage2.dart';
import 'Layouts/Login.dart';
import 'Layouts/IssueHistory.dart';
import 'Layouts/Report.dart';


void main() {
  runApp(MaterialApp(
    home: mainScreen(),
  ));
}


class mainScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _mainState();
  }
}

class _mainState extends State<mainScreen>{
  String password;
  BuildContext mcontext;

  @override
  void initState() {
       checkData("USERData").then((value) {
           if(value){
             setState(() {
               Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                   HomePage2()), (Route<dynamic> route) => false);
             });
           }else{
             Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> Login()), (Route<dynamic>route) => false);
           }
       });
  }

  @override
  Widget build(BuildContext context) {
    mcontext = context;
    return Scaffold(
      backgroundColor: Colors.white,
    );
  }
}