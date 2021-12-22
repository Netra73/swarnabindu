import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sawarnabindudc/Functions/UserData.dart';
import 'package:sawarnabindudc/Functions/config.dart';
import 'package:sawarnabindudc/Layouts/DashBoard.dart';
import 'package:sawarnabindudc/Layouts/EditCard.dart';
import 'package:sawarnabindudc/Layouts/HomePage.dart';
import 'package:sawarnabindudc/Layouts/Stack.dart';
import 'package:sawarnabindudc/Layouts/Viewallstock.dart';
import 'package:sawarnabindudc/Modules/stockModule.dart';
import 'package:sawarnabindudc/Modules/stockModule.dart';
import 'package:sawarnabindudc/Modules/todaysModule.dart';
import 'package:sawarnabindudc/Modules/userUpdateModule.dart';
import 'package:sawarnabindudc/Styles/textstyle.dart';


import 'Camp.dart';
import 'DReports.dart';
import 'DatabaseHelper.dart';
import 'EditProfile.dart';
import 'IssueHistory.dart';
import 'Login.dart';
import 'MonthlyKit.dart';
import 'SurveyDialog.dart';
import 'campDialog.dart';
class distModule{
  String id,name;

  distModule(this.id, this.name);

}

class campPendig{
  String cname,amt;

  campPendig(this.cname, this.amt);

}
class HomePage2 extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomePageState2();
  }
}

class HomePageState2 extends State<HomePage2>{
 String id,c100,c80,med,email,dateformat2,dateformat3,Ename = "Name",Epost = "post",mobile,taluk,district="",gender,deposit,survey,dose;
 List<stockModule>stockList = [];
 List<UpdateModule>updatelist = [];
 List<TodayasModule>todaysList = [];
 List<distModule>distList = [];
 List<campPendig>cpList = [];
 bool tlist = false;
 bool hdata = false;
 DateTime selectedDate = DateTime.now();
 String dist = "",upData="";
 bool load = false;

  @override
  void initState() {
     dateformat2 = DateFormat("yyyy-MM-dd").format(selectedDate);
     dateformat3 = DateFormat("dd-MM-yyyy").format(selectedDate);
    // TODO: implement initState
    getData("USERData").then((value) {
       var data = jsonDecode(value);
       id = data['id'].toString();
       email = data['email'].toString();

       getData("selDist").then((value){
         district = value;
         getUserUpdate(id).then((value) {
           upData = value;
           var response = jsonDecode(value);
           if(response['status'] == 200) {
             var data = response['data'];
             var profile = data['profile'];
             String name = profile['name'];
             String post = profile['post'];
             dist = profile['district'];
             Ename = name;
             Epost = post;

             setData("USERData", jsonEncode(data['profile'])).then((value) {
               setState(() {
                 load = true;
               });
             });
           }

         });
       });


    });
    DatabaseHelper.instance.getPendingCount().then((value) {
      setState(() {
        if(value.isNotEmpty){
          hdata = true;
        }
        else{
          hdata = false;
        }
      });
    });
  }

