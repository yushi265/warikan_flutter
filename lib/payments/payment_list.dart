import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:warikan/events/add_payment.dart';
import '../../models.dart';
import '../../constants.dart' as Constants;
import '../footer.dart';

class PaymentList extends StatefulWidget {
  PaymentList(this._event);
  final Event _event;

  @override
  _PaymentListState createState() => _PaymentListState(_event);
}

class _PaymentListState extends State<PaymentList> {
  _PaymentListState(this._event);
  final Event _event;

  List _paymentList = [];

  @override
  void initState() {
    super.initState();
    getPayments(_event.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_event.title),
      ),
      body: ListView.builder(
        itemCount: _paymentList.length,
        itemBuilder: (context, index) {
          return Card(
              child: ListTile(
                leading: Container(
                  width: 70,
                  child: Text(_paymentList[index].payerId == 1 ? 'ゆうき' : 'あすか'),
                ),
                title: Text(_paymentList[index].title,
                  style: TextStyle(
                    fontSize: 16,
                  ),),
                subtitle: Text('¥' + _paymentList[index].price.toString()),
                onTap: () => {},
                onLongPress: () => {
                  _openAddPaymentModal(_paymentList[index])
                },
                dense: false,
              ));
        },
      ),
      bottomNavigationBar: Footer(),
    );
  }

  // すべてのイベントを取得する
  Future getPayments(int id) async {
    var url = Uri.http('localhost', '/api/events/$id/payments');

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      setState(() {
        _paymentList = [];
        jsonResponse.forEach((e) {
          _paymentList.add(Payment(
              e['id'],
              e['payer_id'],
              e['event_id'],
              e['title'],
              e['price'],
              e['memo']
          ));
        });
      });
    } else if (response.statusCode == 404) {
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

  // 支払いを更新する
  Future updatePayment(int paymentId, int eventId, int payerId, String title, String price, String memo) async {
    var url = Uri.http(Constants.HOST, '/api/events/$eventId/payments/$paymentId/update');

    String body = convert.jsonEncode({
      'event_id': eventId,
      'payer_id': payerId,
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

  // 支払いを削除する
  Future destroyPayment(int eventId, int paymentId) async {
    var url = Uri.http(Constants.HOST, '/api/events/$eventId/payments/$paymentId/destroy');

    var response = await http.post(url, headers: Constants.HEADERS);
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

  void _openAddPaymentModal(Payment payment) {
    int _selectedUser = payment.payerId;
    String _title = payment.title;
    String _price = payment.price.toString();
    String _memo = payment.memo;

    List<DropdownMenuItem<int>> _userList = [
      DropdownMenuItem(
        child: Text('ゆうき'),
        value: 1,
      ),
      DropdownMenuItem(
        child: Text('あすか'),
        value: 2,
      )];

    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Container(
              margin: EdgeInsets.only(top: 100),
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                //モーダル自体の色
                color: Colors.white,
                //角丸にする
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                    children: [
                      Padding(padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Text('支払いを編集する',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Column(
                          children: [
                            Padding(padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('はらった人'),
                                  DropdownButton<int>(
                                    items: _userList,
                                    value: _selectedUser,
                                    onChanged: (value) => {
                                      setState(() {
                                        _selectedUser = value!;
                                      }),
                                    },
                                  ),
                                ],
                              ),
                            ),
                            TextField(
                              style: new TextStyle(
                                fontSize: 20.0,
                              ),
                              controller: TextEditingController(text: payment.title),
                              decoration: InputDecoration(
                                labelText: "タイトル",
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _title = value;
                                });
                              },
                            ),
                            TextField(
                              style: new TextStyle(
                                fontSize: 20.0,
                              ),
                              controller: TextEditingController(text: payment.price.toString()),
                              decoration: InputDecoration(
                                labelText: "金額",
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _price = value;
                                });
                              },
                            ),
                            TextField(
                              style: new TextStyle(
                                fontSize: 20.0,
                              ),
                              controller: TextEditingController(text: payment.memo),
                              decoration: InputDecoration(
                                labelText: "めも",
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _memo = value;
                                });
                              },
                            ),
                          ],
                        ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30.0),
                        child: Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            child: Text(
                              '更新',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              onPrimary: Colors.black,
                              elevation: 16,
                            ),
                            onPressed: () async {
                              var response = await updatePayment(
                                payment.id,
                                payment.eventId,
                                _selectedUser,
                                _title,
                                _price,
                                _memo
                              );
                              getPayments(_event.id);
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              child: Text(
                                '削除',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.redAccent,
                                onPrimary: Colors.black,
                                elevation: 16,
                              ),
                              onPressed: () async {
                                var response = await destroyPayment(
                                    payment.eventId,
                                    payment.id
                                );
                                getPayments(_event.id);
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ),
                    ]
                ),
              )
          );
        }
    );
  }
}