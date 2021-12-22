import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sawarnabindudc/Functions/UserData.dart';
import 'package:sawarnabindudc/Functions/config.dart';
import 'package:sawarnabindudc/Styles/textstyle.dart';

class EditProfile extends StatefulWidget{
  String aid,aname,amobile,amail,agender,ataluk,adisrict,apost;

  EditProfile(this.aid, this.aname, this.amobile, this.amail, this.agender,
      this.ataluk, this.adisrict, this.apost);

  @override
  State<StatefulWidget> createState() {
    return EditProfileState(aid,aname,amobile,amail,agender,ataluk,adisrict,apost);
  }
}

class EditProfileState extends State<EditProfile>{
  //constructor
  String aid,aname,amobile,amail,agender,ataluk,adisrict,apost,id;

  EditProfileState(this.aid, this.aname, this.amobile, this.amail, this.agender,
      this.ataluk, this.adisrict, this.apost);

  final _loginForm = GlobalKey<FormState>();
  final _passForm = GlobalKey<FormState>();
  var mobHolder = TextEditingController();
  var nameHolder = TextEditingController();
  var lastnameHolder = TextEditingController();
  var pass1Holder = TextEditingController();
  var pass2Holder = TextEditingController();
  String EPrevMob,EMob,EName,ELName,pass1,pass2;
  bool load = false;

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
      getData("USERData").then((value) {
        setState(() {
          if(value!=null){
            var udata = jsonDecode(value);
            id = udata['id'];

            getStock(id).then((value){
              load = true;
              var response = jsonDecode(value);
              if(response['status'] == 200) {
                var data = response['data'];
                var profile = data['profile'];
                String name = profile['name'];
                String lname = profile['lastName'];
                EPrevMob = profile['mobile'];
                nameHolder.text = name;
                lastnameHolder.text = lname;
                mobHolder.text = EPrevMob;
              }

            });
            setState(() {

            });
          }
        });

      });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Edit Profile',style: TextStyle(color:Colors.blue)),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: getStock(id),
          builder: (context,snapshot){
            if(snapshot.hasData){
              var responce = jsonDecode(snapshot.data);
              if(responce['status'] == 200){
                var data = responce['data'];
                var profile = data['profile'];
                String name = profile['name'];
                String lname = profile['lastName'];
                EPrevMob = profile['mobile'];
                nameHolder.text = name;
                lastnameHolder.text = lname;
                mobHolder.text = EPrevMob;
                return  Container(
                  color: mainStyle.bgColor,
                  height: MediaQuery.of(context).size.height,
                  child: Wrap(
                    children: [
                      load ? Column(
                        children: [
                          Container(
                            color: Colors.white,
                            margin: const EdgeInsets.fromLTRB(10, 15, 10, 20),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8,12,8,15),
                              child: Form(
                                key: _loginForm,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    SizedBox(height: 10),
                                    TextFormField(controller: nameHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                                      const Radius.circular(0.0),
                                    ),
                                      borderSide: new BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),),
                                        hintText: 'Name',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,
                                      validator: (value){
                                        if(value == null || value.isEmpty) {
                                          return 'Name is required';
                                        }
                                      },
                                      onSaved: (value){
                                        EName = value;
                                      }
                                      ,),
                                    SizedBox(height: 10),
                                    TextFormField(controller: lastnameHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                                      const Radius.circular(0.0),
                                    ),
                                      borderSide: new BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),),
                                        hintText: 'Last Name',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,
                                      validator: (value){
                                        if(value == null || value.isEmpty) {
                                          return 'Last Name is required';
                                        }
                                      },
                                      onSaved: (value){
                                        ELName = value;
                                      }
                                      ,),
                                    SizedBox(height: 10),
                                    TextFormField(controller: mobHolder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
                                      const Radius.circular(0.0),
                                    ),
                                      borderSide: new BorderSide(
                                        color: Colors.black,
                                        width: 1.0,
                                      ),),
                                        hintText: 'Mobile Number',focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey))),cursorColor: Colors.grey,textCapitalization: TextCapitalization.sentences,keyboardType: TextInputType.number,
                                      validator: (value){
                                        if(value == null || value.isEmpty) {
                                          return 'Mobile Number is required';
                                        }
                                      },
                                      onSaved: (value){
                                        EMob = value;
                                      }
                                      ,),
                                    SizedBox(height: 25),
                                    Container(
                                      height: 40,
                                      width: 150,
                                      child: RaisedButton(
                                        onPressed: (){
                                          if(_loginForm.currentState.validate()){
                                            _loginForm.currentState.save();
                                            submitAdd();
                                          }
                                        },
                                        color: Colors.orange,
                                        child: Text('SAVE',style: TextStyle(fontSize:18,color: Colors.white),),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            margin: const EdgeInsets.fromLTRB(10, 15, 10, 20),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Form(
                                key: _passForm,
                                child: Column(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                                          child: Text('Change Password',style: mainStyle.text14light),
                                        ),
                                        SizedBox(height: 8),
                                        TextFormField(controller: pass1Holder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
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
                                        TextFormField(controller: pass2Holder,style:TextStyle(fontSize: 16.0),decoration: InputDecoration(contentPadding: EdgeInsets.all(10),border: OutlineInputBorder(borderRadius: const BorderRadius.all(
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
                                    Container(
                                      height: 40,
                                      width: 150,
                                      child: RaisedButton(
                                        onPressed: (){
                                          if(_passForm.currentState.validate()){
                                            _passForm.currentState.save();
                                            if(pass1 == pass2){
                                              Reset();
                                            }
                                            else{
                                              return Fluttertoast.showToast(
                                                  msg: "Both password din't match",gravity: ToastGravity.CENTER,
                                                  toastLength: Toast.LENGTH_SHORT);
                                            }
                                          }
                                        },
                                        color: Colors.orange,
                                        child: Text('SUBMIT',style: TextStyle(fontSize:18,color: Colors.white),),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ):SpinKitThreeBounce(
                        color: Colors.amber,
                        size: 20,
                      ),
                    ],
                  ),
                );
              }
            }
            return SpinKitThreeBounce(
              color: Colors.amber,
              size: 20,
            );
          },
        )
      ),
    );
  }




  void submitAdd(){
    var body = {
      'prevMobile' : EPrevMob,
      'fname' : EName,
      'lname' : ELName,
      'mobile' : EMob,
    };
    profileUpdate(body).then((value) {
      var response = jsonDecode(value);
      if(response['status'] == 200){
        getStock(id).then((value) {
          var response = jsonDecode(value);
          if(response['status'] == 200) {
            var data = response['data'];
            var profile = data['profile'];
            setData("USERData", jsonEncode(profile)).then((value) {
            });
          }
        });
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: "Profile Updated",gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_SHORT);
      }
      if(response['status'] == 422){
        Fluttertoast.showToast(
            msg: "Error in updating the profile",gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_SHORT);
      }
      setState(() {
      });
    });
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
      print('dataCheckkkk $reply');
      return reply;
    }
  }

  void Reset(){
    var body = {
    //  'employeeId' : cid,
      'password' : pass2,
    };
    print('Emp reset pass $body');
    passwordReset2(body).then((value) {
      var response = jsonDecode(value);
      if(response['status'] == 200){
        pass1Holder.text = '';
        pass2Holder.text = '';

        Fluttertoast.showToast(
            msg: "Password has been reset successfully!",gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_SHORT);
        //  Navigator.pop(context);

      }
      if(response['status'] == 422){
        Fluttertoast.showToast(
            msg: "Error",gravity: ToastGravity.CENTER,
            toastLength: Toast.LENGTH_SHORT);
      }
      setState(() {

      });
    });
  }

  Future<String> profileUpdate(body) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.putUrl(Uri.parse(API_URL+'Athentication/user/'+id));
    request.headers.set('Content-type', 'application/json');
    request.add(utf8.encode(json.encode(body)));
    HttpClientResponse response = await request.close();
    httpClient.close();
    if(response.statusCode==200) {
      String reply = await response.transform(utf8.decoder).join();
      print('empUpdateeeee $reply');
      return reply;
    }
  }

  Future<String> passwordReset2(body) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.putUrl(Uri.parse(API_URL+'Athentication/resetPassword'));
    request.headers.set('Content-type', 'application/json');
    request.headers.set('Authorization', id);
    request.add(utf8.encode(json.encode(body)));
    HttpClientResponse response = await request.close();
    httpClient.close();
    if(response.statusCode==200) {
      String reply = await response.transform(utf8.decoder).join();
      return reply;
    }
  }


}