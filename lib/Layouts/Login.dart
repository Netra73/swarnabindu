import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:sawarnabindudc/Layouts/DashBoard.dart';
import 'package:sawarnabindudc/Layouts/HomePage2.dart';
import 'package:sawarnabindudc/Layouts/Issuematerial.dart';

import '../Functions/UserData.dart';
import '../Functions/config.dart';
import 'IssueHistory.dart';
import 'Report.dart';



class Login extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login>{
  bool inValid = false;
  final _loginForm  = GlobalKey<FormState>();
  String username;
  String password;
  BuildContext mcontext;
  bool _passVisible= false;
  var pass1Holder = TextEditingController();
  var pass2Holder = TextEditingController();
  var mobHolder = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
     _passVisible = false;
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
  Widget build(BuildContext context) {
    mcontext = context;
    return Scaffold(
      backgroundColor: Colors.white,
//      appBar: AppBar(
//        title: Container(
//          child: Row(
//            children: [
//            //  Text("Login",style: TextStyle(fontSize: 20),),
//            ],
//          ),
//        ),
//        automaticallyImplyLeading: false,
//        backgroundColor: Colors.white,
//        elevation: 0.0,
//      ),
      body: SingleChildScrollView(
        child: new SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25,top: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Welcome back!',style:TextStyle(color: Colors.black,fontSize: 18),),
                    Text('Login to continue.',style:TextStyle(color: Colors.grey,fontSize: 18),),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                // child: Image.asset('images/mainimg.png',height: 220,width: 220,),
              ),
              Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          children: [
                           // SizedBox(height: 40.0,),
//                            if(inValid) Text("Invalid details",style: TextStyle(fontSize: 14,color: Colors.red),),
                           // SizedBox(height: 10.0,),
                            Column(
                              children: [
                                Image(image: AssetImage('images/logo.png'),width: 120,),
                                Text('SWARANABINDU',style: TextStyle(fontSize: 25,color: Colors.blue),)
                              ],
                            ),
//                            Container(
//                              margin: EdgeInsets.all(10),
//                              decoration: BoxDecoration(
//                                  borderRadius: BorderRadius.circular(20),
//                                  border: Border.all(width: 0.5),
//                                  boxShadow: [
//                                    BoxShadow(
//                                        blurRadius: 2.0,
//                                        spreadRadius: 0.4,
//                                        offset: Offset(0.01, 0.0)),
//                                  ],
//                                  color: Colors.white),
//                              child:
//                            ),
                            Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(width: 0.2),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Form(
                                  key: _loginForm,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 0,left: 10,right: 10,),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 0),
                                        if(inValid) Text("Invalid details",style: TextStyle(fontSize: 14,color: Colors.red),),
                                        SizedBox(height: 20),
                                        TextFormField(style:TextStyle(fontSize: 18.0),
                                          decoration: InputDecoration(
                                              contentPadding:EdgeInsets.all(12),
                                              border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                                                const Radius.circular(0.0),),
                                          borderSide: new BorderSide(
                                            color: Colors.grey,
                                            width: 1.0,
                                          ),),
                                              labelText: 'Mobile Number',labelStyle: (TextStyle(color: Colors.grey)),
                                            hintText: 'Mobile Number',
                                              prefixIcon:Icon(Icons.phone_android,size: 20,color: Colors.grey,),
                                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),
                                          cursorColor: Colors.grey,keyboardType: TextInputType.number,
                                          validator: (value){
                                            if (value == null || value.isEmpty || value.length!=10) {
                                              return 'Mobile Number is required';
                                            }
                                            return null;
                                          },
                                          onSaved: (value){
                                            username = value;
                                          },
                                        ),
                                        SizedBox(height: 25,),
                                        TextFormField(style:TextStyle(fontSize: 18.0),obscureText:!_passVisible,decoration: InputDecoration(contentPadding:EdgeInsets.fromLTRB(0,12,0,12),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                                          const Radius.circular(0.0),
                                        ),
                                          borderSide: new BorderSide(
                                            color: Colors.grey,
                                            width: 1.0,
                                          ),),labelText: 'Password',labelStyle: (TextStyle(color: Colors.grey)),
                                            hintText: 'Password',prefixIcon:Icon(Icons.lock,size: 20,color: Colors.grey,),
                                            suffixIcon:IconButton(
                                              icon: Icon(
                                                _passVisible?Icons.visibility:Icons.visibility_off,color:Colors.grey,
                                              ),onPressed:() {setState(() {
                                              _passVisible = !_passVisible;
                                            });},
                                            ),focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,

