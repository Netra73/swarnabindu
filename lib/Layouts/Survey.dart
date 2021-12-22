import 'dart:convert';
import 'dart:io';
import 'package:sawarnabindudc/Layouts/DashBoard.dart';
import 'package:sawarnabindudc/Layouts/HomePage.dart';

import 'DatabaseHelper.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sawarnabindudc/Functions/UserData.dart';
import 'package:sawarnabindudc/Functions/config.dart';
import 'package:sawarnabindudc/Layouts/CreateNewCamp.dart';

class Survey extends StatefulWidget{
  String strtaluk,strcamp,campId;
  Survey(this.strtaluk, this.strcamp , this.campId);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return surveyState(strtaluk,strcamp,campId);
  }
}

class surveyState extends State<Survey>{
  String strtaluk,strcamp,campId;
  surveyState(this.strtaluk, this.strcamp,this.campId);
  final _loginForm = GlobalKey<FormState>();
  String selecteddist,CrdNo,MobNo,mail,cname,age,selectedTaluk,selectedCamp;
  String selectedCond = 'Normal';
  bool loadDist = false;
  bool hdata = false;


  var cardHolder = TextEditingController();
  var cnameHolder = TextEditingController();
  var ageHolder = TextEditingController();
  var mobHolder = TextEditingController();

