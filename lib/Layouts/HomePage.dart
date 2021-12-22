import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sawarnabindudc/Functions/UserData.dart';
import 'package:sawarnabindudc/Functions/config.dart';
import 'package:sawarnabindudc/Layouts/EditCard.dart';
import 'package:sawarnabindudc/Layouts/Viewallstock.dart';
import 'package:sawarnabindudc/Modules/stockModule.dart';
import 'package:sawarnabindudc/Modules/stockModule.dart';
import 'package:sawarnabindudc/Modules/todaysModule.dart';
import 'package:sawarnabindudc/Styles/textstyle.dart';


import 'Camp.dart';
import 'DReports.dart';
import 'DatabaseHelper.dart';
import 'HomePage2.dart';
import 'IssueHistory.dart';
import 'MonthlyKit.dart';
import 'SurveyDialog.dart';
import 'campDialog.dart';

class HomePage extends StatefulWidget{
  int i;
  HomePage(this.i);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomePageState(i);
  }
}

class HomePageState extends State<HomePage>{
  int i;
  HomePageState(this.i);

  String id,c100,c80,med,email,dateformat2,dateformat3;
 List<stockModule>stockList = [];
 List<TodayasModule>todaysList = [];
 bool tlist = false;
 bool hdata = false;
 DateTime selectedDate = DateTime.now();


 int _currentIndex = 0;
 List<Widget> _children = [
   HomePage2(),
   CampDialog(),
   SurveyDialog(),
   IssueHistory(),
   MonthlyKit(),
   DReports(),
 ];


 @override
  void initState() {
     dateformat2 = DateFormat("yyyy-MM-dd").format(selectedDate);
     dateformat3 = DateFormat("dd-MM-yyyy").format(selectedDate);
    // TODO: implement initState
    getData("USERData").then((value) {
       var data = jsonDecode(value);
       id = data['id'].toString();
       email = data['email'].toString();
       _currentIndex = i;
    });
    DatabaseHelper.instance.getPendingCount().then((value) {
      setState(() {
        if(value.isNotEmpty){
          hdata = true;
        }
        else{
          hdata = false;
        }
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

//    var drawerOptions = <Widget>[];
//    for (var i = 0; i < 4; i++) {
//      var d = widget.drawerItems[i];
//      drawerOptions.add(
//          new ListTile(
//            selected: i == _selectedDrawerIndex,
//            onTap: () => _onSelectItem(i),
//          )
//      );
//    }


    // TODO: implement build
    return Scaffold(
       body: _getDrawerItemWidget(_currentIndex),
    );


  }

 _getDrawerItemWidget(int pos) {
   switch (pos) {
     case 0:
       return new HomePage2();
     case 1:
       return new CampDialog();
     case 2:
       return new SurveyDialog();
     case 3:
       return new IssueHistory();
     case 4:
       return new MonthlyKit();
     default:
       return new HomePage2();
   }
 }
 void onTabTapped(int index) {
   setState(() {
     _currentIndex = index;
   });
 }

 void SyncMethod(context,var body,String emailId,String camp) {
    _showLoading();
     submitSync(body, emailId).then((value) {
     Navigator.pop(context);
     var responce = jsonDecode(value);
     if(responce['status'] == 200) {
       _showLoading();
       DatabaseHelper.instance.deleteCustomer(" ",camp).then((value){
         Navigator.pop(context);
         setState(() {
         });
         DatabaseHelper.instance.getPendingCount().then((value) {
           setState(() {

           });
           if(value.isNotEmpty){
             hdata = true;
           }else{
             hdata = false;
           }
           setState(() {

           });
         });
         setState(() {

         });
       });
     }
     if(responce['status'] == 422 ){
       _showLoading();
       var data = responce['data'];
       List dnum = [];
       String card;
       String id;
       String s;
       String st;
       for(var details in data){
         id = details['id'].toString();
         card = details['card'].toString();
         String status = details['status'].toString();
         dnum.add(id);
         s = dnum.join("','");
         st = '\'$s\'';
       }

      DatabaseHelper.instance.deleteCustomer(st,camp).then((value){
        Navigator.pop(context);
        setState(() {

        });
        Navigator.push(context, MaterialPageRoute(builder: (context)=>EditCard(camp))).then((value) {
          DatabaseHelper.instance.getPendingCount().then((value) {
            if(value.isNotEmpty){
              hdata = true;
            }else{
              hdata = false;
            }
            setState(() {

            });
          });
        });
      });
     }
   });
 }

 Future<List<Map>> fetchOfflineDatabase() async {
   DatabaseHelper.instance.getPendingCount().then((value) {
   });
   return DatabaseHelper.instance.getPendingCount();
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


Future<String> submitSync(body,String emaill) async {
  var sdata = {
    "emp":emaill,
    "data":body
  };
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.postUrl(Uri.parse(API_URL2+'syncCustomer'));
  request.headers.set('Content-type', 'application/JSON');
  request.add(utf8.encode(jsonEncode(sdata)));
  HttpClientResponse response = await request.close();
  httpClient.close();
  if(response.statusCode==200) {
    String reply = await response.transform(utf8.decoder).join();
    return reply;
  }
}
