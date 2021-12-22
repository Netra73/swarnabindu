import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sawarnabindudc/Functions/UserData.dart';
import 'package:sawarnabindudc/Functions/config.dart';
import 'package:intl/intl.dart';
import 'package:sawarnabindudc/Layouts/Issuematerial.dart';
import 'package:sawarnabindudc/Modules/HistoryList.dart';
import 'package:sawarnabindudc/Styles/textstyle.dart';

import 'FilterDialog.dart';

class IssueHistory extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return ReportState();
  }
}

class ReportState extends State<IssueHistory>{
  String mail,year,month,strmaterial='All',stremp='All';
  List<HistoryList>historyList = [];

  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy');
  var formatter2 = new DateFormat('MM');
  var formatter3 = new DateFormat('dd-MM-yyyy');


  @override
  void initState() {
    year = formatter.format(now);
    month = formatter2.format(now);
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:PreferredSize(
        preferredSize: Size.fromHeight(45.0),
        child:  AppBar(
          actions: <Widget>[
            Row(
              children: [
//                IconButton(
//                  icon: Icon(
//                    Icons.refresh,
//                    color: Colors.black,
//                  ),
//                  onPressed: () {
//                      setState(() {
//
//                      });
//                  },
//                ),
               RaisedButton(
                 onPressed: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context) => Issuematerial())).then((value) => {
                     setState(() {
                       getData('USERData').then((value) {
                         var udata = jsonDecode(value);
                         mail = udata['email'].toString();
                         year = formatter.format(now);
                         month = formatter2.format(now);
                         strmaterial   =  'All';
                         stremp   =  'All';
                       });
                     })
                   });
                 },
                 child: Text('Transfer'),
                 color: Colors.black,
                 textColor: Colors.white,
               ),
                IconButton(
                  icon: Icon(
                    Icons.filter_list,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    filterdialog();
                  },
                ),
              ],
            )
          ],
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Text('Issue Material History',style: TextStyle(fontSize: 18.0,color: Colors.blue),),
        ),
      ),
      body:Container(
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
                  'employee':stremp,
                };
                return FutureBuilder(
                  future: getHistory(body),
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      var response = jsonDecode(snapshot.data);
                      if(response['status'] == 200) {
                        historyList.clear();
                        var data = response['data'];
                        for (var details in data) {
                          String id = details['id'];
                          String date = details['date'];
                          var employee = details['employee'];
                          String eid = employee['id'];
                          String name = employee['name'];
                          String material = details['material'];
                          String quantity = details['quantity'];
                          String type = details['type'];
                          String aa;
                          Text bb;
                          if(type=="0"){
                             aa = "+$quantity";
                              bb = Text('+$quantity',style: TextStyle(color: Colors.green),);
                          }else{
                            aa = "-$quantity";
                            bb = Text('-$quantity',style: TextStyle(color: Colors.green),);
                          }

                          if(eid == null){
                            name = 'Admin';
                          }
                          String dateFormate = DateFormat("dd-MM-yyyy").format(
                              DateTime.parse(date));
                          historyList.add(HistoryList(id, name, aa,
                              dateFormate,
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
                                             if(historyList[i].type == "0")Text(historyList[i].qnty, style: TextStyle(fontSize: 18,
                                                 color: Colors.green)),
                                             if(historyList[i].type == "1")Text(historyList[i].qnty, style: TextStyle(fontSize: 18,
                                                 color: Colors.red)),
                                           ],
                                         ),
                                         SizedBox(height: 7),
                                         Text(historyList[i].empname, style: TextStyle(fontSize: 17),),
                                         SizedBox(height: 2),
                                         Text(historyList[i].date, style: TextStyle(fontSize: 17, color: Colors.grey),),
                                       ],
                                     ),
                                   ),
                                 ),
                               );
                            });
                      }if(response['status'] == 422){
                         return Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text('No Data',style: TextStyle(fontSize: 20),),
                         );
                      }
                    }
                     return Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Text('Loading...',style: TextStyle(fontSize: 20)),
                     );
                  }
                );
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Loading...',style: TextStyle(fontSize: 20),),
            );
          }
        ),
      )
         );
  }


  Future<String> getHistory(body) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(
        Uri.parse(API_URL + 'issueMaterialHistory'));
    request.headers.set('Content-type', 'application/json');
    request.add(utf8.encode(json.encode(body)));
    HttpClientResponse response = await request.close();
    httpClient.close();
    if (response.statusCode == 200) {
      String reply = await response.transform(utf8.decoder).join();
      print('historyyyyyyy $reply');
      return reply;
    }
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
             print('historyData $jdata');
             year =  jdata['year'].toString();
             month =  jdata['month'].toString();
             mail   =  jdata['user'].toString();
             strmaterial   =  jdata['material'].toString();
             stremp   =  jdata['employee'].toString();
           });
    });
  }

}

