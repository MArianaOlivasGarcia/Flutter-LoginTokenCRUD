import 'package:flutter/material.dart';
import 'package:crud/src/blocs/login_bloc.dart';
export 'package:crud/src/blocs/login_bloc.dart';
import 'package:crud/src/blocs/productos_bloc.dart';
export 'package:crud/src/blocs/productos_bloc.dart';

class Provider extends InheritedWidget{

  
  // MIS BLOCS
  final _loginBloc = LoginBloc();
  final _productosBloc = ProductosBloc();

  // Patrón singleton
  static Provider _instancia;

  factory Provider({Key key, Widget child}){

    // Si no hay una instancia de Provider
    if ( _instancia == null ){
      // Crea una
      _instancia = new Provider._internal( key: key, child: child);
    }
    // Si existe, retorna la instancia
    return _instancia;

  } 

  // Constructor
  Provider._internal({ Key key, Widget child })
    : super(key: key, child: child);



  // Poner true
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    
    return true;
  }

  //* Crear método of que me retorna mi instancia de arriba del LoginBloc
  static LoginBloc ofLogin(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<Provider>()._loginBloc;
  }

  static ProductosBloc ofProductos(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<Provider>()._productosBloc;
  }





}