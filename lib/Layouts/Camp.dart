import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sawarnabindudc/Functions/UserData.dart';
import 'package:sawarnabindudc/Functions/config.dart';
import 'package:sawarnabindudc/Layouts/campSurvey.dart';


class Camp extends StatefulWidget{
  String ctq,ccamp,cdate,cctype,df,ccampid,num;

  Camp(this.ctq, this.ccamp, this.cdate, this.cctype,this.df,this.ccampid,this.num);

  @override
  State<StatefulWidget> createState() {
    int a = int.parse(num);
    int b = a+1;
    String cnum = b.toString();
    // TODO: implement createState
    return campState(ctq,ccamp,cdate,cctype,df,ccampid,cnum);
  }
}

class campState extends State<Camp>{
  String ctq,ccamp,cdate,cctype,df,ccampid,num;
  campState(this.ctq, this.ccamp, this.cdate, this.cctype,this.df,this.ccampid,this.num);


  String selectedCampType = '-Select Camp Type-';
  String CrdNo,MedNo,mail;
  final _loginForm = GlobalKey<FormState>();
  var cardHolder = TextEditingController();
  var medHolder = TextEditingController();
  List<String>mapCamp = ['-Select Camp Type-','Rural camp','Urban Camp'];

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
          print('new maillll $mail');
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
                  SizedBox(height: 15),
                  SizedBox(height: 5),
                  Text("Camp : $ccamp",style: TextStyle(fontSize:18,color: Colors.white),),
//                  SizedBox(height: 5),
//                  Text("$cdate",style: TextStyle(fontSize:18,color: Colors.white),),
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
            child: Column(
              children: [
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                       children: [
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text('Camp',style: TextStyle(fontSize:25 ),),
                             Text('Camp Number : $num',style: TextStyle(fontSize:18 ),),
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
                           child: TextFormField(controller: medHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                             const Radius.circular(0.0),
                           ),
                             borderSide: new BorderSide(
                               color: Colors.black,
                               width: 1.0,
                             ),),
                               hintText: 'Medicine Number',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,keyboardType: TextInputType.number,
                             validator: (value){
                               if(value == null || value.isEmpty) {
                                 return 'Medicine Number';
                               }
                             },
                             onSaved: (value){
                               MedNo = value;
                             }
                             ,),
                         ),
                         SizedBox(height: 20),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(''),
//                             Container(
//                               height: 45,
//                               child: RaisedButton(
//                                 onPressed: (){
//                                   if(_loginForm.currentState.validate()){
//                                     _loginForm.currentState.save();
//                                       submit();
//                                   }
//                                 },
//                                 color: Colors.orange,
//                                 child: Text('SUBMIT',style: TextStyle(fontSize:18,color: Colors.white),),
//                               ),
//                             ),
//                           ],
//                         ),
                         Padding(
                           padding: const EdgeInsets.only(right: 0),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Text(''),
                               RaisedButton(
                                 onPressed: (){
                                   if(_loginForm.currentState.validate()){
                                     _loginForm.currentState.save();
                                     submit();
                                   }
                                 },
                                 padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                 color: Colors.orange,
                                 child: Text('Submit',style: TextStyle(fontSize: 18.0,color: Colors.white),),
                               ),
                             ],
                           ),
                         ),
                         SizedBox(height: 15),
                       ],
                    ),
                  ),
                ),
                SizedBox(height: 8),
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: [
//                    Text(''),
//                    GestureDetector(
//                      onTap: (){
//                        Navigator.push(context, MaterialPageRoute(builder: (context)=> campSurvey(ctq,ccamp,ccampid))).then((value) {
//                          setState(() {
//                            cardHolder.text = value;
//                            print('returned valueee $value');
//                          });
//                        });
//                      },
//                      child: Card(
//                          margin: const EdgeInsets.only(left: 8.0,right: 12.0,bottom: 6),
//                          shape: RoundedRectangleBorder(
//                            borderRadius: BorderRadius.circular(0),
//                          ),
//                          color: Colors.blue,
//                          child: Padding(
//                            padding: const EdgeInsets.all(8.0),
//                            child: const Text("New Card",style: TextStyle(fontSize: 20),textAlign: TextAlign.center,),
//                          )),
//                    ),
//                  ],
//                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(''),
                      RaisedButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> campSurvey(ctq,ccamp,ccampid))).then((value) {
                            setState(() {
                              cardHolder.text = value;
                              print('returned valueee $value');
                            });
                          });
                        },
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        color: Colors.blue,
                        child: Text('New Card',style: TextStyle(fontSize: 18.0,color: Colors.white),),
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

  void submit(){
    _showLoading();
    var body = {
      'user' : mail,
      'card_no' : CrdNo,
      'med_no' : MedNo,
      'cp_type' : cctype,
      'date' : df,
    };
    submitCamp(body).then((value) {
      Navigator.pop(context);
      var responce = value;

      if(responce == "0"){
        Fluttertoast.showToast(
            msg: "Card Number is not valid",gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_SHORT);
      }
      if(responce == '2'){
        Fluttertoast.showToast(
            msg: "Today's dose is already done",gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_SHORT);
      }
      if(responce == '1'){
        Fluttertoast.showToast(
            msg: "Drops added",gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_SHORT);

        setState(() {
          cardHolder.text = CrdNo.substring(0, CrdNo.length - 1);
          medHolder.text = MedNo;
        }
        );

      }});
  }

  Future<String> submitCamp(body) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(API_URL2+'add_drops'));
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