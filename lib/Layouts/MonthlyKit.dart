import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sawarnabindudc/Functions/UserData.dart';
import 'package:sawarnabindudc/Functions/config.dart';

class MonthlyKit extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
     return monthlykitState();
  }
}

class monthlykitState extends State<MonthlyKit>{
  final _loginForm = GlobalKey<FormState>();
  String selecteddist='-Select Dist-',MedNo,strcname,strdob,strmob,stroccup,strPost,strQty,strstDate,mail;
  String selectedTaluk = '-Select Taluk-';
  String selectedkit = '-Select-';
  bool dtrue = false;

  DateTime selectedDate = DateTime.now();
  DateTime selectedDate2 = DateTime.now();
  TextEditingController _date = new TextEditingController();
  TextEditingController _date2 = new TextEditingController();

  bool loadDist = false;
  var talukData = Map<String,dynamic>();

  var mednoHolder = TextEditingController();
  var cnameHolder = TextEditingController();
  var dobHolder = TextEditingController();
  var mobHolder = TextEditingController();
  var occupHolder = TextEditingController();
  var postalHolder = TextEditingController();
  var qtyHolder = TextEditingController();
  var stdateHolder = TextEditingController();

  var mapDist = ['-Select Dist-'];
  var mapTaluk = ['-Select Taluk-'];
  List<String>mapKit = ['-Select-','Monthly Kit','De Addiction'];

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
          selecteddist = udata['district'];
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
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         actions: [
//           Padding(
//             padding: const EdgeInsets.all(2.0),
//             child: Image.asset('images/mainimg.png'),
//           ),
//         ],
//         title: Text('SWARNABINDU',style: TextStyle(fontSize: 24,color: Colors.blue),),
//         leading: MaterialButton(
//           onPressed: (){
//             Navigator.pop(context);
//           },
//           child: Icon(Icons.arrow_back,size: 30,color: Colors.black,),
//         ),
//       ),
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
//            mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Monthly Kit/De-addiction',style: TextStyle(fontSize:25 ),),
                    SizedBox(height: 18,),
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
                      value: selectedkit,
                      validator: (value) {
                        if(value == '-Select-'){
                          return 'Select Kit';
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
                          selectedkit = newValue;
                          if(selectedkit=='De Addiction'){
                            dtrue = true;
                          }else{
                            dtrue = false;
                          }
                          //  totalAmt = a.toString();
                          //   editedValue.text = totalAmt;
                        });
                      },
                      items: mapKit.map((quant) {
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
                          selectedTaluk = newValue;
                          //  totalAmt = a.toString();
                          //   editedValue.text = totalAmt;
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
                    Container(
                      child: TextFormField(controller: mednoHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                        const Radius.circular(0.0),
                      ),
                        borderSide: new BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),),
                          hintText: 'Medicine Number',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,keyboardType: TextInputType.number,
                        validator: (value){
                          if(value == null || value.isEmpty) {
                            return 'Medicine Number is required';
                          }
                        },
                        onSaved: (value){
                          MedNo = value;
                        }
                        ,),
                    ),
                    SizedBox(height: 12,),
                    if(dtrue)Container(
                      child: TextFormField(controller: cnameHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                        const Radius.circular(0.0),
                      ),
                        borderSide: new BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),),
                          hintText: 'Full Name',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,
                        validator: (value){
                          if(value == null || value.isEmpty) {
                            return 'Full Name is required';
                          }
                        },
                        onSaved: (value){
                          strcname = value;
                        }
                        ,),
                    ),
                    if(!dtrue)Container(
                      child: TextFormField(controller: cnameHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                        const Radius.circular(0.0),
                      ),
                        borderSide: new BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),),
                          hintText: 'Child Full Name',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,
                        validator: (value){
                          if(value == null || value.isEmpty) {
                            return 'Child Full Name is required';
                          }
                        },
                        onSaved: (value){
                          strcname = value;
                        }
                        ,),
                    ),
                    SizedBox(height: 12),
                    if(dtrue)GestureDetector(
                      onTap: (){
                        _selectDate(context);
                      },
                      child: AbsorbPointer(
                        child: TextFormField(controller: _date,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                          const Radius.circular(0.0),
                        ),
                          borderSide: new BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),),
                            hintText: 'Date of Birth',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,keyboardType: TextInputType.datetime,
                          validator: (value){
                            if(value == null || value.isEmpty) {
                              return 'Date of Birth is required';
                            }
                          },
                          onSaved: (value){
                            strdob = value;
                          }
                          ,),
                      ),
                    ),
                    if(!dtrue)GestureDetector(
                      onTap: (){
                        _selectDate(context);
                      },
                      child: AbsorbPointer(
                        child: TextFormField(controller: _date,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                          const Radius.circular(0.0),
                        ),
                          borderSide: new BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),),
                            hintText: 'Child Date of Birth',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,keyboardType: TextInputType.datetime,
                          validator: (value){
                            if(value == null || value.isEmpty) {
                              return 'Child Date of Birth is required';
                            }
                          },
                          onSaved: (value){
                            strdob = value;
                          }
                          ,),
                      ),
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
                          strmob = value;
                        }
                        ,),
                    ),
                    SizedBox(height: 20),
                    if(dtrue)Container(
                      child: TextFormField(controller: occupHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                        const Radius.circular(0.0),
                      ),
                        borderSide: new BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),),
                          hintText: 'Duration',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,
                        validator: (value){
                          if(value == null || value.isEmpty) {
                            return 'Duration is required';
                          }
                        },
                        onSaved: (value){
                          stroccup = value;
                        }
                        ,),
                    ),
                    if(!dtrue)Container(
                      child: TextFormField(controller: occupHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                        const Radius.circular(0.0),
                      ),
                        borderSide: new BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),),
                          hintText: 'Father Occupation',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,
                        validator: (value){
                          if(value == null || value.isEmpty) {
                            return 'Father Occupation is required';
                          }
                        },
                        onSaved: (value){
                          stroccup = value;
                        }
                        ,),
                    ),
                    SizedBox(height: 15),
                    Container(
                      child: TextFormField(controller: postalHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                        const Radius.circular(0.0),
                      ),
                        borderSide: new BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),),
                          hintText: 'Postal Address',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,
                        validator: (value){
                          if(value == null || value.isEmpty) {
                            return 'Postal Address is required';
                          }
                        },
                        onSaved: (value){
                          strPost = value;
                        }
                        ,),
                    ),
                    SizedBox(height: 15),
                    Container(
                      child: TextFormField(controller: qtyHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                        const Radius.circular(0.0),
                      ),
                        borderSide: new BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),),
                          hintText: 'Quantity',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,keyboardType: TextInputType.number,
                        validator: (value){
                          if(value == null || value.isEmpty) {
                            return 'Quantity is required';
                          }
                        },
                        onSaved: (value){
                          strQty = value;
                        }
                        ,),
                    ),
                    SizedBox(height: 15),
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
                            hintText: 'Start Date',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,keyboardType: TextInputType.datetime,
                          validator: (value){
                            if(value == null || value.isEmpty || value.length!=10) {
                              return 'Start Date';
                            }
                          },
                          onSaved: (value){
                            strstDate = value;
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
      'user' : mail,
      'dist' : selecteddist,
      'taluk' : selectedTaluk,
      'card' : MedNo,
      'cname' : strcname,
      'dob' : strdob,
      'mobile' : strmob,
      'father_occ' : stroccup,
      'address' : strPost,
      'qnt' : strQty,
      'sdate' : strstDate,
      'state' : "Karnataka",
      'med' : selectedkit,
    };
    submitState(body).then((value) {
      Navigator.pop(context);
      var response = jsonDecode(value);
     
     if(response == 0){
       Fluttertoast.showToast(msg: 'This medicine number already exist',gravity: ToastGravity.CENTER,toastLength: Toast.LENGTH_SHORT);
     }
      if(response == 1) {
        Fluttertoast.showToast(
            msg: "Registered Successfully", gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_SHORT);

        setState(() {
          selectedTaluk = '-Select Taluk-';
          selectedkit = '-Select-';
          mednoHolder.text = '';
          cnameHolder.text = '';
          dobHolder.text = '';
          mobHolder.text = '';
          occupHolder.text = '';
          postalHolder.text = '';
          qtyHolder.text = '';
          stdateHolder.text = '';
          _date.text = '';
          _date2.text = '';
        }
        );
      }});
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        String dateFormate = DateFormat("dd-MM-yyyy").format(picked);
        _date.value = TextEditingValue(text: dateFormate.toString());
      });
  }

  Future<Null> _selectDate2(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate2,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate2)
      setState(() {
        selectedDate2 = picked;
        String dateFormate = DateFormat("dd-MM-yyyy").format(picked);
        _date2.value = TextEditingValue(text: dateFormate.toString());
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
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(API_URL2+'monthly_kit'));
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