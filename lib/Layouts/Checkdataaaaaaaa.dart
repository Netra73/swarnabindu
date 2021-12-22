import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sawarnabindudc/Functions/config.dart';

import 'DatabaseHelper.dart';

class CheckData extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return CheckDataState();
  }
}

class CheckDataState extends State<CheckData>{
  int card = 0;

  _insert(String camp,String cardNumber){
    var body = {"camp":camp,"taluk":"Dharwad","card":cardNumber,"campname":"fourth camp","name":"Child name","age":"10","mobile":"123456789","camptype":"Rural","ctype":"Normal"};
    DatabaseHelper.instance.saveCustomer(body).then((value){
      print("Insert Id "+value.toString());
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
     return Scaffold(
       appBar: AppBar(
         title: Text('sqflite'),
       ),
       body: Center(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: <Widget>[
             Column(
               children: [
               ],
             ),
             RaisedButton(
               child: Text('insert', style: TextStyle(fontSize: 20),),
               onPressed: () {
                 card++;
                 _insert("4", card.toString());
               },
             ),
             RaisedButton(
               child: Text('query', style: TextStyle(fontSize: 20),),
               onPressed: () {
                 DatabaseHelper.instance.getCustomer().then((value){
                   print(value);
                 });
               },
             ),
             RaisedButton(
               child: Text('Camp Customer', style: TextStyle(fontSize: 20),),
               onPressed: () {
                 DatabaseHelper.instance.getCampCustomer('3').then((value){
                   print(value);
                   var data = jsonEncode(value);
                   submitState(data);
                 });
               },
             ),
             RaisedButton(
               child: Text('update', style: TextStyle(fontSize: 20),),
               onPressed: () {},
             ),
             RaisedButton(
               child: Text('pending', style: TextStyle(fontSize: 20),),
               onPressed: () {
                 DatabaseHelper.instance.getPendingCount().then((value){
                   print(value);
                 });
               },
             ),
             RaisedButton(
               child: Text('Single Customer', style: TextStyle(fontSize: 20),),
               onPressed: () {
                 DatabaseHelper.instance.getSingleCustomer('1').then((value){
                   print(value);
                 });
               },
             ),
             RaisedButton(
               child: Text('delete', style: TextStyle(fontSize: 20),),
               onPressed: () {
                 DatabaseHelper.instance.deleteCustomer('5,6','3').then((value){
                   print(value);
                 });
               },
             ),
             RaisedButton(
               child: Text('Next Survey', style: TextStyle(fontSize: 20),),
               onPressed: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => Survey()));
               },
             ),
           ],
         ),
       ),
     );
  }


  Future<String> submitState(body) async {
    var sdata ={
      "emp":"9743285056",
      "data":body
    };
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(API_URL2+'syncCustomer'));
    request.headers.set('Content-type', 'application/JSON');
    request.add(utf8.encode(jsonEncode(sdata)));
    HttpClientResponse response = await request.close();
    httpClient.close();
    if(response.statusCode==200) {
      String reply = await response.transform(utf8.decoder).join();
      print('checkkk $reply');
      return reply;
    }
  }

}
