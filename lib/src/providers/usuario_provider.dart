
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crud/src/preferecias_usuario/preferencias_usuario.dart';

class UsuarioProvider {

  final String _firebaseToken = 'AIzaSyAnT7J1LqQfylvWw29E_mCLerQUqC5dOKA';
  final _preferencias = new PreferenciasUsuario();

  Future<Map<String, dynamic>> login( String email, String password ) async{

    final authData = {
      'email' : email,
      'password': password,
      'returnSecureToken': true
    };

    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken',
      body: json.encode( authData )
    );


    Map<String, dynamic> decodedResp = json.decode( resp.body );

    print( decodedResp );

    if( decodedResp.containsKey('idToken') ){
      //  Guardar token en el storage
      _preferencias.token = decodedResp['idToken'];

      return { 'ok': true };
    } else {
      return { 'ok': false, 'mensaje': decodedResp['error']['message'] };
    }

  }



  Future<Map<String, dynamic>> nuevoUsuario( String email, String password ) async{

    final authData = {
      'email' : email,
      'password': password,
      'returnSecureToken': true
    };

    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken',
      body: json.encode( authData )
    );


    Map<String, dynamic> decodedResp = json.decode( resp.body );

    print( decodedResp );

    if( decodedResp.containsKey('idToken') ){
      // Guardar token en el storage
      _preferencias.token = decodedResp['idToken'];


      return { 'ok': true };
    } else {
      return { 'ok': false, 'mensaje': decodedResp['error']['message'] };
    }

  }


}