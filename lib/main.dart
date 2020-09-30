

import 'package:crud/src/pages/producto_page.dart';
import 'package:crud/src/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:crud/src/blocs/provider.dart';
import 'package:crud/src/pages/home_page.dart';
import 'package:crud/src/pages/login_page.dart';
import 'package:crud/src/preferecias_usuario/preferencias_usuario.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  final preferencias = new PreferenciasUsuario();
  await preferencias.initPreferencias();


  runApp(MyApp());
   
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

  
  final preferencias = new PreferenciasUsuario();
  print( 'EL TOKEN ES: ${preferencias.token}' );
    
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CRUD',
        initialRoute: HomePage.routeName,
        routes: {
          LoginPage.routeName : (BuildContext context) => LoginPage(),
          RegisterPage.routeName  : (BuildContext context) => RegisterPage(),
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