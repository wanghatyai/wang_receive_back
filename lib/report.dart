import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluttertoast/fluttertoast.dart';
<<<<<<< HEAD
import 'package:wangreceiveback/pr_model.dart';
=======
import 'package:POPR/pr_model.dart';
>>>>>>> init wang get back

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {

  ScrollController _scrollController = new ScrollController();

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  //Product product;
  List <Pr>productAll = [];
  bool isLoading = true;
  int perPage = 30;
  String act = "pr_product";

  getPrProduct() async{

    final res = await http.get('https://wangpharma.com/API/receiveProductBack.php?PerPage=$perPage&act=$act');
    //print('https://wangpharma.com/API/receiveProductBack.php?PerPage=$perPage&act=$act');

    if(res.statusCode == 200){

      setState(() {
        isLoading = false;

        var jsonData = json.decode(res.body);

        jsonData.forEach((products) => productAll.add(Pr.fromJson(products)));
        perPage = perPage + 30;

        print(productAll);
        print(perPage);

        return productAll;

      });


    }else{
      throw Exception('Failed load Json');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrProduct();

    _scrollController.addListener((){
      //print(_scrollController.position.pixels);
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        getPrProduct();
      }
    });
  }

  Future<Null> _refreshList() async {
    //refreshKey.currentState?.show(atTop: false);
    refreshKey.currentState?.show(atTop: false);
    //refreshKey.currentState?.initState();
    await Future.delayed(Duration(seconds: 2),(){
      setState(() {
        getPrProduct();
      });
    });

    return null;
  }

  showDialogDelConfirm(id) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("แจ้งเตือน"),
          content: Text("ยืนยันลบรายการ"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              color: Colors.red,
              child: Text("ยกเลิก",style: TextStyle(color: Colors.white, fontSize: 18),),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(
              width: 100,
            ),
            FlatButton(
              color: Colors.green,
              child: Text("ตกลง",style: TextStyle(color: Colors.white, fontSize: 18),),
              onPressed: () {
                removeCountStockHis(id);
                //Navigator.of(context).pop();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  removeCountStockHis(cthID) async{

    print(cthID);

    if(cthID != null) {

      var uri = Uri.parse("https://wangpharma.com/API/receiveProductBack.php");
      var request = http.MultipartRequest("POST", uri);

      /*SharedPreferences prefs = await SharedPreferences.getInstance();
      empCodeStock = prefs.getString("empCodeStock");*/

      //request.fields['ct_code'] = ;
      request.fields['act'] = 'Del';
      request.fields['pr_del_id'] = cthID;
      //request.fields['ctl_stock'] = productVal.productStockQ;
      //request.fields['emp_pickingorder'] = empCodeStock;

      var response = await request.send();

      if (response.statusCode == 200) {

        var respStr = await response.stream.bytesToString();

        print("add OK");
        print(respStr);

        showToast('ลบรายการ');
        setState(() {
          getPrProduct();
        });

        //Navigator.pop(context);

        //Navigator.of(context).pushNamedAndRemoveUntil('/Home', (Route<dynamic> route) => false);

        /*Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home())).then((r){
        });*/

        //Navigator.pop(context);

      } else {
        print("add Error");
      }

      //showToastAddFast();
      //Navigator.of(context).pushNamedAndRemoveUntil('/Home', (Route<dynamic> route) => false);
      //Navigator.pop(context);

    }else{
      _showAlert();
    }

  }

  _showAlert() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('แจ้งเตือน'),
          content: Text('คุณกรอกรายละเอียดไม่ครบถ้วน'),
        );
      },
    );
  }

  showToast(textVal){
    Fluttertoast.showToast(
        msg: textVal,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ? CircularProgressIndicator()
          :RefreshIndicator(
        key: refreshKey,
        child: ListView.separated(
          //physics: AlwaysScrollableScrollPhysics(),
          separatorBuilder: (BuildContext context, int index) => Divider(),
          controller: _scrollController,
          itemBuilder: (context, int index){
            return ListTile(
              contentPadding: EdgeInsets.fromLTRB(10, 1, 10, 1),
              onTap: (){
                /*Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProductDetailPage(productsVal: productAll[index])));*/
              },
              leading: Image.network('https://www.wangpharma.com/cms/product/${productAll[index].prProductPic}', fit: BoxFit.cover, width: 70, height: 70,),
              title: Text('${productAll[index].prProductName}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('${productAll[index].prProductCode}'),
                      Text('พนง.รับ ${productAll[index].prEmpScan}', style: TextStyle(color: Colors.green),),
                    ],
                  ),
                  //Text('นับล่าสุด ${productAll[index].countStockNumCount} : ${productAll[index].countStockProdUnit1}', style: TextStyle(color: Colors.red),),
                  Text('รับคืน ${productAll[index].prDateScan}', style: TextStyle(color: Colors.blueGrey),),
                  //productAll[index].recevicProductUnitNew == null
                  //? Text('หน่วยย่อย : ${productAll[index].recevicTCqtySub} ${productAll[index].recevicProductUnit}', style: TextStyle(color: Colors.lightBlue))
                  //: Text('หน่วยย่อย : ${productAll[index].recevicTCqtySub} ${productAll[index].recevicProductUnitNew}', style: TextStyle(color: Colors.lightBlue)),
                ],
              ),
              trailing: IconButton(
                  icon: Icon(Icons.list, size: 40,),
                  onPressed: (){
                    showDialogDelConfirm(productAll[index].prId);
                    //addToOrderFast(productAll[index]);
                    /*Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReportDetailPage(productsVal: productAll[index])));*/
                  }
              ),
            );
          },
          itemCount: productAll != null ? productAll.length : 0,
        ),
        onRefresh: _refreshList,
      ),
    );
  }
}
