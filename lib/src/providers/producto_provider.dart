
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:crud/src/models/producto_model.dart';

class ProductoProvider {

  final String _url = 'https://productos-6d78e.firebaseio.com';


  Future<bool> crearProducto( Producto producto ) async {

    final url = '$_url/productos.json';

    final resp = await http.post( url, body: productoToJson( producto ) );

    final decodedData = json.decode( resp.body );

    print( decodedData );

    return true;

  }




  Future<List<Producto>> cargarProductos() async {

    final url = '$_url/productos.json';

    final resp = await http.get( url );

    /* 
    En firebase se guarda en un json
    -ElIDdelProducto : {
                        "nombre": "producto 1",
                        "precio": 500.0
                       }
    *Basicamente es un map Map<String, dynamic>                   
    */

    final Map<String, dynamic> decodedData = json.decode( resp.body );
    print( decodedData );

    /* Hacemos un forEach para almacenar los productos */
    final List<Producto> productos = new List();

    if( decodedData == null ) return [];

    decodedData.forEach( (id, prod ) {

      final productoTemp = Producto.fromJson( prod );

      productoTemp.id = id;

      productos.add( productoTemp );

    });

    print( productos );

    return productos;

  }




  Future<bool> borrarProducto( String id ) async{

    final url = '$_url/productos/$id.json';

    final resp = await http.delete( url );

    print( json.decode( resp.body ) );

    return true;

  }





  Future<bool> editarProducto( Producto producto ) async {

    final url = '$_url/productos/${ producto.id }.json';

    final resp = await http.put( url, body: productoToJson( producto ) );

    final decodedData = json.decode( resp.body );

    print( decodedData );

    return true;

  }





  Future<String> subirImagen( File imagen ) async {

    final url = Uri.parse('https://api.cloudinary.com/v1_1/mariana-olivas/image/upload?upload_preset=kxhti5po');

    // Saber que tipo de imagen es .png, .gif,  etc
    final mimeType =  mime( imagen.path ).split('/');  // imagen/jpeg , Separar por '/', 


    final imageUploadRequest = http.MultipartRequest(
      'POST',
      url
    );

    final file = await http.MultipartFile.fromPath(
      'file',
      imagen.path,
      contentType: MediaType( mimeType[0], mimeType[1] )
    );

    imageUploadRequest.files.add( file );

    // Adjuntar multiples archivos
    // imageUploadRequest.files.add( file2 );
    // imageUploadRequest.files.add( file3 );
    // imageUploadRequest.files.add( file4 );

    final streamResponse = await imageUploadRequest.send();

    final resp = await http.Response.fromStream( streamResponse );

    if( resp.statusCode != 200 && resp.statusCode != 201 ){
      print('Algo salio mal');
      print( resp.body );
      return null;
    }

    final decodedData = json.decode( resp.body );

    print( decodedData );

    return decodedData['secure_url'];

  }




}