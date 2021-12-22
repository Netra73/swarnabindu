
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sawarnabindudc/Functions/UserData.dart';
import 'package:sawarnabindudc/Functions/config.dart';
import 'package:sawarnabindudc/Layouts/DashBoard.dart';
import 'package:sawarnabindudc/Layouts/Survey.dart';

import 'CreateNewCamp.dart';

class SurveyDialog extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return sdialog();
  }
}

class sdialog extends State<SurveyDialog>{
  final _loginForm = GlobalKey<FormState>();
  String selectedTaluk = '-Select Taluk-';
  String selectedCamp = '-Select Camp-';
  String campId = "0",distict;
  bool loadDist = false;
  bool _validate = false;

  var mapTaluk = ['-Select Taluk-'];
  var mapCamp = ['-Select Camp-'];
  var campData = Map<String,String>();

  @override
  void initState() {
    getData("USERData").then((value) {
      setState(() {
        if(value!=null){
          var udata = jsonDecode(value);
          distict = udata['district'];
          getData("TalukOffData").then((value) {
            if(value!=null){
              var tdata = jsonDecode(value);
              for(var details2 in tdata){
                mapTaluk.add(details2['taluk']);
              }
              loadDist = true;
            }
          });
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
  
  _loadCamp(tname){
    _showLoading();
    getCamp(tname).then((value){
      mapCamp.clear();
      campData.clear();
      mapCamp.add('-Select Camp-');
      selectedCamp = "-Select Camp-";
      if(value!="0") {
        var response = jsonDecode(value);
        for(var detail in response){
          mapCamp.add(detail['cp_name']);
          campData[detail['cp_name']] = detail['cp_id'];
        }
      }
      Navigator.pop(context);
      setState(() {
        selectedTaluk = tname;
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
              child: Column(
                children: [
                  Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: loadDist ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(contentPadding: EdgeInsets.all(10),errorText: _validate ? 'Taluk is required' : null,
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
                            value: selectedTaluk,
                            validator: (value) {
                              if(value == '-Select Taluk-'){
                                return 'Select Taluk';
                              }
                              return null;
                            },
                            iconSize: 30,
                            elevation: 0,
                            style: TextStyle(
                                fontSize: 16.0, color: Colors.black
                            ),
                            onChanged: (newValue) {
                              _loadCamp(newValue);
                            },
                            items: mapTaluk.map((quant) {
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
                          SizedBox(height: 15),
                          DropdownButtonFormField<String>(
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
                            value: selectedCamp,
                            validator: (value) {
                              if(value == '-Select Camp-'){
                                return 'Select Camp';
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
                                selectedCamp = newValue;
                                campId = campData[newValue];
                              });
                            },
                            items: mapCamp.map((quant) {
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
                              Text(''),
                              RaisedButton(
                                onPressed: (){
                                  if (_loginForm.currentState.validate()) {
                                    _loginForm.currentState.save();
                                    setData("USelectedTaluk", selectedTaluk);
                                    setData("USelectedCamp", selectedCamp);
                                       Navigator.push(context, MaterialPageRoute(builder: (context)=> Survey(selectedTaluk,selectedCamp,campId)));
                                  }
                                },
                                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                color: Colors.orange,
                                child: Text('Start Survey',style: TextStyle(fontSize: 18.0,color: Colors.white),),
                              ),
                            ],
                          )
                        ],
                      ):
                      SpinKitThreeBounce(
                        color: Colors.amber,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(''),
                        RaisedButton(
                          onPressed: (){
                            if(selectedTaluk.isEmpty || selectedTaluk == '-Select Taluk-'){
                              setState(() {
                                _validate = true;
                              });
                            }else{
                              setState(() {
                                _validate = false;
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> CreateNewcamp(distict,selectedTaluk)));
                              });
                            }
                          },
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          color: Colors.blue,
                          child: Text('Create Camp',style: TextStyle(fontSize: 18.0,color: Colors.white),),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),

    );
  }
}

Future<String> getCamp(body) async {
  var rbody={
    "taluk":body
  };
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.postUrl(Uri.parse(API_URL2+'get_camp_list'));
  request.headers.set('Content-type', 'application/JSON');
  request.add(utf8.encode(jsonEncode(rbody)));
  HttpClientResponse response = await request.close();
  httpClient.close();
  if(response.statusCode==200) {
    String reply = await response.transform(utf8.decoder).join();
    return reply;
  }
}

