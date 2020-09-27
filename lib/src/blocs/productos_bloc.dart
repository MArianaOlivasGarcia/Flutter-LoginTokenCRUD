

import 'dart:io';

import 'package:rxdart/rxdart.dart';
import 'package:crud/src/models/producto_model.dart';
import 'package:crud/src/providers/producto_provider.dart';

class ProductosBloc {


  final _productosController = new BehaviorSubject<List<Producto>>();
  final _cargandoController = new BehaviorSubject<bool>();

  final _productosProvider = new ProductoProvider();

  Stream<List<Producto>> get productoStream => _productosController.stream;
  Stream<bool> get cargandoStream => _cargandoController.stream;


  void cargarProductos() async{

    final productos = await _productosProvider.cargarProductos();
    _productosController.sink.add( productos );

  }




  void agregarProducto( Producto producto ) async {

    _cargandoController.sink.add(true);
    await _productosProvider.crearProducto( producto );
    _cargandoController.sink.add(false);

  }





  void editarProducto( Producto producto ) async {

    _cargandoController.sink.add(true);
    await _productosProvider.editarProducto( producto );
    _cargandoController.sink.add(false);

  }



  Future<String> subirFoto( File foto ) async {

    _cargandoController.sink.add(true);
    final fotoUrl = await _productosProvider.subirImagen( foto );
    _cargandoController.sink.add(false);

    return fotoUrl;

  }





  void borrarProducto( String id ) async {

    await _productosProvider.borrarProducto( id );

  }





  dispose(){
    _productosController?.close();
    _cargandoController?.close();
  }

}