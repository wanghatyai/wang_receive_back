import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

<<<<<<< HEAD
import 'package:wangreceiveback/home.dart';
=======
import 'package:POPR/home.dart';
>>>>>>> init wang get back

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ระบบรับสินค้าคืน',
      routes: <String,WidgetBuilder>{
        '/Home': (BuildContext context) => Home(),
      },
      theme: ThemeData(

        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'ระบบรับสินค้าคืน'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController ctrlUser = TextEditingController();
  TextEditingController ctrlPass = TextEditingController();

  var username;

  var userAlert = 'Please enter the Username / กรุณากรอกชื่อบัญชีผู้';
  var passAlert = 'Please enter the Password / กรุณากรอกรหัสผ่านบัญชีผู้ใช้';

  var userInvalid = false;
  var passInvalid = false;

  void _showAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('แจ้งเตือน'),
          content: Text('ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง'),
        );
      },
    );
  }

  _checkPrefer() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("empCodeStock");
    });

    if(username != null){
      Navigator.pushReplacementNamed(context, '/Home');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkPrefer();
  }

  _doLogin() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await http.post(
        'https://wangpharma.com/API/receiveProduct.php',
        body: {'username': ctrlUser.text, 'password': ctrlPass.text, 'act': 'Login'});

    if(ctrlUser.text != '' && ctrlPass.text != '' && response.statusCode == 200){

      var jsonResponse = json.decode(response.body);

      //print(jsonResponse);

      if(!jsonResponse.isEmpty){

        prefs.setString("empCodeStock", ctrlUser.text);

        Navigator.pushReplacementNamed(context, '/Home');
      }else{
        _showAlert();
      }

    }else{
      _showAlert();
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'ระบบรับสินค้าคืน',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            Padding (
              padding: const EdgeInsets.all(20),
              child: TextFormField (
                controller: ctrlUser,
                style: TextStyle (
                  fontSize: 18,
                  color: Colors.black,
                ),
                decoration: InputDecoration (
                    prefixIcon: Icon (
                      Icons.account_box,
                      size: 30,
                    ),
                    labelText: 'Username / ชื่อบัญชีผู้ใช้',
                    errorText: userInvalid ? userAlert : null,
                    //'Please enter the Username / กรุณากรอกชื่อบัญชีผู้',
                    labelStyle: TextStyle (
                      color: Colors.black,
                      fontSize: (15),
                    )
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding (
              padding: const EdgeInsets.all(20),
              child: Stack (
                alignment: AlignmentDirectional.centerEnd,
                children: <Widget>[
                  TextField (
                    controller: ctrlPass,
                    style: TextStyle (
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    decoration: InputDecoration (
                      prefixIcon: Icon (
                        Icons.vpn_lock,
                        size: 30,
                      ),
                      labelText: 'Password / รหัสผ่านบัญชีผู้ใช้',
                      errorText: passInvalid ? passAlert : null,
                      labelStyle: TextStyle (
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            Padding (
              padding: const EdgeInsets.all(20),
              child: SizedBox (
                width: double.infinity,
                height: 56,
                child: RaisedButton (
                  color: Colors.black,
                  onPressed: _doLogin,
                  child: Text (
                    'เข้าสู่ระบบ',
                    style: TextStyle (
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
