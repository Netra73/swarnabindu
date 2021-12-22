import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sawarnabindudc/Layouts/EditCardData.dart';

import 'DatabaseHelper.dart';

class EditCard extends StatefulWidget{
  String cedata;
  EditCard(this.cedata);

  @override
  State<StatefulWidget> createState() {
     return EditCardState(cedata);
  }
}

class EditCardState extends State<EditCard>{
  String cedata;
  EditCardState(this.cedata);
  String cmpId;

  @override
  void initState() {
    cmpId = cedata;
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
     return Scaffold(
       appBar: AppBar(
         title: Text('Invalid Cards'),
       ),
        body: Padding(
          padding: const EdgeInsets.only(left: 6,right: 6,top: 6),
          child: Column(
            children: [
              Text(''),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                    side: BorderSide(width: 0.2),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      FutureBuilder(
                        future:  fetchOfflineDatabase(cmpId),
                        builder: (context,snapshot){
                          if(snapshot.hasData){
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index) {
                                      return  Padding(
                                        padding: const EdgeInsets.only(right: 8,left: 8),
                                        child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(snapshot.data[index]['name'].toString(),
                                                      style: new TextStyle(fontSize: 18.0)),
                                                  SizedBox(height: 5),
                                                  Text(snapshot.data[index]['card'].toString(),
                                                      style: new TextStyle(fontSize: 18.0)),
                                                ],
                                              ),

                                              GestureDetector(
                                                onTap: (){
                                                  _showLoading();
                                                   Navigator.push(context, MaterialPageRoute(builder: (context)=>EditCardData(snapshot.data[index]['cid'].toString()))).then((value){
                                                     Navigator.pop(context);
                                                     setState(() {
                                                       DatabaseHelper.instance.getCampCustomer(cmpId).then((value) {
                                                         if(value.isEmpty){
                                                           Navigator.pop(context);
                                                         }
                                                       });
                                                     });
                                                   });
                                                },
                                                child: Icon(Icons.edit,size: 25,)
                                              ),
                                            ]),
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return Divider();
                                    },
                                  ),
                                ),
                              ],
                            );
                          }
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Loading',style:TextStyle(fontSize: 18)),
                          );
                        }
                        ,)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
     );
  }
}

Future<List<Map>> fetchOfflineDatabase(String camp) async {
  DatabaseHelper.instance.getCampCustomer(camp).then((value) {
  });
  return DatabaseHelper.instance.getCampCustomer(camp);
}

