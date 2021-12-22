import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sawarnabindudc/Functions/UserData.dart';
import 'package:sawarnabindudc/Functions/config.dart';
import 'package:sawarnabindudc/Modules/stockModule.dart';
import 'package:sawarnabindudc/Styles/textstyle.dart';

class viewAllStock extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return viewAllStockState();
  }
}

class viewAllStockState extends State<viewAllStock>{
  List<stockModule>stockList = [];
  String id,email;

  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
             appBar: AppBar(
         backgroundColor: Colors.white,
         title: Text('Stock',style: TextStyle(fontSize: 22,color: Colors.blue),),
         leading: MaterialButton(
           onPressed: (){
             Navigator.pop(context);
           },
           child: Icon(Icons.arrow_back,color: Colors.black,size: 35,),
         ),
       ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: getData("USERData"),
          builder: (context,snap){
            if(snap.hasData){
              var data = jsonDecode(snap.data);
              id = data['id'].toString();
              email = data['email'].toString();
              return  FutureBuilder(
                future: getStock(id),
                builder: (context,snapshot){
                  if(snapshot.hasData){
                    var response = jsonDecode(snapshot.data);
                    if(response['status']==200){
                      stockList.clear();
                      var data = response['data'];
                      var accounts = data['account'];
                      var summary = accounts['summary'];
                      for(var details in summary){
                        String name = details['name'].toString();
                        String total = details['total'].toString();
                        stockList.add(stockModule(name,total));
                      }
                      return Container(
                        child: Row(
                          children: [
                            Expanded(
                              child: ListView.separated(
                                shrinkWrap: true,
                                itemCount: stockList.length,
                                itemBuilder: (context,i){
                                  return Padding(
                                    padding: const EdgeInsets.fromLTRB(15,8,15,10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.credit_card,color: Colors.blue,),
                                            SizedBox(width: 6),
                                            Text(stockList[i].cname.toString(), style: new TextStyle(fontSize: 18.0)),
                                          ],
                                        ),
                                        Text(stockList[i].ctotal.toString(),
                                            style: new TextStyle(fontSize: 18.0)),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return Divider();
                                },),
                            ),
                          ],
                        ),
                      );
                    }
                    if(response['status']==422){
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('No Data',style: mainStyle.text18),
                      );
                    }
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Loading..',style: mainStyle.text18),
                  );
                }
                ,);
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Loading..',style: TextStyle(fontSize: 20),),
            );
          },
        )
      ),
    );
  }

}

Future<String> getStock(String ide) async {
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.getUrl(
      Uri.parse(API_URL + 'Athentication/user/'+ide));
  request.headers.set('Content-type', 'application/json');
  HttpClientResponse response = await request.close();
  httpClient.close();
  if (response.statusCode == 200) {
    String reply = await response.transform(utf8.decoder).join();
    return reply;
  }
}