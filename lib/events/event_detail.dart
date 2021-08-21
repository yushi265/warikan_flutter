import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:warikan/events/add_payment.dart';
import 'package:warikan/payments/payment_list.dart';
import '../../models.dart';
import '../../constants.dart' as Constants;
import '../footer.dart';

class EventDetail extends StatefulWidget {
  EventDetail(this._event);
  final Event _event;

  @override
  _AddEventDetail createState() => _AddEventDetail(_event);
}

class _AddEventDetail extends State<EventDetail> {
  _AddEventDetail(this._event);
  final Event _event;

  String _eventTotal = '';
  Map _user1 = {
    'total': '',
    'difference': '',
    'sign': true,
  };
  Map _user2 = {
    'total': '',
    'difference': '',
    'sign': true,
  };
  bool _settlement = false;


  // すべてのイベントを取得する
  Future getEventDetail(int id) async {
    var url = Uri.http(Constants.HOST, '/api/events/$id/show');

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      setState(() {
        _eventTotal = jsonResponse['event']['total'];
        _user1 = {
          'total': jsonResponse['users']['1']['total'],
          'difference': jsonResponse['users']['1']['difference'],
          'sign': jsonResponse['users']['1']['sign'],
        };
        _user2 = {
          'total': jsonResponse['users']['2']['total'],
          'difference': jsonResponse['users']['2']['difference'],
          'sign': jsonResponse['users']['2']['sign'],
        };
        _settlement = jsonResponse['settlement'] == 0 ? false : true;
      });
    } else {
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

  @override
  void initState() {
    super.initState();
    getEventDetail(_event.id);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text(_event.title),
        ),
        body: Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.all(30),
          child: Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      Text('つかったおかね',
                        style: TextStyle(
                          fontSize: 20,
                        ),),
                      Text(_eventTotal,
                          style: TextStyle(
                            fontSize: 30,)),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 60),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('ゆうき',
                                style: TextStyle(
                                  fontSize: 20,
                                ),),
                              Text(_user1['total'],
                                  style: TextStyle(
                                    fontSize: 20,)),
                          ],
                          ),

                          Text(
                              _user1['sign']
                                  ? _user1['difference'] + 'もらうよ'
                                  : _user1['difference'] + 'はらうよ',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: _user1['sign'] ? Colors.blue : Colors.red))
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 30),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('あすか',
                                style: TextStyle(
                                  fontSize: 20,
                                ),),
                              Text(_user2['total'],
                                  style: TextStyle(
                                    fontSize: 20,)),
                        ],),

                            Text(_user2['sign']
                                ? _user2['difference'] + 'もらうよ'
                                : _user2['difference'] + 'はらうよ',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: _user2['sign'] ? Colors.blue : Colors.red))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 60),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          child: Text(
                            '支払いの詳細を見る',
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PaymentList(_event)),
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 30),
                        width: double.infinity,
                        child: ElevatedButton(
                          child: Text(
                            _settlement ? '支払い完了' : '支払う',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            onPrimary: Colors.black,
                            elevation: 16,
                          ),
                          onPressed: () async {
                            var response = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PaymentList(_event)),
                            );
                            getEventDetail(_event.id);
                          },
                        ),
                      ),
                    ],
                ),
                ),

    ]),),
      bottomNavigationBar: Footer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPayment(_event)),
          );
          getEventDetail(_event.id);
        },
        tooltip: '支払いを追加する',
        child: Icon(Icons.add),
      ),
    );
  }
}