import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sawarnabindudc/Functions/UserData.dart';
import 'package:sawarnabindudc/Functions/config.dart';

class DReports extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DReportsState();
  }
}

class DReportsState extends State<DReports>{
  final _loginForm = GlobalKey<FormState>();
  String selecteddist='-Select Dist-',totalExp,attname,attnum,ashapay,ashaname,ashanum,totalAmt,strTA,nc,strAsha,strHand,strDose,mail,fdistrict,campId="0",strdate,strdate2,dateformat2,dateformat3;
  String selectedTaluk = '-Select Taluk-';
  String selectedCamp = '-Select Camp-';
  DateTime selectedDate = DateTime.now();
  DateTime selectedDate2 = DateTime.now();
  var _date = TextEditingController();
  var _date2 = TextEditingController();

  var attenderNameHolder = TextEditingController();
  var attenderNumberHolder = TextEditingController();
  var ashaNameHolder = TextEditingController();
  var ashaNumberHolder = TextEditingController();
  var handicapHolder = TextEditingController();
  var totaldoseHolder = TextEditingController();
  var ashaHolder = TextEditingController();
  var TAkmHolder = TextEditingController();
  var totalAmtHolder = TextEditingController();
  var totalExpenseHolder = TextEditingController();
  var ncHolder = TextEditingController();
  var ashaPayHolder = TextEditingController();

  var mapDist = ['-Select Dist-'];
  var mapTaluk = ['-Select Taluk-'];
  var mapCamp = ['-Select Camp-'];

  var talukData = Map<String,dynamic>();
  var campData = Map<String,String>();

  bool loadDist = false;

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

  _loadTaluk(dname){
    setState(() {
      var tdata = jsonDecode(talukData[dname]);
      mapTaluk.clear();
      mapTaluk.add('-Select Taluk-');
      selectedTaluk = '-Select Taluk-';
      for(var detail in tdata){
        mapTaluk.add(detail['tq_name']);
      }
    });
  }

