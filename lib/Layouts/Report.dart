import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sawarnabindudc/Functions/UserData.dart';
import 'package:sawarnabindudc/Functions/config.dart';
import 'package:sawarnabindudc/Modules/HistoryList.dart';

import 'FilterDialog.dart';
import 'IssueHistory.dart';

class Report extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return stateReport();
  }
}

class stateReport extends State<Report>{
  String mail,year,month,strmaterial='Big Dose',stremp='All';
  List<HistoryList>historyList = [];
  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy');
  var formatter2 = new DateFormat('MM');

  String tIn;

  @override
  void initState() {
    year = formatter.format(now);
    month = formatter2.format(now);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
     return Scaffold(
       appBar: AppBar(
         actions: [
           IconButton(
             icon: Icon(Icons.filter_list,color: Colors.black,),
             onPressed: (){
               filterdialog();
             },
           )
         ],
         backgroundColor: Colors.white,
          title: Text('Report',style: TextStyle(color: Colors.blue,fontSize: 24),),
         leading: MaterialButton(
           onPressed: (){
             Navigator.pop(context);
           },
           child: Icon(Icons.arrow_back,size: 30,color: Colors.black,),
         ),
       ),
       body: Container(
         child: FutureBuilder(
             future: getData('USERData'),
             builder: (context,snapshot){
               if(snapshot.hasData){
                 var udata = jsonDecode(snapshot.data);
                 mail = udata['email'];
                 var body = {
                   'user': mail,
                   'year':year,
                   'month': month,
                   'material': strmaterial ,
                   'employee': stremp,
                 };
                 return FutureBuilder(
                     future: getHistory(body),
                     builder: (context,snapshot){
                       if(snapshot.hasData){
                         var response = jsonDecode(snapshot.data);
                         if(response['status']==200) {
                           historyList.clear();
                           var data = response['data'];
                           for (var details in data) {
                             var employee = details['employee'];
                             String id = employee['id'];
                             String name = employee['name'];
                             String material = details['material'];
                             String totalIn = details['totalIn'];
                             String totalOut = details['totalOut'];
                             String type = details['type'];
                             historyList.add(HistoryList(id, name, totalIn, totalOut,
                                 material,type));
                           }

                           return ListView.builder(
                               itemCount: historyList.length,
                               itemBuilder: (context,i){
                                 return  Padding(
                                   padding: const EdgeInsets.all(2.0),
                                   child: Card(
                                     elevation: 2,
                                     child: Padding(
                                       padding: const EdgeInsets.all(10.0),
                                       child: Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         mainAxisSize: MainAxisSize.min,
                                         children: [
                                           Row(
                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                             children: [
                                               Text(historyList[i].materialname, style: TextStyle(fontSize: 17,
                                                   color: Colors.blue),),
                                               Text('$month-$year', style: TextStyle(fontSize: 18,
                                                   color: Colors.grey)),
                                             ],
                                           ),
                                           SizedBox(height: 7),
                                           Text(historyList[i].empname, style: TextStyle(fontSize: 17),),
                                           SizedBox(height: 2),
                                           Row(
                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                             children: [
                                               Text('Issued : ${historyList[i].qnty}',
                                                 style: TextStyle(fontSize: 17, color: Colors.blueGrey),),
                                               Text('Spent : ${historyList[i].date}',
                                                 style: TextStyle(fontSize: 17, color: Colors.blueGrey),),
                                             ],
                                           ),
                                         ],
                                       ),
                                     ),
                                   ),
                                 );
                               });
                         }if(response['status']==422){
                         return  Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Text('No Data',style: TextStyle(fontSize: 20),),
                           );
                         }
                       }
                       return Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Text('Loading',style: TextStyle(fontSize: 20)),
                       );
                     }
                 );
               }
               return Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Text('loading',style: TextStyle(fontSize: 20),),
               );
             }
         ),
       ),
     );
  }

  filterdialog() {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
          child: filterdialogState(),
        );
      },
    ).then((value){
      setState(() {
        var jdata = jsonDecode(value);
        print('dialogdatatata $jdata');
        year =  jdata['year'].toString();
        month =  jdata['month'].toString();
        mail   =  jdata['user'].toString();
        strmaterial   =  jdata['material'].toString();
        stremp   =  jdata['employee'].toString();
      });
    });
  }

  Future<String> getHistory(body) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(
        Uri.parse(API_URL + 'getReport'));
    request.headers.set('Content-type', 'application/json');
    request.add(utf8.encode(json.encode(body)));
    HttpClientResponse response = await request.close();
    httpClient.close();
    if (response.statusCode == 200) {
      String reply = await response.transform(utf8.decoder).join();
      return reply;
    }
  }


}