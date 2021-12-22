import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sawarnabindudc/Functions/UserData.dart';
import 'package:sawarnabindudc/Layouts/DReports.dart';
import 'package:sawarnabindudc/Layouts/EditProfile.dart';
import 'package:sawarnabindudc/Layouts/HomePage2.dart';
import 'package:sawarnabindudc/Layouts/IssueHistory.dart';
import 'package:sawarnabindudc/Layouts/Login.dart';
import 'package:sawarnabindudc/Layouts/MonthlyKit.dart';
import 'package:sawarnabindudc/Layouts/SurveyDialog.dart';

import 'campDialog.dart';

class DashBoard extends StatefulWidget{
  int a;
  DashBoard(int pindex){
    this.a = pindex;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
     return DashBoardState(a);
  }

}

class DashBoardState extends State<DashBoard>{
  int a;
  int _currentIndex;
  DashBoardState(int pindex){
    _currentIndex = pindex;
    a = pindex;
  }

  String id,Ename = "Name",Epost = "post",email,mobile,taluk,district,gender,distName="";
  bool lPost = false,homeTrue = false;
  List<String>_images = ['images/mainimg.png','images/mainimg.png','images/mainimg.png'];
  var nameHolder = TextEditingController();
  var postHolder = TextEditingController();


  List<Widget> _children = [
    HomePage2(),
     CampDialog(),
    SurveyDialog(),
    IssueHistory(),
    MonthlyKit(),
    DReports(),
  ];
  _showLoading() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  child: CircularProgressIndicator(),
                  height: 40.0,
                  width: 40.0,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    _currentIndex = a;
    getData("USERData").then((value) {
      getData("selDist").then((dvalue){
        distName=dvalue;
        setState(() {
          if(value!=null){
            var udata = jsonDecode(value);
            id = udata['id'];
            String name = udata['name'];
            String post = udata['post'];
            nameHolder.text = name;
            postHolder.text = post;
            Ename = name;
            Epost = post;
          }
        });
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
       appBar: PreferredSize(
         preferredSize: Size.fromHeight(80.0),
         child: AppBar(
           backgroundColor: Colors.orange,
           automaticallyImplyLeading: false,
           flexibleSpace: Container(
            child:  Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 6),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: "$Ename",
                        style: TextStyle(fontSize: 22),
                        children: <TextSpan>[
                          TextSpan(
                            text: '  $Epost',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ]
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(distName,style: TextStyle(fontSize:18,color: Colors.white),),
                ],
              ),
            ),
           ),
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.vertical(
               bottom: Radius.circular(15),
             ),
           ),
           actions: <Widget> [
         Padding(
           padding: const EdgeInsets.only(right: 8,top: 10),
           child: Row(
             children: [
               IconButton(icon: Icon(Icons.home,size:35,color: Colors.white,), onPressed: () {
                  Navigator.pop(context);
               }),
             ],
           ),
         ),
           ],
         ),
       ),
      body: _children[_currentIndex],
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
            canvasColor: Colors.lightBlue[800],
            primaryColor: Colors.orange,
            textTheme: Theme
                .of(context)
                .textTheme
                .copyWith(caption: new TextStyle(color: Colors.white))), // sets the inactive color of the `BottomNavigationBar`
        child:  BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, //
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.art_track),
            title: new Text('Camp'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.find_in_page),
              title: Text('Create Camp')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment_late),
              title: Text('Material')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              title: Text('Kit')
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.timeline),
              title: Text('Reports')
          ),
        ],
      ),
      ),
      );
  }

  void onTabTapped(int index) {
    if(index==0){
      Navigator.pop(context);
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

}

