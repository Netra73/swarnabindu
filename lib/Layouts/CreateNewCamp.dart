import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sawarnabindudc/Functions/UserData.dart';
import 'package:sawarnabindudc/Functions/config.dart';

import 'DashBoard.dart';
import 'Survey.dart';

class CreateNewcamp extends StatefulWidget{
  String strDistict,strTaluk;
  CreateNewcamp(this.strDistict,this.strTaluk);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
     return newcampState(strDistict,strTaluk);
  }
}

class newcampState extends State<CreateNewcamp>{
  final _loginForm = GlobalKey<FormState>();
  String strDistict,strTaluk;
  newcampState(this.strDistict,this.strTaluk);

  String strCmp,strPlace,strVenue,strCoName,strCoMob,strCoAltMob,strdate,mail,district;
  String selectedcampType = 'Rural Camp';
  bool loadDist = true;

  var talukData = Map<String,dynamic>();
  List<String>mapCampType = ['Rural Camp','Urban Camp'];

  var cmpHolder = TextEditingController();
  var placeHolder = TextEditingController();
  var venueHolder = TextEditingController();
  var CoNameHolder = TextEditingController();
  var CoMobHolder = TextEditingController();
  var CoAltHolder = TextEditingController();
//  var CoMobHolder = TextEditingController();

  DateTime selectedDate = DateTime.now();
  var _date = TextEditingController();

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
          mail = udata['email'];
          getData("selDist").then((dvalue){
            district = dvalue;
          });

        }
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
                  SizedBox(height: 12),
                  Text('Dt : $strDistict',style: TextStyle(fontSize:18,color: Colors.white),),
                  SizedBox(height: 5),
                  Text('Tq : $strTaluk',style: TextStyle(fontSize:18,color: Colors.white),),
                  // Text('$name $post',style: TextStyle(fontSize:18,color: Colors.white),),
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
              child: IconButton(icon: Icon(Icons.close,size:35,color: Colors.white,), onPressed: () {
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
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Create New Camp',style: TextStyle(fontSize:25 ),),
                    SizedBox(height: 18,),
                    Container(
                      child: TextFormField(controller: cmpHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                        const Radius.circular(0.0),
                      ),
                        borderSide: new BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),),
                          hintText: 'Camp Place',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,
                        validator: (value){
                          if(value == null || value.isEmpty) {
                            return 'Camp Place';
                          }
                        },
                        onSaved: (value){
                          strCmp = value;
                        }
                        ,),
                    ),
