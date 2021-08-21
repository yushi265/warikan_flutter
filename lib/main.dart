import 'package:flutter/material.dart';
import 'events/add_payment.dart';
import 'events/event_list.dart';
import 'footer.dart';
import 'package:http/http.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'warikan',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: EventList(),
        bottomNavigationBar: Footer(),
      ),
      routes: <String, WidgetBuilder>{
        '/event-list': (BuildContext context) => new EventList(),
      },
    );
  }
}
