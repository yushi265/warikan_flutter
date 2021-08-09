import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../../models.dart';

class PaymentList extends StatefulWidget {
  PaymentList(this._eventId);
  final int _eventId;

  @override
  _PaymentListState createState() => _PaymentListState(_eventId);
}

class _PaymentListState extends State<PaymentList> {
  _PaymentListState(this._eventId);
  final int _eventId;

  List _paymentList = [];

  @override
  void initState() {
    super.initState();
    getPayments(_eventId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('支払いリスト'),
      ),
      body: ListView.builder(
        itemCount: _paymentList.length,
        itemBuilder: (context, index) {
          return Card(
              child: ListTile(
                title: Text(_paymentList[index].title),
                onTap: () => {},
                onLongPress: () => {},
                trailing: Icon(Icons.more_vert),
                dense: true,
              ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-payment');
        },
        tooltip: '支払いを追加する',
        child: Icon(Icons.add),
      ),
    );
  }

  // すべてのイベントを取得する
  Future getPayments(int id) async {
    var url = Uri.http('localhost', '/api/events/$id/payments/');

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      setState(() {
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
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }
}