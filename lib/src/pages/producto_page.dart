

import 'dart:io';

import 'package:crud/src/blocs/provider.dart';
import 'package:crud/src/models/producto_model.dart';
import 'package:flutter/material.dart';
import 'package:crud/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';


class ProductoPage extends StatefulWidget {
  
  static final String routeName = 'producto';

  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  
  ProductosBloc productosBloc;
  Producto producto = new Producto();
  bool _cargando = false;
  File foto;



  @override
  Widget build(BuildContext context) {

    final Producto productoArg = ModalRoute.of( context ).settings.arguments;

    productosBloc = Provider.ofProductos(context);


    if( productoArg != null ){
      producto = productoArg;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: _crearAppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),

          child: Form(
            key: formKey,
            child: Column(
              children: [

                _mostrarFoto(),

                _crearNombre(),

                _crearPrecio(),

                _crearDisponible(),
                
                _crearBoton(),


              ],
            ),
          ),

        ),
      ),
    );
  }

  Widget _crearAppBar(){

    return AppBar(
      title: Text('Producto'),
      actions: [
        IconButton(
          icon: Icon( Icons.photo_size_select_actual ),
          onPressed: _seleccionarFoto,
        ),
        IconButton(
          icon: Icon( Icons.camera_alt ),
          onPressed: _tomarFoto ,
        )
      ],
    );


  }

  Widget _crearNombre(){

    return TextFormField(
      initialValue: producto.titulo,
      onSaved: (value) => producto.titulo = value,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto'
      ),
      validator: (value) {

        if( value.length < 3 ) {
          return 'Ingrese el nombre del producto';
        } else {
          return null;
        }

      },
    );

  }

  Widget _crearPrecio(){

    return TextFormField(
      initialValue: producto.valor.toString(),
      onSaved: (value) => producto.valor = double.parse(value),
      keyboardType: TextInputType.numberWithOptions(
        decimal: true
      ),
      decoration: InputDecoration(
        labelText: 'Precio'
      ),
      validator: (value) {

        if ( utils.isNumeric(value) ){
          return null;
        } else {
          return 'Sólo números';
        }

      },
    );

  }

  Widget _crearBoton(){

    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      color: Colors.deepPurple,
      textColor: Colors.white,
      label: Text('Guardar'),
      icon: Icon( Icons.save ),
      onPressed: ( _cargando ) ? null : _submit,
    );

  }


  Widget _crearDisponible(){

    return SwitchListTile(
      value: producto.disponible,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState((){
        producto.disponible = value;
      }),
    );  

  }

  void _submit() async {

    if ( !formKey.currentState.validate() ) return;

    print( 'Todo OK' );

    // Disparar todos los onSaved de los inputs dentro del form
    formKey.currentState.save();

    /* print( producto.titulo );
    print( producto.valor );
    print( producto.disponible ); */
    
    setState(() {
      _cargando = true;
    });


    // Subir la foto si selecciono o tomo alguno 
    if( foto != null ){
      
      producto.fotoUrl = await productosBloc.subirFoto( foto );

    }


    if( producto.id == null ){
      productosBloc.agregarProducto( producto );

      mostrarSnackbar('Registro creado con éxito');

    } else {
      productosBloc.editarProducto( producto );

      mostrarSnackbar('Registro editado con éxito');

    }

    Navigator.pop(context);



  }



  void mostrarSnackbar( String mensaje ){

    final snackbar = SnackBar(
      content: Text( mensaje ),
      duration: Duration( milliseconds: 1500 )
    );

    scaffoldKey.currentState.showSnackBar( snackbar );

  }


  Widget _mostrarFoto(  ) {

    if( producto.fotoUrl != null ){

      return FadeInImage(
        image: NetworkImage( producto.fotoUrl ),
        placeholder: AssetImage('assets/jar-loading.gif'),
        height: 300,
        width: double.infinity,
        fit: BoxFit.contain,
      );

    } else {

      // La imagen que selecciona del carrete (vista previa) 
      // Si la foto tiene un path la pone si no muestra el no-image
      if( foto != null ){

        return Image.file(
          foto,
          height: 300.0,
          fit: BoxFit.cover
        );

      }

      return Image.asset(
        'assets/no-image.png',
        height: 300.0,
        fit: BoxFit.cover
      );

    }

  }




  _procesarImagen( ImageSource origen ) async {
    
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(
      source: origen,
    );
    
    try {
      foto = File(pickedFile.path);
    } catch (e) {
      print('$e');
    }
 
    if (foto != null) {
       producto.fotoUrl = null;
    }
 
    setState(() {});
  }





  _seleccionarFoto() async {
    _procesarImagen( ImageSource.gallery );
  }


  _tomarFoto() async {
    _procesarImagen( ImageSource.camera );
  }

  


}