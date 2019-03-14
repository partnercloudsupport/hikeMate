import 'package:flutter/material.dart';
import 'map.dart';
import 'authenticator.dart';

void main() => runApp(HikeMate());

class HikeMate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => new Authenticator(),
          '/map': (BuildContext context) => new FireMap(),
        },
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Monserrat'),
        // home: new Authenticator()
        home: Scaffold(
          body: Authenticator(),
          // )
        ));
  }
}
