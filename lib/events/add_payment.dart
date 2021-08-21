import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../../models.dart';
import '../../constants.dart' as Constants;

class AddPayment extends StatefulWidget {
  AddPayment(this._event);
  final Event _event;

  @override
  _AddPaymentState createState() => _AddPaymentState(_event);
}

class _AddPaymentState extends State<AddPayment> {
  _AddPaymentState(this._event);
  final Event _event;

  List<DropdownMenuItem<int>> _userList = [];
  int _selectUser = 0;

  @override
  void initState() {
    super.initState();
    getUsers();
    _selectUser = _userList[0].value!;
  }

  void getUsers() {
    _userList
      ..add(DropdownMenuItem(
        child: Text('ゆうき'),
        value: 1,
      ))
      ..add(DropdownMenuItem(
        child: Text('あすか'),
        value: 2,
      ));
  }

  // 支払いを追加する
  Future storePayment(int eventId, String? title, String? price, String? memo) async {
    var url = Uri.http(Constants.HOST, '/api/events/$eventId/payments/store');

    String body = convert.jsonEncode({
      'event_id': eventId,
      'payer_id': _selectUser,
      'title': title,
      'price': price,
      'memo': memo
    });

    var response = await http.post(url, headers: Constants.HEADERS, body: body);
    if (response.statusCode == 200) {
    } else if (response.statusCode == 422) {
      final snackBar = SnackBar(
        content: Text('エラーが発生しました'),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  String? title;
  String? price;
  String? memo;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('支払いを追加する'),
      ),
      body: Container(
          margin: EdgeInsets.only(top: 30),
          padding: EdgeInsets.all(30),
          child: Column(
              children: [
                Padding(padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('イベント',
                        style: TextStyle(
                        fontSize: 20,
                  ),),
                      Text(_event.title,
                        style: TextStyle(
                        fontSize: 20,))
                    ],
                  ),
                ),
                Padding(padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('はらった人',
                        style: TextStyle(
                        fontSize: 20,)),
                      DropdownButton<int>(
                        items: _userList,
                        value: _selectUser,
                        onChanged: (value) => {
                          setState(() {
                            _selectUser = value!;
                          }),
                        },
                      ),
                    ],
                  ),
                ),
                Padding(padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    children: [
                      TextField(
                        style: new TextStyle(
                          fontSize: 20.0,
                        ),
                        decoration: InputDecoration(
                          labelText: "タイトル",
                        ),
                        onChanged: (value) => {
                          setState(() {
                            title = value;
                          }),
                        },
                      ),
                    ],
                  ),
                ),
                Padding(padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    children: [
                      TextField(
                        style: new TextStyle(
                          fontSize: 20.0,
                        ),
                        decoration: InputDecoration(
                          labelText: "金額",
                        ),
                        onChanged: (value) => {
                          setState(() {
                            price = value;
                          }),
                        },
                      ),
                    ],
                  ),
                ),
                Padding(padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    children: [
                      TextField(
                        style: new TextStyle(
                          fontSize: 20.0,
                        ),
                        decoration: InputDecoration(
                          labelText: "メモ",
                        ),
                        onChanged: (value) => {
                          setState(() {
                            memo = value;
                          }),
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Container(
                      padding: EdgeInsets.only(top: 30),
                      width: double.infinity,
                      child: ElevatedButton(
                          child: Text('追加',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            onPrimary: Colors.black,
                            elevation: 16,
                          ),
                        onPressed: () async {
                          var result = await storePayment(_event.id, title, price, memo);
                          Navigator.of(context).pop(_event.id);
                        },
                    ),),
                ),
              ]
          ),
        )
    );
  }
}
