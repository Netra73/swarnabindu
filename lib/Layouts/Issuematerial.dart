import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sawarnabindudc/Functions/UserData.dart';
import 'package:sawarnabindudc/Functions/config.dart';
import 'package:http/http.dart' as http;
import 'package:sawarnabindudc/Layouts/IssueHistory.dart';

class Issuematerial extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => Issue();
}

class Issue extends State<Issuematerial> {
  String selectedMaterial = '-Select the material-';
  String selectedEmp = 'Select';
  String distict, strNo='', strendno, strqty,frmMail;
  var nameHolder = TextEditingController();
  var nameHolder2 = TextEditingController();
  var nameHolder3 = TextEditingController();
  bool loadMaterial = false;

  final _loginForm = GlobalKey<FormState>();

  var mdata = ['-Select the material-'];
  var dataemp = ['-Select Employee-,Select'];

  @override
  void initState() {
    setState(() {
      getData("USERData").then((value) {
          var resp = jsonDecode(value);
          frmMail = resp['email'];
          getData("selDist").then((value){
            distict = value;
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
                setState(() {
                  loadMaterial = true;
                });
              });
            });
          });
      });
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
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text('Issue Material',
              style: TextStyle(fontSize: 22.0, color: Colors.blue),
            ),
            leading: MaterialButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back,size: 30,color: Colors.black,),
            ),
          ), body: Container(
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Form(
              key: _loginForm,
              child: loadMaterial ? Column(
                children: [
                  SizedBox(height: 15),
                  if (!mdata.isEmpty)DropdownButtonFormField<String>(
                      decoration: InputDecoration(contentPadding: EdgeInsets.all(10),
                          border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(0.0),
                            ),
                            borderSide: new BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          )
                      ),
                      value: selectedMaterial,
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
                  SizedBox(height: 15,),
                  if (!dataemp.isEmpty)DropdownButtonFormField<String>(
                    decoration: InputDecoration(contentPadding: EdgeInsets.all(10),
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(0.0),
                          ),
                          borderSide: new BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        )
                    ),
                    value: selectedEmp,
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
                  SizedBox(height: 15),
                  Container(
                    child: TextFormField(controller:nameHolder3,validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Quantity';
                      }
                      return null;
                    },
                        onSaved: (value) {
                          strqty = value;
                        },
                        decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                          const Radius.circular(0.0),
                        ),
                          borderSide: new BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),),
                            hintText: 'Quantity',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),
                        cursorColor: Colors.black,keyboardType: TextInputType.number

                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    child: TextFormField(controller: nameHolder,
                        validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Start Number';
                      }
                      return null;
                    },
                        onSaved: (value) {
                          strNo = value;
                        },
                        decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                          const Radius.circular(0.0),
                        ),
                          borderSide: new BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),),
                            hintText: 'Start Number',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),
                        cursorColor: Colors.black,keyboardType: TextInputType.number

                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    child: TextFormField(controller:nameHolder2,validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'End Number';
                      }
                      return null;
                    },
                      onSaved: (value) {
                        strendno = value;
                      },
                      decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                        const Radius.circular(0.0),
                      ),
                        borderSide: new BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),),
                          hintText: 'End Number',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),
                      cursorColor: Colors.black,keyboardType: TextInputType.number,

                    ),
                  ),

                  SizedBox(height: 25),
                  RaisedButton(
                      color: Colors.orange,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text('SUBMIT',
                          style: TextStyle(fontSize: 20.0, color: Colors
                              .white),),
                      ),
                      onPressed: () {
                        if (_loginForm.currentState.validate()) {
                          _loginForm.currentState.save();
                          _submitIssueMa();
                        }
                      }
                    // },
                  ),
                ],
              ):
              SpinKitThreeBounce(
                color: Colors.amber,
                size: 20,
              ),
            ),
          ),
        ),)
    );
  }

  _submitIssueMa() {
    _showLoading();
    var body = {
      'from' : frmMail,
      'employee' : selectedEmp,
      'material' : selectedMaterial,
      'quantity' : strqty,
      'startNumber' : strNo,
      'endNumber' : strendno,
    };

    SumbitIssueMat(body).then((value) {
      Navigator.pop(context);
      var response = jsonDecode(value);
      if(response['status']==200){
        setState(() {
          selectedMaterial = '-Select the material-';
          selectedEmp = 'Select';
          nameHolder.text = '';
          nameHolder2.text = '';
          nameHolder3.text = '';
          Navigator.pop(context);
        });
      }
    });
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

  Future<String> SumbitIssueMat(body) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(
        Uri.parse(API_URL + 'issueMaterial'));
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