 _refresh(){
   DatabaseHelper.instance.getPendingCount().then((value) {
     setState(() {
       if(value.isNotEmpty){
         hdata = true;
       }
       else{
         hdata = false;
       }
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

 _distDialog(){
   return showDialog<String>(
     context: context,
     barrierDismissible: false,
     builder: (BuildContext context) {
       distList.clear();
       return Container(
           child: Container(
             margin: EdgeInsets.all(20.0),
             color: Colors.white,
             padding: EdgeInsets.all(10.0),
             height: 200.0,
             child: FutureBuilder(
               future: getData("District"),
               builder: (context,ddata){
                 if(ddata.hasData){
                   var distData = jsonDecode(ddata.data);
                   for (var details in distData) {
                     String id = details['id'];
                     String name = details['dist'];
                     distList.add(distModule(id, name));
                   }

                   return ListView.builder(
                       itemCount: distList.length,
                       itemBuilder: (context,i){
                         return GestureDetector(
                           onTap: (){
                              _getTaluk(distList[i].name.toString());
                           },
                           child: Card(
                             child: Container(
                                 padding: EdgeInsets.all(12.0),
                                 child: Text(distList[i].name.toString(),style: TextStyle(color: Colors.blue,fontSize: 18.0),)),
                           ),
                         );
                       });
                 }
                 return SizedBox();
               },
             ),
           )
         );
     },
   );
 }




  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(load) {
      var response = jsonDecode(upData);
      todaysList.clear();
      cpList.clear();
      var data = response['data'];
      var summary = data['summary'];
      deposit = summary['deposit'].toString();
      survey = summary['survey'].toString();
      dose = summary['dose'].toString();
      var cp = summary['camp'];
      if(cp!=""){
        for(var dd in cp){
          cpList.add(campPendig(dd['camp'].toString(),dd['amount'].toString()));
        }
      }

      var todayCamp = data['todayCamp'];

      for (var details in todayCamp) {
        String id = details['id'];
        String name = details['name'];
        String taluk = details['taluk'];
        String customer = details['customer'];
        String type = details['type'];
        int c = int.parse(customer);
        todaysList.add(TodayasModule(id, name, taluk, customer, type));

        // todaysList.add(TodayasModule(id,name,taluk,customer,type));

      }
      if (todaysList.isNotEmpty) {
        tlist = true;
      }
    }

     return Scaffold(
      appBar:  PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          backgroundColor: Colors.orange,
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            child:  Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 6),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              text: "$Ename",
                              style: TextStyle(fontSize: 22),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '  $Epost',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ]
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(district,style: TextStyle(fontSize:18,color: Colors.white),),
                      ],
                    ),
                  ),
                  Container(
                    width: 50.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(icon: Icon(Icons.exit_to_app,size:30,color: Colors.red,), onPressed: () {
                          removeData("USERData").then((value) {
                            removeData("USERMail").then((value) {
                              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                  Login()), (Route<dynamic> route) => false);
                            });
                          });
                        }),
                        IconButton(icon: Icon(Icons.settings,size:30,color: Colors.white,), onPressed: () {
                          _distDialog();
                        }),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15),
            ),
          ),
        ),
      ),
       body: SingleChildScrollView(
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.stretch,
           children: [
            if(hdata) Padding(
               padding: const EdgeInsets.only(left: 6,right: 6,top: 6),
               child: Card(
                 elevation: 2,
                 shape: RoundedRectangleBorder(
                     side: BorderSide(width: 0.2),
                     borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15))),
                 child: Padding(
                   padding: const EdgeInsets.only(left: 12),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       SizedBox(height: 10),
                       Text('Offline Entries',style: mainStyle.text18BoldM,),
                       SizedBox(height: 8),
                       FutureBuilder(
                         future:  fetchOfflineDatabase(),
                         builder: (context,snapshot){
                           if(snapshot.hasData){
                             return ListView.separated(
                               shrinkWrap: true,
                               itemCount: snapshot.data.length,
                               itemBuilder: (context, index) {
                                 return  Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children: <Widget>[
                                       Container(
                                         width:130,
                                         child: Text(snapshot.data[index]['campName'].toString(),
                                             style: new TextStyle(fontSize: 18.0)),
                                       ),
                                       Row(
                                         children: [
                                           Icon(Icons.people,size: 20,),
                                           SizedBox(width: 4),
                                           Text(snapshot.data[index]['total'].toString(),
                                               style: new TextStyle(fontSize: 18.0)),
                                         ],
                                       ),
                                       GestureDetector(
                                         onTap: (){
                                           DatabaseHelper.instance.getCampCustomer(snapshot.data[index]['camp']).then((value){
                                             String camp = snapshot.data[index]['camp'].toString();
                                             var data = jsonEncode(value);
                                             _selectDate(context).then((value){
                                               if(value!=''){
                                                 SyncMethod(context,data,email,camp,value);
                                               }
                                             });
                                           });
                                         },
                                         child: Card(
                                             margin: const EdgeInsets.only(left: 8.0,right: 8.0,bottom: 6),
                                             shape: RoundedRectangleBorder(
                                               borderRadius: BorderRadius.only(topRight:Radius.circular(20),bottomRight: Radius.circular(20)),
                                             ),
                                             color: Colors.black,
                                             child: Padding(
                                               padding: const EdgeInsets.all(2.0),
                                               child: Row(
                                                 children: [
                                                   const Text("Sync",style: TextStyle(fontSize: 16,color: Colors.white),textAlign: TextAlign.center,),
                                                   Icon(Icons.sync,color: Colors.white,),
                                                 ],
                                               ),
                                             )),
                                       ),
                                     ]);
                               },
                               separatorBuilder: (context, index) {
                                 return Divider();
                               },
                             );
                           }
                           return Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Text('Loading',style: mainStyle.text18),
                           );
                         }
                         ,)
                     ],
                   ),
                 ),
               ),
             ),
             SizedBox(height: 5),
             load ? Column(
             children: [
                Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: Card(
                       elevation: 2,
                       shape: RoundedRectangleBorder(
                       side: BorderSide(width: 0.2),
                       borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15))),
                       child: Padding(
                       padding: const EdgeInsets.only(left: 4,right: 8),
                       child: Padding(
                       padding: const EdgeInsets.only(bottom: 12),
                       child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: <Widget>[
                       SizedBox(height: 5),
                       Padding(
                       padding: const EdgeInsets.only(left: 8,right: 8,bottom: 6),
                       child: Text('Today\'s Updates',style: mainStyle.text18BoldM,),
                       ),
                       Padding(
                       padding: const EdgeInsets.only(left: 8,right: 8,top: 8),
                       child: Column(
                       children: [
                       Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                       Row(
                       children: [
                       Icon(Icons.credit_card,size:20.0,color: Colors.blue,),
                       SizedBox(width: 6),
                       Text('Deposit Pending', style: new TextStyle(fontSize: 18.0)),
                       ],
                       ),
                         if(cpList.length<1) Text('0',style: new TextStyle(fontSize: 18.0)),
                       ],
                       ),
                       if(cpList.length>0)
                         Container(
                           margin: EdgeInsets.only(top: 5.0,bottom: 5.0),
                           child: ListView.builder(
                               shrinkWrap: true,
                               itemCount: cpList.length,
                               itemBuilder: (context,i){
                                 return Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Container(
                                         child: Text(cpList[i].cname),
                                     margin: EdgeInsets.only(left: 25.0),),
                                     Text(cpList[i].amt),
                                   ],
                                 );
                           }),
                         ),
                       Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                       Row(
                       children: [
                       Icon(Icons.credit_card,size:20.0,color: Colors.blue,),
                       SizedBox(width: 6),
                       Text('Survey\'s Done', style: new TextStyle(fontSize: 18.0)),
                       ],
                       ),
                       Text(survey,
                       style: new TextStyle(fontSize: 18.0)),
                       ],
                       ),
                       Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                       Row(
                       children: [
                       Icon(Icons.credit_card,size:20.0,color: Colors.blue,),
                       SizedBox(width: 6),
                       Text('Dose Given', style: new TextStyle(fontSize: 18.0)),
                       ],
                       ),
                       Text(dose,
                       style: new TextStyle(fontSize: 18.0)),
                       ],
                       ),
                       ],
                       ),
                       )

                       ]),
                       ),
                       ),
                   ),
             ),
                Padding(
             padding: const EdgeInsets.only(left: 6,right: 6),
             child: Card(
             elevation : 2,
             child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             mainAxisSize: MainAxisSize.min,
             children: [
             Container(
             width: double.infinity,
             color: Colors.grey[300],
             child: Padding(
             padding: const EdgeInsets.all(8.0),
             child: Text('Today\'s Camp',style: mainStyle.text18BoldM,),
             )),
             SizedBox(height: 8),
             if(tlist)Padding(
             padding: const EdgeInsets.only(left: 5,right: 5),
             child: Row(
             children: [
             Expanded(
             child: Container(
             height: 80,
             child: ListView.builder(
             scrollDirection: Axis.horizontal,
             itemCount: todaysList.length,
             shrinkWrap: true,
             itemBuilder: (context,i){
             return Container(
             // width: MediaQuery.of(context).size.width,
             width: 350,
             padding: EdgeInsets.only(right: 5,left: 5,top: 5),
             margin: EdgeInsets.only(right: 8,bottom: 8),
             decoration: BoxDecoration(
             border: mainStyle.grayBorder,
             borderRadius: BorderRadius.circular(10.0)
             ),
             child: Padding(
             padding: const EdgeInsets.only(left: 12,right: 18),
             child: Column(
             mainAxisSize: MainAxisSize.min,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: <Widget>[
             Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
             Row(
             children: [
             Icon(Icons.home,size: 20,),
             SizedBox(width: 4),
             Text(todaysList[i].pname.toString(),
             style: new TextStyle(fontSize: 18.0)),
             ],
             ),
             Row(
             children: [
             Icon(Icons.people,size: 20,),
             SizedBox(width: 4),
             Text(todaysList[i].num.toString(),
             style: new TextStyle(fontSize: 18.0)),
             ],
             ),
             ],
             ),
             SizedBox(height: 5),
             Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
             Row(
             children: [
             Icon(Icons.location_on,size: 20,),
             SizedBox(width: 4),
             Text(todaysList[i].taluk.toString(),
             style: new TextStyle(fontSize: 18.0)),
             ],
             ),
             Container(
             height: 25,
             child: RaisedButton(
             onPressed: (){
             submit(todaysList[i].id.toString(), dateformat2,todaysList[i].taluk,todaysList[i].pname,dateformat3,todaysList[i].type.toString());
//                                                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Camp(todaysList[i].taluk,todaysList[i].pname,dateformat3,todaysList[i].type.toString(),dateformat2,todaysList[i].id.toString()))).then((value) {
//                                                                        setState(() {
//
//                                                                        });
//                                                                      });
             },
             padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
             color: Colors.blue,
             child: Text('START',style: TextStyle(fontSize: 12.0,color: Colors.white),),
             ),
             ),
             ],
             ),
             ]),
             ),
             );
             }),
             ),
             ),
             ],
             ),
             ),
             if(!tlist) Padding(
             padding: const EdgeInsets.all(8.0),
             child: Text('No Camps Created Today..',style: mainStyle.text18),
             ),
             ],
             ),
             ),
             ),
             ],
             ): Container(
               child: Center(
                 child: Text("Loading..."),
               ),
             ),
             GridView.count(
               primary: false,
               shrinkWrap: true,
               padding: const EdgeInsets.all(10),
               crossAxisSpacing: 10,
               mainAxisSpacing: 12,
               crossAxisCount: 3,
               children: <Widget>[
                 GestureDetector(
                   onTap: (){
                     Navigator.push(context, MaterialPageRoute(builder: (context)=> DashBoard(1))).then((value){
                       _refresh();
                     });
                   },
                   child: Card(
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(15.0),
                     ),
                     elevation: 2,
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.stretch,
                       mainAxisAlignment: MainAxisAlignment.end,
                       children: [
                         Image(image: AssetImage('images/camp.png'),height: 40,width: 20,),
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: const Text("Camp Dose",style: TextStyle(fontSize: 18,color: Colors.orange),textAlign: TextAlign.center,),
                         ),
                         // color: Colors.teal[100],
                       ],
                     ),
                   ),
                 ),
                 GestureDetector(
                   onTap: (){
                     Navigator.push(context, MaterialPageRoute(builder: (context)=> DashBoard(2))).then((value){
                       _refresh();
                     });
                   },
                   child: Card(
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(15.0),
                     ),
                     elevation: 2,
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.stretch,
                       mainAxisAlignment: MainAxisAlignment.end,
                       mainAxisSize: MainAxisSize.min,
                       children: [
                         Image(image: AssetImage('images/survey1.png'),height: 40,width: 20,),
                         Padding(
                           padding: const EdgeInsets.only(left: 8,right: 8,bottom: 8),
                           child: const Text("Create Camp",style: TextStyle(fontSize: 18,color: Colors.orange),textAlign: TextAlign.center,),
                         ),
                         // color: Colors.teal[100],
                       ],
                     ),
                   ),
                 ),
                 GestureDetector(
                   onTap: (){
                     Navigator.push(context, MaterialPageRoute(builder: (context)=> DashBoard(4))).then((value){
                       _refresh();
                     });
                   },
                   child: Card(
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(15.0),
                     ),
                     elevation: 2,
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.stretch,
                       mainAxisAlignment: MainAxisAlignment.end,
                       children: [
                         Image(image: AssetImage('images/month.png'),height: 40,width: 20,),
                         Padding(
                           padding: const EdgeInsets.only(right: 8,left: 8,bottom: 8),
                           child: const Text("Monthly Kit",style: TextStyle(fontSize: 18,color: Colors.orange),textAlign: TextAlign.center,),
                         ),
                         // color: Colors.teal[100],
                       ],
                     ),
                   ),
                 ),
                 GestureDetector(
                   onTap: (){
                     Navigator.push(context, MaterialPageRoute(builder: (context)=> DashBoard(3))).then((value){
                       _refresh();
                     });
                   },
                   child: Card(
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(15.0),
                     ),
                     elevation: 2,
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.stretch,
                       mainAxisAlignment: MainAxisAlignment.end,
                       mainAxisSize: MainAxisSize.min,
                       children: [
                         Icon(Icons.assignment_late ,size: 36,color: Colors.blueGrey,),
                         Padding(
                           padding: const EdgeInsets.only(right: 8,left: 8,bottom: 8),
                           child: const Text("Material",style: TextStyle(fontSize: 18,color: Colors.orange),textAlign: TextAlign.center,),
                         ),
                         // color: Colors.teal[100],
                       ],
                     ),
                   ),
                 ),
                 GestureDetector(
                   onTap: (){
                     Navigator.push(context, MaterialPageRoute(builder: (context)=> viewAllStock())).then((value){
                       _refresh();
                     });
                     //  Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage(0)));
                     // Navigator.pop(context,"1");
                   },
                   child: Card(
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(15.0),
                     ),
                     elevation: 2,
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.stretch,
                       mainAxisAlignment: MainAxisAlignment.end,
                       children: [
                         Icon(Icons.storage ,size: 36,color: Colors.blueGrey,),
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: const Text("Stock",style: TextStyle(fontSize: 18,color: Colors.orange),textAlign: TextAlign.center,),
                         ),
                         // color: Colors.teal[100],
                       ],
                     ),
                   ),
                 ),
                 GestureDetector(
                   onTap: (){
                     Navigator.push(context, MaterialPageRoute(builder: (context)=> DashBoard(5))).then((value){
                       _refresh();
                     });
                   },
                   child: Card(
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(15.0),
                     ),
                     elevation: 2,
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.stretch,
                       mainAxisAlignment: MainAxisAlignment.end,
                       children: [
                         Image(image: AssetImage('images/report.png'),height: 40,width: 20,),
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: const Text("Reports",style: TextStyle(fontSize: 18,color: Colors.orange),textAlign: TextAlign.center,),
                         ),
                         // color: Colors.teal[100],
                       ],
                     ),
                   ),
                 ),
               ],
             ),
           ],
         ),
       ),
    );
  }

 void submit(String camp,String date,String selectedT,String selectedcamp,String strDate,String campType){
   var body = {
     "camp" : camp,
     "date" : dateformat2,
   };
   print('campBodyyyyyhomeee $body');
   submitCamp(body).then((value) {
     var responce = jsonDecode(value);
     if(responce['status'] == 200){
       String num = responce['number'].toString();
       Navigator.push(context, MaterialPageRoute(builder: (context)=> Camp(selectedT,selectedcamp,strDate,campType,dateformat2,camp,num))).then((value) {
         setState(() {

         });
       });
     }
     print('campvalueeeeehome $responce');
   });
 }

 Future<String> submitCamp(body) async {
   HttpClient httpClient = new HttpClient();
   HttpClientRequest request = await httpClient.postUrl(Uri.parse(API_URL+'getCampNumber'));
   request.headers.set('Content-type', 'application/json');
   request.add(utf8.encode(jsonEncode(body)));
   HttpClientResponse response = await request.close();
   httpClient.close();
   if(response.statusCode==200) {
     String reply = await response.transform(utf8.decoder).join();
     print('reply $reply');
     return reply;
   }
 }

 Future<String> _selectDate(BuildContext context) async {
   final DateTime picked = await showDatePicker(
       context: context,
       helpText: 'Select Camp Date',
       confirmText: 'Submit',
       initialDate: selectedDate,
       firstDate: DateTime(2021),
       lastDate: DateTime(2100));
   if (picked != null) {
     String dateFormate = DateFormat("dd-MM-yyyy").format(picked);
     return dateFormate;
   }
   return '';
 }

 void SyncMethod(context,var body,String emailId,String camp,String cdate) {
    _showLoading();
     submitSync(body, emailId,cdate).then((value) {
     Navigator.pop(context);
     var responce = jsonDecode(value);
     if(responce['status'] == 200) {
       _showLoading();
       DatabaseHelper.instance.deleteCustomer(" ",camp).then((value){
         Navigator.pop(context);
         setState(() {
         });
         DatabaseHelper.instance.getPendingCount().then((value) {
           setState(() {

           });
           if(value.isNotEmpty){
             hdata = true;
           }else{
             hdata = false;
           }
           setState(() {

           });
         });
         setState(() {

         });
       });
     }
     if(responce['status'] == 422 ){
       _showLoading();
       var data = responce['data'];
       List dnum = [];
       String card;
       String id;
       String s;
       String st;
       for(var details in data){
         id = details['id'].toString();
         card = details['card'].toString();
         String status = details['status'].toString();
         dnum.add(id);
         s = dnum.join("','");
         st = '\'$s\'';
       }

      DatabaseHelper.instance.deleteCustomer(st,camp).then((value){
        Navigator.pop(context);
        setState(() {

        });

        Navigator.push(context, MaterialPageRoute(builder: (context)=>EditCard(camp))).then((value) {
          DatabaseHelper.instance.getPendingCount().then((value) {
            if(value.isNotEmpty){
              hdata = true;
            }else{
              hdata = false;
            }
            setState(() {

            });
          });
        });

      });
     }
   });
 }

 Future<List<Map>> fetchOfflineDatabase() async {
   DatabaseHelper.instance.getPendingCount().then((value) {
   });
   return DatabaseHelper.instance.getPendingCount();
 }

 void _getTaluk(String tk){
   Navigator.pop(context);
   _showLoading();
   getTaluk(tk).then((value){
     var response = jsonDecode(value);
     if(response['status'] == 200) {
       var data = response['data'];
       setData("TalukOffData", jsonEncode(data)).then((value){
         setData("selDist", tk).then((value){
          Navigator.pop(context);
          setState(() {
            district = tk;
          });
         });
       });
     }
   });
 }

}