  _loadCamp(tname){
    _showLoading();
    getCamp(tname).then((value) {
       mapCamp.clear();
       campData.clear();
       mapCamp.add("-Select Camp-");
       selectedCamp = '-Select Camp-';
       if(value != "0"){
          var response = jsonDecode(value);
          for(var details in response){
            mapCamp.add(details['cp_name']);
            campData[details['cp_name']]=details['cp_id'];
          }
       }
      Navigator.pop(context);
      setState(() {
        selectedTaluk = tname;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dateformat2 = DateFormat("yyyy-MM-dd").format(selectedDate);
    getData("USERData").then((value) {
      setState(() {
        if(value!=null){
          var udata = jsonDecode(value);
          mail = udata['email'];
          attname = udata['name'];
          attnum = udata['mobile'];
          fdistrict = udata['district'];
          getData("TalukOffData").then((value) {
            if(value!=null){
              var tdata = jsonDecode(value);
              for(var details2 in tdata){
                mapTaluk.add(details2['taluk']);
              }
              //loadTaluk = true;
              loadDist = true;
            }
          });
        }
      });
    });

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _loginForm,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: loadDist ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Send Report',style: TextStyle(fontSize:25 ),),
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
                        setState(() {
                          _loadCamp(newValue);
                          selectedTaluk = newValue;
                        });
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
//                    SizedBox(height: 12,),
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
//                            if(value == null || value.isEmpty ) {
//                              return 'Camp Date is required';
//                            }
//                          },
//                          onSaved: (value){
//                            strdate = value;
//                          }
//                          ,),
//                      ),
//                    ),
                    SizedBox(height: 12,),
                    Container(
                      child: TextFormField(controller: ashaNameHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                        const Radius.circular(0.0),
                      ),
                        borderSide: new BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),),
                          hintText: 'Asha Name',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,
                        validator: (value){
                          if(value == null || value.isEmpty) {
                            return 'Asha Name is required';
                          }
                        },
                        onSaved: (value){
                          ashaname = value;
                        }
                        ,),
                    ),
                    SizedBox(height: 12),
                    Container(
                      child: TextFormField(controller: ashaNumberHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                        const Radius.circular(0.0),
                      ),
                        borderSide: new BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),),
                          hintText: 'Asha Mobile Number',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,keyboardType: TextInputType.number,
                        validator: (value){
                          if(value == null || value.isEmpty) {
                            return 'Asha Mobile Number is required';
                          }
                        },
                        onSaved: (value){
                          ashanum = value;
                        }
                        ,),
                    ),
                    SizedBox(height: 12),
                    Container(
                      child: TextFormField(controller: totaldoseHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                        const Radius.circular(0.0),
                      ),
                        borderSide: new BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),),
                          hintText: 'Total Dose',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,keyboardType: TextInputType.number,
                        validator: (value){
                          if(value == null || value.isEmpty) {
                            return 'Total Dose is required';
                          }
                        },
                        onSaved: (value){
                          strDose = value;
                        }
                        ,),
                    ),
                    SizedBox(height: 12),
                    Container(
                      child: TextFormField(controller: ncHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                        const Radius.circular(0.0),
                      ),
                        borderSide: new BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),),
                          hintText: 'New Card',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,keyboardType: TextInputType.number,
                        validator: (value){
                          if(value == null || value.isEmpty) {
                            return 'New Card is required';
                          }
                        },
                        onSaved: (value){
                          nc = value;
                        }
                        ,),
                    ),
                    SizedBox(height: 12),
                    Container(
                      child: TextFormField(controller: ashaPayHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                        const Radius.circular(0.0),
                      ),
                        borderSide: new BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),),
                          hintText: 'Asha Pay',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,keyboardType: TextInputType.number,
                        validator: (value){
                          if(value == null || value.isEmpty) {
                            return 'Asha pay is required';
                          }
                        },
                        onSaved: (value){
                          ashapay = value;
                        }
                        ,),
                    ),
                    SizedBox(height: 12),
                    Container(
                      child: TextFormField(controller: TAkmHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                        const Radius.circular(0.0),
                      ),
                        borderSide: new BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),),
                          hintText: 'TA(km)',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,keyboardType: TextInputType.number,
                        validator: (value){
                          if(value == null || value.isEmpty ) {
                            return 'TA(km) is required';
                          }
                        },
                        onSaved: (value){
                          strTA = value;
                        }
                        ,),
                    ),
                    SizedBox(height: 12),
                    Container(
                      child: TextFormField(controller: ashaHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                        const Radius.circular(0.0),
                      ),
                        borderSide: new BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),),
                          hintText: 'ASHA Child',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,keyboardType: TextInputType.number,
                        validator: (value){
                          if(value == null || value.isEmpty) {
                            return 'Number of ASHA Child is required';
                          }
                        },
                        onSaved: (value){
                          strAsha = value;
                        }
                        ,),
                    ),
                    SizedBox(height: 12),
                    Container(
                      child: TextFormField(controller: handicapHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                        const Radius.circular(0.0),
                      ),
                        borderSide: new BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),),
                          hintText: 'Handicap',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,keyboardType: TextInputType.number,
                        validator: (value){
                          if(value == null || value.isEmpty) {
                            return 'Number of Handicap is required';
                          }
                        },
                        onSaved: (value){
                          strHand = value;
                        }
                        ,),
                    ),
                    SizedBox(height: 12),
                    Container(
                      child: TextFormField(controller: totalExpenseHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                        const Radius.circular(0.0),
                      ),
                        borderSide: new BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),),
                          hintText: 'Total Expense',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,keyboardType: TextInputType.number,
                        validator: (value){
                          if(value == null || value.isEmpty) {
                            return 'Total Expense is required';
                          }
                        },
                        onSaved: (value){
                          totalExp = value;
                        }
                        ,),
                    ),
                    SizedBox(height: 12),
                    Container(
                      child: TextFormField(controller: totalAmtHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                        const Radius.circular(0.0),
                      ),
                        borderSide: new BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),),
                          hintText: 'Total Amount',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,keyboardType: TextInputType.number,
                        validator: (value){
                          if(value == null || value.isEmpty) {
                            return 'Total Amount is required';
                          }
                        },
                        onSaved: (value){
                          totalAmt = value;
                        }
                        ,),
                    ),
                    SizedBox(height: 12),
                    GestureDetector(
                      onTap: (){
                        _selectDate2(context);
                      },
                      child: AbsorbPointer(
                        child: TextFormField(controller: _date2,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                          const Radius.circular(0.0),
                        ),
                          borderSide: new BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),),
                            hintText: 'Deposite Date',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,keyboardType: TextInputType.datetime,
                          validator: (value){
                            if(value == null || value.isEmpty || value.length!=10) {
                              return 'Deposite Date is required';
                            }
                          },
                          onSaved: (value){
                            strdate2 = value;
                          }
                          ,),
                      ),
                    ),
                    SizedBox(height: 15),
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
                ): SpinKitThreeBounce(
                  color: Colors.amber,
                  size: 20,
                )
              ),
            ),
          ),
        ),
      ),
    );
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
        dateformat2 = DateFormat("yyyy-MM-dd").format(picked);
        _date.value = TextEditingValue(text: dateFormate.toString());
      });
  }

  Future<Null> _selectDate2(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate2,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != selectedDate2)
      setState(() {
        selectedDate2 = picked;
        String dateFormate = DateFormat("dd-MM-yyyy").format(picked);
        dateformat3 = DateFormat("yyyy-MM-dd").format(picked);
        _date2.value = TextEditingValue(text: dateFormate.toString());
      });
  }


  void submit(){
    int a = int.parse(totalExp);
    int tt = int.parse(totalAmt)-a;
    _showLoading();
    var body = {
      'employeeEmail':mail,
      'attendarName':attname,
      'attendarMobile':attnum,
      'camp':campId,
      'campDate':dateformat2,
      'ashaName':ashaname,
      'ashaMobile':ashanum,
      'totalDose':strDose,
      'totalAmount':totalAmt,
      'nc':nc,
      'ashaPay':ashapay,
      'ta':strTA,
      'ashaChild':strAsha,
      'handicap':strHand,
      'totalExpense':a.toString(),
      'grandTotal':tt.toString(),
      'depositeDate':dateformat3
    };

    submitState(body).then((value){
      Navigator.pop(context);
       var response = jsonDecode(value);
       if(response['status'] == 200){
         final snackBar = SnackBar(
           content: Text('Report Sent'),
           action: SnackBarAction(
             label: '',
             onPressed: () {
               // Some code to undo the change.
             },
           ),
         );
         Scaffold.of(context).showSnackBar(snackBar);

         Fluttertoast.showToast(msg: 'Report Sent',gravity: ToastGravity.CENTER,toastLength: Toast.LENGTH_LONG);
         setState(() {
           selecteddist='-Select Dist-';
           selectedTaluk = '-Select Taluk-';
           selectedCamp = '-Select Camp-';
           attenderNameHolder.text = '';
           attenderNumberHolder.text = '';
           _date.text = '';
           ashaHolder.text = '';
           ashaNumberHolder.text = '';
           totaldoseHolder.text = '';
           totalAmtHolder.text = '';
           ncHolder.text = '';
           ashaNameHolder.text = '';
           totalExpenseHolder.text = '';
           ashaPayHolder.text = '';
           handicapHolder.text = '';
           ashaHolder.text = '';
           _date2.text = '';
           TAkmHolder.text = '';
         }
         );
       }
       if(response['status'] == 422){
         Fluttertoast.showToast(msg: 'Report Not Sent',gravity: ToastGravity.CENTER,toastLength: Toast.LENGTH_LONG);
       }
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

  Future<String> getCamp(body) async {
    var rbody = {
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
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(API_URL+'campReport'));
    request.headers.set('Content-type', 'application/json');
    request.add(utf8.encode(json.encode(body)));
    HttpClientResponse response = await request.close();
    httpClient.close();
    if(response.statusCode==200) {
      String reply = await response.transform(utf8.decoder).join();
      return reply;
    }
  }

}