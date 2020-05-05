import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductDetailPage extends StatefulWidget {

  var productsVal;
  ProductDetailPage({Key key, this.productsVal}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {

  TextEditingController valAmount = TextEditingController();
  TextEditingController valComment = TextEditingController();
  List units = [];
  String _currentUnit;
  var unitStatus;

  var empCodeStock;


  _onDropDownItemSelected(newValueSelected, newIndexSelected){
    setState(() {
      _currentUnit = newValueSelected;
      unitStatus = newIndexSelected;
      //print('select--${units}');
    });
  }

  _updateCountProduct() async{

    if(valAmount.text != '') {

      var uri = Uri.parse("https://wangpharma.com/API/receiveProductBack.php");
      var request = http.MultipartRequest("POST", uri);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      empCodeStock = prefs.getString("empCodeStock");


      //request.fields['ct_code'] = ;
      request.fields['act'] = 'AddNumStock';
      request.fields['pcode'] = widget.productsVal.productCode;
      request.fields['nproduct'] = widget.productsVal.productName;
      request.fields['stock'] = widget.productsVal.productStock;
      request.fields['Qty'] = valAmount.text;
      request.fields['Unit'] = _currentUnit;
      request.fields['priceLast'] = widget.productsVal.productPriceLast;
      request.fields['company'] = widget.productsVal.productCompany;


      var response = await request.send();

      if (response.statusCode == 200) {

        var respStr = await response.stream.bytesToString();

        print("add OK");
        print(respStr);

        showToastAddFast();

        /*Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home())).then((r){
        });*/

        Navigator.pop(context);

      } else {
        print("add Error");
      }

    }else{
      _showAlert();
    }
  }

  showToastAddFast(){
    Fluttertoast.showToast(
        msg: "เพิ่มรายการแล้ว",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3
    );
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

  @override
  Widget build(BuildContext context) {

    units = [];

    if(widget.productsVal.productUnit1.toString() != "null"){
      units.add(widget.productsVal.productUnit1.toString());
      //setState(() {
      //_currentUnit = widget.product['unit1'].toString();
      //});
    }
    if(widget.productsVal.productUnit2.toString() != "null"){
      units.add(widget.productsVal.productUnit2.toString());
    }
    if(widget.productsVal.productUnit3.toString() != "null"){
      units.add(widget.productsVal.productUnit3.toString());
    }

    if(_currentUnit == null){
      _currentUnit = widget.productsVal.productUnit1.toString();
    }

    return Scaffold(
      appBar: AppBar(
        //title: Text(widget.product.productName.toString()),
        title: Text("รายละเอียดสินค้า"),
        actions: <Widget>[
          /*IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: (){
                      //Navigator.pushReplacementNamed(context, '/Order');
                    }
                )*/
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Code : ${widget.productsVal.productCode}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text('Name : ${widget.productsVal.productName}', style: TextStyle(fontSize: 16)),
              Container(
                child: Image.network('https://www.wangpharma.com/cms/product/${widget.productsVal.productPic}', fit: BoxFit.cover, width: 350, height: 350,),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Expanded(
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                        controller: valAmount,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "จำนวน",
                          contentPadding: EdgeInsets.all(4),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (val){
                          if(val.isEmpty){
                            return 'กรุณากรอกข้อมูล';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Container(
                    child: Expanded(
                      child: DropdownButton(
                        isExpanded: true,
                        hint: Text("เลือกหน่วยสินค้า",style: TextStyle(fontSize: 18)),
                        items: units.map((dropDownStringItem){
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Container(
                              //color: Colors.white,
                              padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                              child: Text(dropDownStringItem, style: TextStyle(fontSize: 18)),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValueSelected){
                          var tempIndex = units.indexOf(newValueSelected)+1;
                          _onDropDownItemSelected(newValueSelected, tempIndex);
                          print(this._currentUnit);
                          print(tempIndex);

                        },
                        value: _currentUnit,

                      ),

                    ),
                  ),
                ],
              ),
              /*TextField(
                controller: valComment,
                decoration: InputDecoration(
                    labelText: "หมายเหตุ"
                ),
              ),*/
              Padding (
                padding: const EdgeInsets.all(20),
                child: SizedBox (
                  width: double.infinity,
                  height: 56,
                  child: RaisedButton (
                    color: Colors.green,
                    onPressed: _updateCountProduct,
                    child: Text (
                      'ส่งยอด',
                      style: TextStyle (
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

        ),
      ),
    );
  }
}
