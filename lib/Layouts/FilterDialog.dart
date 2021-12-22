
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sawarnabindudc/Functions/UserData.dart';
import 'package:sawarnabindudc/Functions/config.dart';
import 'package:http/http.dart' as http;

class filterdialogState extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return filter();
  }
}

class filter extends State<filterdialogState>{
  String selectedMaterial = 'All';
  String selectedEmp = 'All';
  String distict,selectedyear = 'Select Year';
  String selectedmonth = 'Select Month',frmMail;

  var mdata = ['All'];
  var dataemp = ['All,All'];
  List<String> yearValues = ['Select Year','2020', '2019', '2018', '2017',];
  List<String> monthValues = ['Select Month,Select Month','01,January', '02,February', '03,March', '04,April','05,May','06,June','07,July','08,August','09,September','10,October','11,November','12,December'];
  final _loginForm = GlobalKey<FormState>();

  @override
  void initState() {
    getData("USERData").then((value) {
      if (value != null) {
        var udata = jsonDecode(value);
        distict = udata['district'];
        frmMail = udata['email'];
      }

      getmaterialList().then((value) {
        var jdata = jsonDecode(value);
        var data = jdata['data'];
        for (var details in data) {
          String id = details['name'];
          mdata.add(id);
        }

        getEmpList(distict).then((value) {
          var jdata2 = jsonDecode(value);
          var edata = jdata2['data'];
          for (var details1 in edata) {
            String name = details1['name'];
            String email = details1['email'];
            dataemp.add(name+','+email);
          }

          setState(() {});
           });

      });

    });

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Form(
      key: _loginForm,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<String>(
                        value: selectedyear,
                        validator: (value){
                          if(value == 'Select Year'){
                            return 'Select Year';
                          }
                          return null;
                        },
                        iconSize: 30,
                        elevation: 0,
                        style: TextStyle(
                            fontSize: 16.0,color: Colors.black
                        ),
                        onChanged: (newValue) {
                          setState(() {
                            selectedyear = newValue;
                          });
                        },
                        items: yearValues.map((quant) {
                          return DropdownMenuItem(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: new Text(quant,style: TextStyle(fontSize: 15),),
                            ),
                            value: quant,
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 10.0,),
                      DropdownButtonFormField<String>(
                        value: selectedmonth,
                        validator: (value){
                          if(value == 'Select Month'){
                            return 'Select Month';
                          }
                          return null;
                        },
                        iconSize: 30,
                        elevation: 0,
                        style: TextStyle(
                            fontSize: 16.0,color: Colors.black
                        ),
                        onChanged: (newValue) {
                          setState(() {
                            selectedmonth = newValue;
                          });
                        },
                        items: monthValues.map((quant) {
                          var split2 =  quant.split(',');
                          return DropdownMenuItem(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: new Text(split2[1],style: TextStyle(fontSize: 15),),
                            ),
                            value: split2[0],
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 5),
                      if (!dataemp.isEmpty)DropdownButtonFormField<String>(
                        value: selectedEmp,
                        decoration: InputDecoration(
                          labelText: 'Select Employee'
                        ),
                        validator: (value){
                          if(value == 'Select'){
                            return 'Select Employee';
                          }
                          return null;
                        },
                        iconSize: 30,
                        elevation: 0,
                        style: TextStyle(
                            fontSize: 16.0, color: Colors.black
                        ),
                        onChanged: (newValue) {
                          setState(() {
                            selectedEmp = newValue;
                          });
                        },
                        items: dataemp.map((quant1) {
                          var str1 = quant1.split(',');
                          print('value split$str1');
                          return DropdownMenuItem(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: new Text(
                                str1[0], style: TextStyle(fontSize: 15),),
                            ),
                            value: str1[1],
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 10.0,),
                      DropdownButtonFormField<String>(
                        value: selectedMaterial,
                        decoration: InputDecoration(
                            labelText: 'Select Material'
                        ),
                        validator: (value) {
                          if(value == '-Select the material-'){
                            return 'Select the material';
                          }
                          return null;
                        },
                        iconSize: 30,
                        elevation: 0,
                        style: TextStyle(
                            fontSize: 16.0, color: Colors.black
                        ),
                        onChanged: (newValue) {
                          setState(() {
                            selectedMaterial = newValue;
                          });
                        },
                        items: mdata.map((quant) {
                          return DropdownMenuItem(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: new Text(
                                quant, style: TextStyle(fontSize: 15),),
                            ),
                            value: quant,
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 15.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RaisedButton(
                            onPressed: (){
                             Navigator.pop(context);
                            },
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            color: Colors.grey[600],
                            child: Text('CANCEL',style: TextStyle(fontSize: 18.0,color: Colors.white),),
                          ),
                          RaisedButton(
                            onPressed: (){
                              if (_loginForm.currentState.validate()) {
                                _loginForm.currentState.save();
                                var body = {
                                  'user': frmMail,
                                  'year':selectedyear,
                                  'month': selectedmonth,
                                  'material':selectedMaterial,
                                  'employee':selectedEmp,
                                };
                                Navigator.pop(context,jsonEncode(body));
                              }
                            },
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            color: Colors.orange,
                            child: Text('SUBMIT',style: TextStyle(fontSize: 18.0,color: Colors.white),),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),

    );
  }

  Future<String> getmaterialList() async {
    final response = await http.get(API_URL + 'materials');
    if (response.statusCode == 200) {
      String reply = response.body;
      return reply;
    }
  }

  Future<String> getEmpList(String di) async {
    final response = await http.get(API_URL + 'employees/' + di);
    if (response.statusCode == 200) {
      String reply = response.body;
      return reply;
    }
  }

}