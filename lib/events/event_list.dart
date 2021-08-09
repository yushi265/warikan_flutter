import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../payments/payment_list.dart';
import '../../models.dart';
import '../../constants.dart' as Constants;

class EventList extends StatefulWidget {
  EventList({Key? key}) : super(key: key);

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {

  List<Event> _eventList = [];

  @override
  void initState() {
    super.initState();
    getEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('イベントリスト'),
        actions: <Widget>[
          Container(
              margin: EdgeInsets.only(right: 15),
              child: IconButton(
                icon: Icon(Icons.add),
                tooltip: '新しいイベントを追加する',
                onPressed: () {
                  _openAddEventModal();
                },
              )),
        ],
      ),
      body: ListView.builder(
        itemCount: _eventList.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(_eventList[index].title),
              subtitle: Text(_eventList[index].createdAt),
              onTap: () => {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PaymentList(_eventList[index].id)),
                )
              },
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
  Future getEvents() async {
    var url = Uri.http(Constants.HOST, '/api/events/index');

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      setState(() {
        _eventList = [];
        jsonResponse.forEach((e) {
          _eventList.add(Event(e['id'], e['title'], e['created_at']));
        });
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  // イベントを追加する
  Future storeEvent(String title) async {
    var url = Uri.http(Constants.HOST, '/api/events/store', {
      'title': title
    });

    String body = convert.jsonEncode({'title': title});

    var response = await http.post(url, headers: Constants.HEADERS, body: body);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      setState(() {
        _eventList = [];
        jsonResponse.forEach((e) {
          _eventList.add(Event(e['id'], e['title'], e['created_at']));
        });
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  //  イベント追加モーダル
  void _openAddEventModal() {
    String _title = '';

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          margin: EdgeInsets.only(top: 64),
          padding: EdgeInsets.all(64),
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
            margin: EdgeInsets.only(top: 64),
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Text('イベントを追加する', style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                ),
                Padding(padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                            labelText: "タイトル",
                        ),
                        onChanged: (value) {
                          setState(() {
                            _title = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: Container(
                    padding: EdgeInsets.only(top: 30),
                    width: double.infinity,
                    child: ElevatedButton(
                      child: Text(
                        '追加',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.black,
                        elevation: 16,
                      ),
                      onPressed: () {
                        storeEvent(_title);
                        getEvents();
                        Navigator.pop(context);
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