//                    SizedBox(height: 12),
//                    GestureDetector(
//                      onTap: (){
//                        _selectDate(context);
//                      },
//                      child: AbsorbPointer(
//                        child: TextFormField(controller: _date,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
//                          const Radius.circular(0.0),
//                        ),
//                          borderSide: new BorderSide(
//                            color: Colors.black,
//                            width: 1.0,
//                          ),),
//                            hintText: 'Camp Date',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,keyboardType: TextInputType.datetime,
//                          validator: (value){
//                            if(value == null || value.isEmpty || value.length!=10) {
//                              return 'Camp Date';
//                            }
//                          },
//                          onSaved: (value){
//                            strdate = value;
//                          }
//                          ,),
//                      ),
//                    ),
                    SizedBox(height: 12),
                    Container(
                      child: TextFormField(controller: venueHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                        const Radius.circular(0.0),
                      ),
                        borderSide: new BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),),
                          hintText: 'Camp Venue',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,
                        validator: (value){
                          if(value == null || value.isEmpty) {
                            return 'Camp Venue';
                          }
                        },
                        onSaved: (value){
                          strVenue = value;
                        }
                        ,),
                    ),
                    SizedBox(height: 12,),
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
                      value: selectedcampType,
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
                          selectedcampType = newValue;
                        });
                      },
                      items: mapCampType.map((quant) {
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
                    SizedBox(height: 12),
                    Container(
                      child: TextFormField(controller: CoNameHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                        const Radius.circular(0.0),
                      ),
                        borderSide: new BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),),
                          hintText: 'Sub Coordinator Name',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,
                        validator: (value){
                          if(value == null || value.isEmpty) {
                            return 'Sub Coordinator Name';
                          }
                        },
                        onSaved: (value){
                          strCoName = value;
                        }
                        ,),
                    ),
                    SizedBox(height: 12),
                    Container(
                      child: TextFormField(controller: CoMobHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                        const Radius.circular(0.0),
                      ),
                        borderSide: new BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),),
                          hintText: 'Sub Coordinator Mobile',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,keyboardType: TextInputType.number,
                        validator: (value){
                          if(value == null || value.isEmpty) {
                            return 'Sub Coordinator Mobile';
                          }
                        },
                        onSaved: (value){
                          strCoMob = value;
                        }
                        ,),
                    ),
                    SizedBox(height: 12),
                    Container(
                      child: TextFormField(controller: CoAltHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                        const Radius.circular(0.0),
                      ),
                        borderSide: new BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),),
                          hintText: 'Sub Coordinator Alternative Mobile',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,keyboardType: TextInputType.number,
                        validator: (value){
                          if(value == null || value.isEmpty || value.length!=10) {
                            return 'Sub Coordinator Alternative Mobile';
                          }
                        },
                        onSaved: (value){
                          strCoAltMob = value;
                        }
                        ,),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 50,
                      child: RaisedButton(
                        onPressed: (){
                          if(_loginForm.currentState.validate()){
                            _loginForm.currentState.save();
                              submit();
                          }
                        },
                        color: Colors.orange,
                        child: Text('SUBMIT',style: TextStyle(fontSize:18,color: Colors.white),),
                      ),
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void submit(){
    var body = {
      'user' : mail,
      'cname' : strCmp,
      'dist' : district,
      'taluk' : strTaluk,
      'cp_type' : selectedcampType,
      'co_name' : strCoName,
      'co_mobile' : strCoMob,
      'venue' : strVenue,
      'cdate' : '2021-01-01',
    };
    submitState(body).then((value) {
      var responce = jsonDecode(value);
         _nextStep(value,strCmp,strTaluk);
      setState(() {
        cmpHolder.text = '';
        placeHolder.text = '';
        venueHolder.text = '';
        CoNameHolder.text = '';
        CoMobHolder.text = '';
        CoAltHolder.text = '';
        });
      });
  }

  _nextStep(String id,String campName,String talukName) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Row(
            children: [
              Expanded(
                child: Container(
                  //  height: 270.0,
                  padding: EdgeInsets.all(10.0),
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15,0,15,15),
                            child: Column(
                              children: [
                                Icon(Icons.note_add,size: 50,),
                                SizedBox(height: 5),
                                Text('New Camp Created',style: TextStyle(fontSize: 18),textAlign: TextAlign.center,),
                              ],
                            ),
                          ),
                          // SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8,8,8,0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RaisedButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  color: Colors.grey,
                                  child: Text('Close',style: TextStyle(fontSize: 16.0,color: Colors.white),),
                                ),
                                RaisedButton(
                                  onPressed: (){
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Survey(talukName,campName,id)),
                                    );
                                  },
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  color: Colors.red,
                                  child: Text('Continue Survey',style: TextStyle(fontSize: 16.0,color: Colors.white),),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    ).then((value){

    });
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        String dateFormate = DateFormat("dd-MM-yyyy").format(picked);
        _date.value = TextEditingValue(text: dateFormate.toString());
      });
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
  Future<String> submitState(body) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(API_URL2+'create_camp'));
    request.headers.set('Content-type', 'application/JSON');
    request.add(utf8.encode(jsonEncode(body)));
    HttpClientResponse response = await request.close();
    httpClient.close();
    if(response.statusCode==200) {
      String reply = await response.transform(utf8.decoder).join();
      return reply;
    }
  }

}