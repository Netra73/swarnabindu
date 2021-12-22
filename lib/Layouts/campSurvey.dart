import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sawarnabindudc/Functions/UserData.dart';
import 'package:sawarnabindudc/Functions/config.dart';

import 'DashBoard.dart';
import 'DatabaseHelper.dart';

class campSurvey extends StatefulWidget{
  String strtaluk,strcamp,campId;
  campSurvey(this.strtaluk, this.strcamp , this.campId);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return campSurveyState(strtaluk,strcamp,campId);
  }
}

class campSurveyState extends State<campSurvey>{
  String strtaluk,strcamp,campId;
  campSurveyState(this.strtaluk, this.strcamp,this.campId);
  final _loginForm = GlobalKey<FormState>();
  String selecteddist,CrdNo,MobNo,mail,cname,age,selectedTaluk,selectedCamp;
  String selectedCond = 'Normal';
  bool loadDist = false;

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
          // mapoffTaluk.add(detail['dName']);
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
                  SizedBox(height: 5),
                  Text('Tq : $strtaluk',style: TextStyle(fontSize:18,color: Colors.white),),
                  SizedBox(height: 5),
                  Text('Camp : $strcamp',style: TextStyle(fontSize:18,color: Colors.white),),
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


//         leading: Padding(
//           padding: const EdgeInsets.all(6.0),
//           child: Image(image: AssetImage('images/mainimg.png'),),
//         ),
//           title: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text('Hello $name',style: TextStyle(fontSize:18,color: Colors.white),),
//               Text('$post',style: TextStyle(fontSize:18,color: Colors.white),),
//             ],
//           ),
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
//            mainAxisAlignment: MainAxisAlignment.,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Survey',style: TextStyle(fontSize:25 ),),
                      ],
                    ),
                    SizedBox(height: 18,),
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
                            return 'Card Number is required';
                          }
                        },
                        onSaved: (value){
                          // print('valuees select $value');
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
                            return 'Child Name is required';
                          }
                        },
                        onSaved: (value){
                          // print('valuees select $value');
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
                            return 'Age is required';
                          }
                        },
                        onSaved: (value){
                          // print('valuees select $value');
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
                            return 'Mobile Number is required';
                          }
                        },
                        onSaved: (value){
                          // print('valuees select $value');
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
                          //  totalAmt = a.toString();
                          //   editedValue.text = totalAmt;
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
                    SizedBox(height: 15),
                    Container(
                      height: 50,
                      child: RaisedButton(
                        onPressed: (){
                          if(_loginForm.currentState.validate()){
                            _loginForm.currentState.save();
                             submit();
                            //_insert();
                          }
                        },
                        color: Colors.blue,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('SUBMIT',style: TextStyle(fontSize:20,color: Colors.white),),
                        ),
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
    _showLoading();
    var body = {
      'user'  : mail,
      'card'  : CrdNo,
      'camp'  : campId,
      'fname' : cname,
      'age'   : age,
      'ctype' : selectedCond,
      'mobile': MobNo,
    };
    submitState(body).then((value) {
      Navigator.pop(context);
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
        Navigator.pop(context,CrdNo);
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


}