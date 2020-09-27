
import 'package:flutter/material.dart';
import 'package:crud/src/models/producto_model.dart';
import 'package:crud/src/blocs/provider.dart';
import 'package:crud/src/pages/producto_page.dart';

class HomePage extends StatefulWidget {
  
  static final String routeName = 'home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {

    final productosBloc = Provider.ofProductos(context);
    productosBloc.cargarProductos();
  
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: _crearListado( productosBloc ),
      floatingActionButton: _crearBoton( context ),
    );
  }

  Widget _crearListado( ProductosBloc productosBloc ){


    return StreamBuilder(
      stream: productosBloc.productoStream,
      builder: (BuildContext context, AsyncSnapshot<List<Producto>> snapshot){
        
        if( snapshot.hasData ){
          
          final productos = snapshot.data;

          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, i) {

              return _crearItem( context, productosBloc, productos[ i ] );

            },
          );

        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

      },
    );

  }

  Widget _crearItem( BuildContext context, ProductosBloc productosBloc, Producto producto ){

    return Dismissible(
      key:  UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: ( direccion ){
        
        //productoProvider.borrarProducto( producto.id );
        productosBloc.borrarProducto( producto.id );

      },
      child: Card(
        child: Column(
          children: [

            ( producto.fotoUrl == null )
              ? Image( image: AssetImage('assets/no-image.png') )
              : FadeInImage(
                image: NetworkImage( producto.fotoUrl ),
                placeholder: AssetImage('assets/jar-loading.gif'),
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

              ListTile(
                title: Text( '${producto.titulo} - ${producto.valor}' ),
                subtitle: Text( producto.id ),
                onTap: () => Navigator.pushNamed(context, ProductoPage.routeName, arguments: producto ).then((value) {    setState(() {          });  }),
              ),

          ],
        )
      )
    );

  }

  Widget _crearBoton(BuildContext context){

    return FloatingActionButton(
      child: Icon( Icons.add ),
      backgroundColor: Colors.deepPurple,
      onPressed: () => Navigator.pushNamed(context, ProductoPage.routeName).then((value) {    setState(() {          });  }),
    );

  }
}