                                          validator: (value){
                                            if (value == null || value.isEmpty) {
                                              return 'Password is required';
                                            }
                                            return null;
                                          },
                                          onSaved: (value){
                                            password = value;
                                          },
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('',style: TextStyle(color: Colors.grey,fontSize: 16),),
                                            GestureDetector(
                                                onTap:(){
                                                   otpDialog();
                                                },
                                                child: Text('Forgot Password?',style: TextStyle(color: Colors.grey,fontSize: 16),)),
                                          ],
                                        ),
                                        SizedBox(height: 25,),
                                        Container(
                                          width: double.infinity,
                                          child: RaisedButton(
                                            onPressed: (){
                                              if(_loginForm.currentState.validate()){
                                                _loginForm.currentState.save();
                                                _login(username,password);
                                              }
                                            },
                                            color: Colors.blue,
                                            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                            child: (Text('Login',style: TextStyle(fontSize: 20.0,color: Colors.white))),
                                          ),
                                        ),
                                        SizedBox(height: 20,),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              ),
                             // shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(25),bottomRight: Radius.circular(25))),
                          ],
                        )
                      ],
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }


  _login(name,pass){
    _showLoading();
    String a  =name;
    String b  =pass;
    var body =
    {
      'username': a,
      'password': b
    };
    UserLogin(body).then((value){
        Navigator.pop(context);
      var response = jsonDecode(value);
      if(response['status'] == 422){
        setState(() {
          inValid = true;
        });
      }
      if(response['status']==200){
        setState(() {
          inValid = false;
          var data = response['data'];
          var talukData = response['talukData'];
          var distData = response['distData'];
          String email = data['email'];
          setData("USERMail", email).then((value){
            setData("USERData", jsonEncode(data)).then((value) {
              setData("TalukOffData", jsonEncode(talukData)).then((value){
                setData("District", jsonEncode(distData)).then((value){
                  setData("selDist", data['district']).then((value){
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                        HomePage2()), (Route<dynamic> route) => false);
                  });
                });
              });
            });
          });
        });}

    });
  }
  Future<String> UserLogin(body) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(API_URL+'Athentication'));
    request.headers.set('Content-type', 'application/json');
    request.add(utf8.encode(json.encode(body)));
    HttpClientResponse response = await request.close();
    httpClient.close();
    if(response.statusCode==200) {
      String reply = await response.transform(utf8.decoder).join();
      return reply;
    }
  }

  otpDialog(){
    final _loginForm2 = GlobalKey<FormState>();
    String valMob;
    return showDialog<void>(
      context:context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return Center(
          child: Row(
            children: [
              Expanded(
                child: Form(
                  key: _loginForm2,
                  child: Container(
                    height: 300,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Forgot Password?',style: TextStyle(color: Colors.blue,fontSize: 25),),
                              SizedBox(height: 25),
                              Text('Enter your mobile number, You will receive OTP.',style: TextStyle(color: Colors.grey,fontSize: 16),),
                              SizedBox(height: 10),
                              TextFormField(controller:mobHolder,style:TextStyle(fontSize: 18.0),decoration: InputDecoration(contentPadding:EdgeInsets.all(12),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                            const Radius.circular(0.0),
                          ),
                            borderSide: new BorderSide(
                              color: Colors.grey,
                              width: 1.0,
                            ),),labelText: 'Mobile Number',labelStyle: (TextStyle(color: Colors.grey)),
                              hintText: 'Mobile Number',prefixIcon:Icon(Icons.phone_android,size: 20,color: Colors.grey,),focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,keyboardType: TextInputType.number,
                            validator: (value){
                              if (value == null || value.isEmpty || value.length!=10) {
                                return 'Mobile Number is required';
                              }
                              return null;
                            },
                            onSaved: (value){
                              valMob = value;
                            },
                          ),
                              SizedBox(height: 25),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    //width: double.infinity,
                                    child: RaisedButton(
                                      onPressed: (){
                                    if(_loginForm2.currentState.validate()){
                                      _loginForm2.currentState.save();
                                      _getOtp(valMob);
                                      }
                                      },
                                      color: Colors.blue,
                                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                      child: (Text('Submit',style: TextStyle(fontSize: 20.0,color: Colors.white))),
                                    ),
                                  ),
                                  Container(
                                    //width: double.infinity,
                                    child: RaisedButton(
                                      onPressed: (){
                                        Navigator.pop(context);
                                     },
                                      color: Colors.grey,
                                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                      child: (Text('Cancel',style: TextStyle(fontSize: 20.0,color: Colors.white))),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    ).then((value) {

    });
  }

  otpCheck(String Otp,String Auth){
    final _loginForm2 = GlobalKey<FormState>();
    String Eotp;
    return showDialog<void>(
        context:context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return Center(
            child: Row(
              children: [
                Expanded(
                  child: Form(
                    key: _loginForm2,
                    child: Container(
                      height: 250,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8,8,8,0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Enter OTP',style: TextStyle(color: Colors.blue,fontSize: 25),),
                                SizedBox(height: 25),
                                TextFormField(controller:mobHolder,style:TextStyle(fontSize: 18.0),decoration: InputDecoration(contentPadding:EdgeInsets.all(12),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                                  const Radius.circular(0.0),
                                ),
                                  borderSide: new BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),),labelText: 'OTP',labelStyle: (TextStyle(color: Colors.grey)),
                                    hintText: 'OTP',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,keyboardType: TextInputType.number,
                                  validator: (value){
                                    if (value == null || value.isEmpty) {
                                      return 'OTP is required';
                                    }
                                    return null;
                                  },
                                  onSaved: (value){
                                    Eotp = value;
                                  },
                                ),
                                SizedBox(height: 25),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      //width: double.infinity,
                                      child: RaisedButton(
                                        onPressed: (){
                                          if(_loginForm2.currentState.validate()){
                                            _loginForm2.currentState.save();
                                            mobHolder.text = "";
                                            if(Eotp == Otp){
                                              Navigator.pop(context);
                                              passwordReset(Auth);
                                            }else{
                                              return  Fluttertoast.showToast(
                                                  msg: "OTP dint't match",gravity: ToastGravity.CENTER,
                                                  toastLength: Toast.LENGTH_LONG);
                                            }
                                          }
                                        },
                                        color: Colors.blue,
                                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                        child: (Text('Submit',style: TextStyle(fontSize: 20.0,color: Colors.white))),
                                      ),
                                    ),
                                    Container(
                                      //width: double.infinity,
                                      child: RaisedButton(
                                        onPressed: (){
                                          mobHolder.text = "";
                                          Navigator.pop(context);
                                        },
                                        color: Colors.grey,
                                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                        child: (Text('Cancel',style: TextStyle(fontSize: 20.0,color: Colors.white))),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
    ).then((value) {

    });
  }
  _getOtp(mob) {
    _showLoading();
    String a  = mob;
    var body =
    {
      'mobile': a,
    };
    userGetPass(body).then((value){
        Navigator.pop(context);
      var response = jsonDecode(value);
      if(response['status'] == 422){
        setState(() {
          mobHolder.text = "";
          Fluttertoast.showToast(
              msg: "Mobile number not exist ",gravity: ToastGravity.CENTER,
              toastLength: Toast.LENGTH_LONG);
        });
      }
      if(response['status']==200){
        setState(() {
          mobHolder.text = "";
          var data = response['data'];
          String Authorization = data['Authorization'].toString();
          String mobile = data['mobile'].toString();
          String otp = data['otp'].toString();
             Navigator.pop(context);
             otpCheck(otp,Authorization);
        });}
    });
  }
  Future<String> userGetPass(body) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(API_URL+'Athentication/verify'));
    request.headers.set('Content-type', 'application/json');
    request.add(utf8.encode(json.encode(body)));
    HttpClientResponse response = await request.close();
    httpClient.close();
    if(response.statusCode==200) {
      String reply = await response.transform(utf8.decoder).join();
      return reply;
    }
  }

  passwordReset(String auth){
    final _loginForme3 = GlobalKey<FormState>();
    String pass1;
    String pass2;
    return showDialog<void>(
        context:context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return Center(
            child: SingleChildScrollView(
              child: Row(
                children: [
                  Expanded(
                    child: Form(
                      key: _loginForme3,
                      child:  Container(
                        margin: const EdgeInsets.fromLTRB(10, 15, 10, 20),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                                      child: Text('Reset Password',style: TextStyle(fontSize: 16)),
                                    ),

                                    SizedBox(height: 8),
                                    TextFormField(style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                                      const Radius.circular(0.0),
                                    ),
                                      borderSide: new BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),),
                                        hintText: 'Enter New Password',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,
                                      validator: (value){
                                        if(value == null || value.isEmpty) {
                                          return 'New Password is required';
                                        }
                                      },
                                      onSaved: (value){
                                        pass1 = value;
                                      }
                                      ,),
                                    SizedBox(height: 10),
                                    TextFormField(style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                                      const Radius.circular(0.0),
                                    ),
                                      borderSide: new BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),),
                                        hintText: 'Re-enter Password',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,
                                      validator: (value){
                                        if(value == null || value.isEmpty) {
                                          return 'Confirmation Password is required';
                                        }
                                      },
                                      onSaved: (value){
                                        pass2 = value;
                                      }
                                      ,),
                                    SizedBox(height: 10),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: RaisedButton(
                                          onPressed: (){
                                            if(_loginForme3.currentState.validate()){
                                              _loginForme3.currentState.save();
                                              if(pass1 == pass2){
                                                Reset(pass2,auth);
                                              }
                                              else{
                                                return Fluttertoast.showToast(
                                                    msg: "Both password din't match",gravity: ToastGravity.CENTER,
                                                    toastLength: Toast.LENGTH_SHORT);
                                              }
                                            }
                                          },
                                          color: Colors.red,
                                          child: Text('SUBMIT',style: TextStyle(fontSize:18,color: Colors.white),),
                                        ),
                                      ),
                                      Container(
                                        child: RaisedButton(
                                          onPressed: (){
                                           Navigator.pop(context);
                                          },
                                          color: Colors.grey[600],
                                          child: Text('CANCEL',style: TextStyle(fontSize:18,color: Colors.white),),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8)
                              ],
                            ),
                          ),
                        ),
                      )
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    ).then((value) {

    });
  }

  void Reset(String password2,String Auth){
    var body = {
      'password' : password2,
    };
    passwordReset2(body,Auth).then((value) {
      var response = jsonDecode(value);
      if(response['status'] == 200){
        Navigator.pop(context);


        Fluttertoast.showToast(
            msg: "Password reset",gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG);


      }
      if(response['status'] == 422){
        Fluttertoast.showToast(
            msg: "Error",gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_LONG);
      }
      setState(() {

      });
    });
  }


  Future<String> passwordReset2(body,String authen) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.putUrl(Uri.parse(API_URL+'Athentication/resetPassword'));
    request.headers.set('Content-type', 'application/json');
    request.headers.set('Authorization', authen);
    request.add(utf8.encode(json.encode(body)));
    HttpClientResponse response = await request.close();
    httpClient.close();
    if(response.statusCode==200) {
      String reply = await response.transform(utf8.decoder).join();
      return reply;
    }
  }


}