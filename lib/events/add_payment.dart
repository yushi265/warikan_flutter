import 'package:flutter/material.dart';

class AddPayment extends StatefulWidget {
  AddPayment({Key? key}) : super(key: key);

  @override
  _AddPaymentState createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {
  String _title = '';
  String _price = '';
  String _memo = '';

  List<DropdownMenuItem<int>> _users = [];
  int _selectUser = 0;

  List<DropdownMenuItem<int>> _events = [];
  int _selectEvent = 0;

  @override
  void initState() {
    super.initState();
    setUsers();
    setEvents();
    _selectUser = _users[0].value!;
    _selectEvent = _events[0].value!;
  }

  void setUsers() {
    _users
      ..add(DropdownMenuItem(
        child: Text('ゆうき'),
        value: 1,
      ))
      ..add(DropdownMenuItem(
        child: Text('あすか'),
        value: 2,
      ));
  }

  void setEvents() {
    _events
      ..add(DropdownMenuItem(
        child: Text('高崎'),
        value: 1,
      ))
      ..add(DropdownMenuItem(
        child: Text('前橋'),
        value: 2,
      ));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('支払いを追加する'),
      ),
      body: Container(
          margin: EdgeInsets.only(top: 64),
          padding: EdgeInsets.all(30),
          child: Column(
              children: [
                Padding(padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DropdownButton<int>(
                        items: _events,
                        value: _selectEvent,
                        onChanged: (value) => {
                          setState(() {
                            _selectEvent = value!;
                          }),
                        },
                      ),
                      Text('で、'),
                    ],
                  ),
                ),
                Padding(padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DropdownButton<int>(
                        items: _users,
                        value: _selectUser,
                        onChanged: (value) => {
                          setState(() {
                            _selectUser = value!;
                          }),
                        },
                      ),
                      Text('が、'),
                    ],
                  ),
                ),
                Padding(padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _title,
                        decoration: InputDecoration(
                          labelText: "タイトル",
                        ),
                        onChanged: (value) => {
                          setState(() {
                            _title = value;
                          }),
                        },
                      ),
                    ],
                  ),
                ),
                Padding(padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _price,
                        decoration: InputDecoration(
                          labelText: "金額",
                        ),
                        onChanged: (value) => {
                          setState(() {
                            _price = value;
                          }),
                        },
                      ),
                    ],
                  ),
                ),
                Padding(padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _memo,
                        decoration: InputDecoration(
                          labelText: "メモ",
                        ),
                        onChanged: (value) => {
                          setState(() {
                            _memo = value;
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
                          Navigator.of(context).pop();
                        },
                    ),),
                ),
              ]
          ),
        )
    );
  }
}
