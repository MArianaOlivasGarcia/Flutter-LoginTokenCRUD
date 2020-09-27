
import 'dart:async';

class Validaciones{

  // Definir los streams transformes
                        // Recibe un string y sale un string
  final validarPassword = StreamTransformer<String, String>.fromHandlers(
    handleData: ( password, sink ){
      // sink es para dejar fluir
      if( password.length >= 6 ){
        sink.add( password );
      } else {
        // Mandar un error
        sink.addError('Más de 6 caracteres');
      }
    }
  );



  final validarEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: ( email, sink ){
      
      Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

      // Crear expresion regular
      RegExp regExp = new RegExp( pattern );

      if( regExp.hasMatch( email ) ){
        sink.add( email );
      } else {
        sink.addError('Correo electrónico no válido');
      }

    }
  );





}