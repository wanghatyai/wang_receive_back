import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

<<<<<<< HEAD
import 'package:wangreceiveback/add_product.dart';
import 'package:wangreceiveback/report.dart';
import 'package:wangreceiveback/user.dart';
=======
import 'package:POPR/add_product.dart';
import 'package:POPR/report.dart';
import 'package:POPR/user.dart';
>>>>>>> init wang get back

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var username;

  int currentIndex = 0;
  List pages = [AddProductPage(), ReportPage(), UserPage()];

  getCodeEmpReceive() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("empCodeStock");
    });
    return username;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCodeEmpReceive();
  }

  @override
  Widget build(BuildContext context) {

    Widget bottomNavBar = BottomNavigationBar(
        backgroundColor: Colors.white,
        fixedColor: Colors.black,
        unselectedItemColor: Colors.blueGrey,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (int index){
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.add_to_photos),
              title: Text('รับสินค้า', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.view_list),
              title: Text('รายการ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.perm_identity),
              title: Text('ผู้ใช้', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
          ),
        ]
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("ระบบรับสินค้าคืน-$username"),
        actions: <Widget>[
          /*IconButton(
            icon: Icon(Icons.cast_connected, size: 40, color: Colors.white,),
            color: Colors.black,
            onPressed: (){
              _launchURL();
            },
          ),*/
        ],
      ),
      body: pages[currentIndex],
      bottomNavigationBar: bottomNavBar,
    );
  }
}