Future<String> getTaluk(String tk) async {
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.getUrl(
      Uri.parse(API_URL + 'Athentication/get_taluk/'+tk));
  request.headers.set('Content-type', 'application/json');
  HttpClientResponse response = await request.close();
  httpClient.close();
  if (response.statusCode == 200) {
    String reply = await response.transform(utf8.decoder).join();
    return reply;
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
Future<String> getUserUpdate(String ide) async {
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.getUrl(
      Uri.parse(API_URL + 'Athentication/user_update/'+ide));
  request.headers.set('Content-type', 'application/json');
  HttpClientResponse response = await request.close();
  httpClient.close();
  if (response.statusCode == 200) {
    String reply = await response.transform(utf8.decoder).join();
    return reply;
  }
}

Future<String> submitSync(body,String emaill,String cdate) async {
  var sdata = {
    "emp":emaill,
    "data":body,
    "date":cdate
  };
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.postUrl(Uri.parse(API_URL2+'syncCustomer'));
  request.headers.set('Content-type', 'application/JSON');
  request.add(utf8.encode(jsonEncode(sdata)));
  HttpClientResponse response = await request.close();
  httpClient.close();
  if(response.statusCode==200) {
    String reply = await response.transform(utf8.decoder).join();
    return reply;
  }
}
