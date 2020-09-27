

import 'package:crud/src/pages/producto_page.dart';
import 'package:flutter/material.dart';
import 'package:crud/src/blocs/provider.dart';
import 'package:crud/src/pages/home_page.dart';
import 'package:crud/src/pages/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'login',
        initialRoute: HomePage.routeName,
        routes: {
          LoginPage.routeName : (BuildContext context) => LoginPage(),
          HomePage.routeName  : (BuildContext context) => HomePage(),
          ProductoPage.routeName  : (BuildContext context) => ProductoPage(),
        },
        theme: ThemeData(
          primaryColor: Colors.deepPurple
        ),
      ),
    );
    
    
    
  }
}