  List<String>mapCon = ['Normal','ASHA Child','Handicap'];

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
    // TODO: implement initState
    super.initState();
    getData("USERData").then((value) {
       setState(() {
          if(value!=null){
            var udata = jsonDecode(value);
            print('chechUdata $udata');
            mail = udata['email'];
          }
       });
    });
    setState(() {

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
                  SizedBox(height: 10),
                  Text('Tq : $strtaluk',style: TextStyle(fontSize:18,color: Colors.white),),
                  SizedBox(height: 5),
                  Text('Camp : $strcamp',style: TextStyle(fontSize:18,color: Colors.white),),
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
              child: IconButton(icon: Icon(Icons.close,size:35,color: Colors.white,),
                  onPressed: () {
                  Navigator.pop(context);
              }),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _loginForm,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12,5,12,5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Survey',style: TextStyle(fontSize:25 ),),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Container(
                          child: TextFormField(controller: cardHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                            const Radius.circular(0.0),
                          ),
                            borderSide: new BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),),
                              hintText: 'Card Number',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,keyboardType: TextInputType.number,
                            validator: (value){
                              if(value == null || value.isEmpty) {
                                return 'Card Number';
                              }
                            },
                            onSaved: (value){
                              CrdNo = value;
                            }
                            ,),
                        ),
                        SizedBox(height: 12,),
                        Container(
                          child: TextFormField(controller: cnameHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                            const Radius.circular(0.0),
                          ),
                            borderSide: new BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),),
                              hintText: 'Child Name',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,
                            validator: (value){
                              if(value == null || value.isEmpty) {
                                return 'Child Name';
                              }
                            },
                            onSaved: (value){
                              cname = value;
                            }
                            ,),
                        ),
                        SizedBox(height: 12),
                        Container(
                          child: TextFormField(controller: ageHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                            const Radius.circular(0.0),
                          ),
                            borderSide: new BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),),
                              hintText: 'Age',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,keyboardType: TextInputType.number,
                            validator: (value){
                              if(value == null || value.isEmpty) {
                                return 'Age';
                              }
                            },
                            onSaved: (value){
                              age = value;
                            }
                            ,),
                        ),
                        SizedBox(height: 12),
                        Container(
                          child: TextFormField(controller: mobHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                            const Radius.circular(0.0),
                          ),
                            borderSide: new BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),),
                              hintText: 'Mobile Number',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,keyboardType: TextInputType.number,
                            validator: (value){
                              if(value == null || value.isEmpty || value.length!=10) {
                                return 'Mobile Number';
                              }
                            },
                            onSaved: (value){
                              MobNo = value;
                            }
                            ,),
                        ),
                        SizedBox(height: 20),
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
                          value: selectedCond,
                          validator: (value) {
                            if(value == '-Select Dist-'){
                              return 'Select Distict';
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
                              selectedCond = newValue;
                            });
                          },
                          items: mapCon.map((quant) {
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
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                           Text(''),
                            Container(
                              child: RaisedButton(
                                onPressed: (){
                                  if(_loginForm.currentState.validate()){
                                    _loginForm.currentState.save();
                                  _insert();
                                   // SyncMethod();
                                  //  save();
                                  }
                                },
                                color: Colors.blue,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Save',style: TextStyle(fontSize:20,color: Colors.white),),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12,top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(''),
                      Container(
                        child: RaisedButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          color: Colors.orange[400],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Finish',style: TextStyle(fontSize:20,color: Colors.white),),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  _insert() {
    _showLoading();
    //var body = {"camp":campId,"taluk":strtaluk,"card":CrdNo,"campname":strcamp,"name":cname,"age":age,"mobile":MobNo,"camptype":"","ctype":selectedCond};
    var body = {
      "cid": "1",
      "camp": campId,
      "taluk": strtaluk,
      "card": CrdNo,
      "name": cname,
      "age": age,
      "mobile": MobNo,
      "ctype": selectedCond
    };
    List<dynamic> bbody = [];
    bbody.add(body);
    var sbody = jsonEncode(bbody);
    submitSync(sbody, mail).then((value) {
      Navigator.pop(context);
      print(value);
      var res = jsonDecode(value);
      if (res['status'] == 200) {
        Fluttertoast.showToast(
            msg: "Submited Successfully", gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_SHORT);
        setState(() {
          selecteddist = '-Select Dist-';
          selectedTaluk = '-Select Taluk-';
          selectedCamp = '-Select Camp-';
          selectedCond = 'Normal';
          cardHolder.text = CrdNo.substring(0, CrdNo.length - 1);
          cnameHolder.text = '';
          ageHolder.text = '';
          mobHolder.text = '';
        });
      } else {
        Fluttertoast.showToast(
            msg: res['data'][0]['status'], gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_SHORT);
      }
    });
  }
/* _insert(){
    _showLoading();
    var body = {"camp":campId,"taluk":strtaluk,"card":CrdNo,"campname":strcamp,"name":cname,"age":age,"mobile":MobNo,"camptype":"","ctype":selectedCond};


    DatabaseHelper.instance.saveCustomer(body).then((value){
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: "Saved Successfully",gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_LONG);
      setState(() {
        selecteddist='-Select Dist-';
        selectedTaluk = '-Select Taluk-';
        selectedCamp = '-Select Camp-';
        selectedCond = 'Normal';
        cardHolder.text = CrdNo.substring(0, CrdNo.length - 1); ;
        cnameHolder.text = '';
        ageHolder.text = '';
        mobHolder.text = '';
      });
    });
  }*/

  /*void save(){
    var body = {
      'camp' : campId,
      'taluk' : strtaluk,
      'card' : CrdNo,
      'campname' : strcamp,
      'name' : cname,
      'age' : age,
      'mobile' : MobNo,
      'camptype':" ",
      'ctype':selectedCond
    };
    saveState(body).then((value) {
      Fluttertoast.showToast(
          msg: "Saved Successfully",gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_LONG);
      setState(() {
        selecteddist='-Select Dist-';
        selectedTaluk = '-Select Taluk-';
        selectedCamp = '-Select Camp-';
        selectedCond = 'Normal';
        cardHolder.text = CrdNo.substring(0, CrdNo.length - 1); ;
        cnameHolder.text = '';

        ageHolder.text = '';
        mobHolder.text = '';
      });

    });
  }*/


  _insertFinish(){
    _showLoading();
    var body = {"camp":campId,"taluk":strtaluk,"card":CrdNo,"campname":strcamp,"name":cname,"age":age,"mobile":MobNo,"camptype":"","ctype":selectedCond};
    DatabaseHelper.instance.saveCustomer(body).then((value){
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: "Saved Successfully",gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_LONG);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          DashBoard(0)), (Route<dynamic> route) => false);
      setState(() {
        selecteddist='-Select Dist-';
        selectedTaluk = '-Select Taluk-';
        selectedCamp = '-Select Camp-';
        selectedCond = 'Normal';
        cardHolder.text = '';
        cnameHolder.text = '';
        ageHolder.text = '';
        mobHolder.text = '';
      });
    });
  }

  void submit(){
    var body = {
      'user' : mail,
      'card' : CrdNo,
      'camp' : campId,
      'fname' : cname,
      'age' : age,
      'ctype' : selectedCond,
      'mobile' : MobNo,
    };
    submitState(body).then((value) {
        var responce = jsonDecode(value);
        if(responce == 0){
          Fluttertoast.showToast(
              msg: "Card Number already exist: ",gravity: ToastGravity.CENTER,
              toastLength: Toast.LENGTH_SHORT);
        }
        if(responce == 2){
          Fluttertoast.showToast(
              msg: "Invalid Card Number",gravity: ToastGravity.CENTER,
              toastLength: Toast.LENGTH_SHORT);
        }
        if(responce == 1){
          Fluttertoast.showToast(
              msg: "Registered Successfully",gravity: ToastGravity.CENTER,
              toastLength: Toast.LENGTH_SHORT);

          setState(() {
            selecteddist='-Select Dist-';
            selectedTaluk = '-Select Taluk-';
            selectedCamp = '-Select Camp-';
            selectedCond = 'Normal';
            cardHolder.text = '';
            cnameHolder.text = '';
            ageHolder.text = '';
            mobHolder.text = '';
          }
          );
    }});
  }

  Future<String> getDisticts(body) async {
    var rbody={
      "state":body
    };
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(API_URL2+'get_dist_list'));
    request.headers.set('Content-type', 'application/JSON');
    request.add(utf8.encode(jsonEncode(rbody)));
    HttpClientResponse response = await request.close();
    httpClient.close();
    if(response.statusCode==200) {
      String reply = await response.transform(utf8.decoder).join();
      return reply;
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

  Future<String> submitState(body) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(API_URL2+'add_customer'));
    request.headers.set('Content-type', 'application/JSON');
    request.add(utf8.encode(jsonEncode(body)));
    HttpClientResponse response = await request.close();
    httpClient.close();
    if(response.statusCode==200) {
      String reply = await response.transform(utf8.decoder).join();
      return reply;
    }
  }

/*Future<String> saveState(body) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(API_URL2+''));
    request.headers.set('Content-type', 'application/JSON');
    request.add(utf8.encode(jsonEncode(body)));
    HttpClientResponse response = await request.close();
    httpClient.close();
    if(response.statusCode==200) {
      String reply = await response.transform(utf8.decoder).join();
      return reply;
    }
  }*/

}