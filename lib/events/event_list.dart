import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:warikan/events/event_detail.dart';
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
                title: Text(_eventList[index].title,
                  style: TextStyle(
                  fontSize: 16,
                ),),
                subtitle: Text(_eventList[index].createdAt),
                onTap: () => {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EventDetail(_eventList[index])),
                  )
                },
                onLongPress: () => {
                  _openAddEventModal(_eventList[index])
                },
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

  // イベントを追加する
  Future storeEvent(String? title, [Event? event]) async {
    var url = Uri.http(Constants.HOST,
        event != null
            ? '/api/events/' + event.id.toString() + '/update'
            : '/api/events/store'
    );

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

  // イベントを削除する
  Future destroyEvent(Event event) async {
    var url = Uri.http(Constants.HOST, '/api/events/' + event.id.toString() + '/destroy');

    var response = await http.post(url, headers: Constants.HEADERS);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      setState(() {
        _eventList = [];
        jsonResponse.forEach((e) {
          _eventList.add(Event(e['id'], e['title'], e['created_at']));
        });
      });
    } else if (response.statusCode == 422) {
      var jsonResponse = convert.jsonDecode(response.body);
      final snackBar = SnackBar(
        content: Text(jsonResponse.errors),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );
  }}

  //  支払い編集モーダル
  void _openAddEventModal([Event? event]) {
    String? _title = event?.title;

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          margin: EdgeInsets.only(top: 200),
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
                  child: Text(event != null
                      ? 'イベント名を編集する'
                      : 'イベントを追加する',
                    style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                ),
                Padding(padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Column(
                    children: [
                      TextField(
                        style: new TextStyle(
                          fontSize: 20.0,
                        ),
                        controller: TextEditingController(text: event?.title),
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
                        event != null
                        ? '変更'
                        : '追加',
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
                        if (event != null) {
                          storeEvent(_title, event);
                          Navigator.pop(context);
                        } else {
                          storeEvent(_title);
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ),
                if (event != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      child: Text(
                        '削除',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.redAccent,
                        onPrimary: Colors.black,
                        elevation: 16,
                      ),
                      onPressed: () {
                          destroyEvent(event);
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
