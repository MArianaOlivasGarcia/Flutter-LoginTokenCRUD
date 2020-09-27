
import 'dart:async';
import 'package:crud/src/blocs/validators.dart';
import 'package:rxdart/rxdart.dart';


// Añadirle las validaciones

class LoginBloc with Validaciones {


  //* CREAR MIS STREAMS
  // por el flujo navegaran datos de tipo String
  //! StreamController<String>.broadcast()  Es lo mismo que BehaviorSubject 
  //! y ya viene incrustado su broadcast (para usar RxDart)
  // final _passwordController = StreamController<String>.broadcast();
  // es lo mismo que final _passwordController = BehaviorSubject<String>();
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  //* RECUPERAR LOS DATOS DEL STREAM          
                          // .tramsform( validacion )
  Stream<String> get emailStream => _emailController.stream.transform( validarEmail );
  Stream<String> get passwordStream => _passwordController.stream.transform( validarPassword );
  

  //* COMBINAR STREAMS CON RXDART
  // Me retorna un true o false
  // Voy a combinar dos streams asi que usamos combine2
  Stream<bool> get formValidStreamCombinado => 
      CombineLatestStream.combine2( emailStream, passwordStream, (e, p) => true);


  //* INSERTAR VALORES AL STREAM
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  


  //* OBTENER EL ULTIMO VALOR INGRESADO A LOS STREAMS (CON GETTERS)
  String get email    => _emailController.value;
  String get password => _passwordController.value;



  //* CERRAR LOS STEAMS
  dispose(){
    _emailController?.close();
    _passwordController?.close(); 
  }


}