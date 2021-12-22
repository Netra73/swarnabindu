import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sawarnabindudc/Functions/UserData.dart';
import 'package:sawarnabindudc/Functions/config.dart';
import 'package:sawarnabindudc/Layouts/DashBoard.dart';
import 'package:sawarnabindudc/Layouts/EditCard.dart';
import 'package:sawarnabindudc/Layouts/HomePage.dart';
import 'package:sawarnabindudc/Layouts/Viewallstock.dart';
import 'package:sawarnabindudc/Modules/stockModule.dart';
import 'package:sawarnabindudc/Modules/stockModule.dart';
import 'package:sawarnabindudc/Modules/todaysModule.dart';
import 'package:sawarnabindudc/Styles/textstyle.dart';


import 'Camp.dart';
import 'DReports.dart';
import 'DatabaseHelper.dart';
import 'EditProfile.dart';
import 'IssueHistory.dart';
import 'Login.dart';
import 'MonthlyKit.dart';
import 'SurveyDialog.dart';
import 'campDialog.dart';

class Stock extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return StockState();
  }
}

class StockState extends State<Stock>{
  String id,c100,c80,med,email,dateformat2,dateformat3,Ename = "Name",Epost = "post",mobile,taluk,district,gender;
  List<stockModule>stockList = [];
  List<TodayasModule>todaysList = [];
  bool tlist = false;
  bool hdata = false;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    dateformat2 = DateFormat("yyyy-MM-dd").format(selectedDate);
    dateformat3 = DateFormat("dd-MM-yyyy").format(selectedDate);
    getData("USERData").then((value) {
      var data = jsonDecode(value);
      id = data['id'].toString();
      email = data['email'].toString();

      getStock(id).then((value) {
        var response = jsonDecode(value);
        if(response['status'] == 200) {
          var data = response['data'];
          var profile = data['profile'];
          String name = profile['name'];
          String post = profile['post'];
          Ename = name;
          Epost = post;
        }
        setState(() {

        });
      });

    });
    setState(() {

    });
  }

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
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar:  PreferredSize(
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
                  SizedBox(height: 5),
                  Text('Hello, ',style: TextStyle(fontSize:18,color: Colors.white),),
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
//                  IconButton(icon: Icon(Icons.edit,size: 30,color: Colors.white,),
//                    onPressed: (){
//                      Navigator.push(context, MaterialPageRoute(builder: (context)=> EditProfile(id,Ename,mobile,email,gender,taluk,district,Epost))).then((value) {
//                        setState(() {
//                          getStock(id).then((value) {
//                            var response = jsonDecode(value);
//                            if(response['status'] == 200) {
//                              var data = response['data'];
//                              var profile = data['profile'];
//                              String name = profile['name'];
//                              String post = profile['post'];
//                              Ename = name;
//                              Epost = post;
//                            }
//                            setState(() {
//
//                            });
//                          });
//
//                        });
//                      });
//                    },
//                  ),
                  IconButton(icon: Icon(Icons.exit_to_app,size:35,color: Colors.white,), onPressed: () {
                    removeData("USERData").then((value) {
                      removeData("USERMail").then((value) {
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                            Login()), (Route<dynamic> route) => false);
                      });
                    });
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    side: BorderSide(width: 0.2),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 8,right: 8,bottom: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Stock',style: mainStyle.text18BoldM,),
                            GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> viewAllStock()));
                                },
                                child: Icon(Icons.arrow_forward_ios,size: 23,)),
                          ],
                        ),
                      ),
                      SizedBox(height: 8),
                      FutureBuilder(
                        future: getData("USERData"),
                        builder: (context,snap2){
                          if(snap2.hasData){
                            var data = jsonDecode(snap2.data);
                            id = data['id'].toString();
                            email = data['email'].toString();
                            return FutureBuilder(
                              future: getStock(id),
                              builder: (context,snapshot2){
                                if(snapshot2.hasData){
                                  var response = jsonDecode(snapshot2.data);
                                  if(response['status']==200){
                                    stockList.clear();
                                    var data = response['data'];
                                    var accounts = data['account'];
                                    var summary = accounts['summary'];
                                    for(var details in summary){
                                      String name = details['name'].toString();
                                      String total = details['total'].toString();

                                      if(name=='Cards-100' || name=='Cards-80' || name=='Big dose'){
                                        total = details['total'].toString();
                                        String cc = total;
                                        stockList.add(stockModule(name,cc));
                                      }
                                    }
                                    return  Padding(
                                      padding: const EdgeInsets.only(left: 4,right: 8),
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 8),
                                        child: Column(
                                            children: <Widget>[
                                              ListView.separated( shrinkWrap: true,
                                                itemCount: stockList.length,
                                                itemBuilder: (context,i){
                                                  return Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Icon(Icons.credit_card,color: Colors.blue,),
                                                          SizedBox(width: 6),
                                                          Text(stockList[i].cname.toString(), style: new TextStyle(fontSize: 18.0)),
                                                        ],
                                                      ),
                                                      Text(stockList[i].ctotal.toString(),
                                                          style: new TextStyle(fontSize: 18.0)),
                                                    ],
                                                  );
                                                },
                                                separatorBuilder: (context, index) {
                                                  return Divider();
                                                },),
                                            ]),
                                      ),
                                    );
                                  }
                                  if(response['status']==422){
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('No Data',style: mainStyle.text18),
                                    );
                                  }
                                }
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Loading..',style: mainStyle.text18),
                                );
                              }
                              ,);
                          }
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('loading',style: TextStyle(fontSize: 20),),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

Future<String> getStock(String ide) async {
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.getUrl(
      Uri.parse(API_URL + 'Athentication/user/'+ide));
  request.headers.set('Content-type', 'application/json');
  HttpClientResponse response = await request.close();
  httpClient.close();
  if (response.statusCode == 200) {
    String reply = await response.transform(utf8.decoder).join();
    return reply;
  }
}

