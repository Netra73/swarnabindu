import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sawarnabindudc/Functions/UserData.dart';
import 'package:sawarnabindudc/Functions/config.dart';
import 'package:sawarnabindudc/Modules/editModule.dart';

import 'DatabaseHelper.dart';

class EditCardData extends StatefulWidget{
  String cid;
  EditCardData(this.cid);

  @override
  State<StatefulWidget> createState() {
    return EditCardDataState(cid);
  }
}

class EditCardDataState extends State<EditCardData>{
  String cid,strCrd,mail;
  EditCardDataState(this.cid);
  final _loginForm = GlobalKey<FormState>();

  var cidHolder = TextEditingController();
  var  cardHolder = TextEditingController();
  var talukHolder = TextEditingController();
  var campHolder = TextEditingController();
  var  campnameHolder = TextEditingController();
  var  nameHolder = TextEditingController();
  var  ageHolder = TextEditingController();
  var  mobileHolder = TextEditingController();
  var  ctypeHolder = TextEditingController();
  List<editModule> editlist = [];

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Card Number'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: fetchOfflineDatabase(cid),
          builder: (context,snapshot){
             if(snapshot.hasData){
               editlist.clear();
               var data = snapshot.data;
                cidHolder.text = snapshot.data[0]['cid'].toString();
                cardHolder.text = snapshot.data[0]['card'].toString();
                talukHolder.text = snapshot.data[0]['taluk'].toString();
               campHolder.text = snapshot.data[0]['camp'].toString();
               campnameHolder.text = snapshot.data[0]['campName'].toString();
               nameHolder.text = snapshot.data[0]['name'].toString();
               ageHolder.text = snapshot.data[0]['age'].toString();
               mobileHolder.text = snapshot.data[0]['mobile'].toString();
               ctypeHolder.text = snapshot.data[0]['ctype'].toString();


               return Form(
                 key: _loginForm,
                 child: Padding(
                   padding: const EdgeInsets.all(5.0),
                   child: Card(
                     elevation: 2,
                     child: Padding(
                       padding: const EdgeInsets.all(12),
                       child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         mainAxisSize: MainAxisSize.min,
                         children: [
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
                                 strCrd = value;
                               }
                               ,),
                           ),
                           SizedBox(height: 5),
                           Container(
                             child: TextFormField(controller:talukHolder,enabled:false,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(prefix:Text('Taluk : ',style:TextStyle(color: Colors.grey),),contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                               const Radius.circular(0.0),
                             ),
                               borderSide: new BorderSide(
                                 color: Colors.black,
                                 width: 1.0,
                               ),), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,
                             ),
                           ),
                           SizedBox(height: 5),
                           Container(
                             child: TextFormField(controller:campHolder,enabled:false,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(prefix:Text('camp No : ',style:TextStyle(color: Colors.grey),),contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                               const Radius.circular(0.0),
                             ),
                               borderSide: new BorderSide(
                                 color: Colors.black,
                                 width: 1.0,
                               ),), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,
                             ),
                           ),
                           SizedBox(height: 5),
                           Container(
                             child: TextFormField(controller:campnameHolder,enabled:false,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(prefix:Text('Camp : ',style:TextStyle(color: Colors.grey),),contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                               const Radius.circular(0.0),
                             ),
                               borderSide: new BorderSide(
                                 color: Colors.black,
                                 width: 1.0,
                               ),), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,
                             ),
                           ),
                           SizedBox(height: 5),
                           Container(
                             child: TextFormField(controller:nameHolder,enabled:false,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(prefix:Text('Child : ',style:TextStyle(color: Colors.grey),),contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                               const Radius.circular(0.0),
                             ),
                               borderSide: new BorderSide(
                                 color: Colors.black,
                                 width: 1.0,
                               ),), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,
                             ),
                           ),
                           SizedBox(height: 5),
                           Container(
                             child: TextFormField(controller:ageHolder,enabled:false,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(prefix:Text('age : ',style:TextStyle(color: Colors.grey),),contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                               const Radius.circular(0.0),
                             ),
                               borderSide: new BorderSide(
                                 color: Colors.black,
                                 width: 1.0,
                               ),), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,
                             ),
                           ),
                           SizedBox(height: 5),
                           Container(
                             child: TextFormField(controller:mobileHolder,enabled:false,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(prefix:Text('Mobile No : ',style:TextStyle(color: Colors.grey),),contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                               const Radius.circular(0.0),
                             ),
                               borderSide: new BorderSide(
                                 color: Colors.black,
                                 width: 1.0,
                               ),), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,
                             ),
                           ),
                           SizedBox(height: 5),
                           Container(
                             child: TextFormField(controller:ctypeHolder,enabled:false,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(prefix:Text('Child Type : ',style:TextStyle(color: Colors.grey),),contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                               const Radius.circular(0.0),
                             ),
                               borderSide: new BorderSide(
                                 color: Colors.black,
                                 width: 1.0,
                               ),), focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,
                             ),
                           ),
                           SizedBox(height: 12,),
                           RaisedButton(
                             onPressed: (){
                               if (_loginForm.currentState.validate()) {
                                 _loginForm.currentState.save();
                                 submit();
                                }
                               },
                             padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                             color: Colors.orange,
                             child: Text('Save',style: TextStyle(fontSize: 18.0,color: Colors.white),),
                           ),
                           SizedBox(height: 15),
                         ],
                       ),
                     ),
                   ),
                 ),
               );
             }
             return Padding(
               padding: const EdgeInsets.all(8.0),
               child: Text('Loading..',style:TextStyle(fontSize: 18)),
             );
          },
        )
      ),

    );
  }
  void submit(){
    var body = {
      'user' : mail,
      'card' : strCrd,
      'camp' : campHolder.text.toString(),
      'fname' : nameHolder.text.toString(),
      'age' : ageHolder.text.toString(),
      'ctype' : ctypeHolder.text.toString(),
      'mobile' : mobileHolder.text.toString(),
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
           DatabaseHelper.instance.deleteSingleCustomer(cid).then((value) {
             Navigator.pop((context));
           });

      }});
  }
}



Future<List<Map>> fetchOfflineDatabase(String scid) async {
  return DatabaseHelper.instance.getSingleCustomer(scid);
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