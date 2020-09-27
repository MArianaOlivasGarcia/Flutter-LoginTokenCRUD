
import 'package:flutter/material.dart';
import 'package:crud/src/blocs/provider.dart';
import 'package:crud/src/pages/home_page.dart';

class LoginPage extends StatelessWidget {
  
  static final String routeName = 'login';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: <Widget>[

          _crearFondo( context ),

          _loginForm( context )

        ],
      )
    );


  }



 


  Widget _crearFondo( BuildContext context ){

    final size = MediaQuery.of(context).size;

    final fondoMorado = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            Color.fromRGBO(63, 63, 156, 1.0),
            Color.fromRGBO(90, 70, 178, 1.0),
          ]
        )
      ),
    );


    final circulo = Container(
      height: 70.0,
      width: 70.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(70.0),
        color: Color.fromRGBO(255, 255, 255, 0.05)
      ),
    );

    return Stack(
      children: <Widget>[

        fondoMorado,

        Positioned(
          top: 60.0,
          left: 15.0,
          child: circulo ,
        ),

        
        Positioned(
          top: -30.0,
          right: -25.0,
          child: circulo ,
        ),




        Container(
          padding: EdgeInsets.only(
            top: 70.0
          ),
          child: Column(
            children: <Widget>[

              Icon( Icons.android, 
                color: Colors.white,
                size: 50,
              ),

              SizedBox(
                height: 10.0,
                width: double.infinity,
              ),

              Text('Mariana Olivas', 
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white
                ),
              )

            ],
          ),
        )



      ],
    );

  }







   Widget  _loginForm( BuildContext context){

    // Mi clase provider que hereda de inheritedWidget
    final bloc = Provider.ofLogin(context);

    final size = MediaQuery.of(context).size;


    return SingleChildScrollView(

      child: Column(
        children: <Widget>[

          SafeArea(
            child: Container(
              height: 150.0,
            ),
          ),

          Container(
            width: size.width * 0.75,
            margin: EdgeInsets.symmetric(
              vertical: 20.0
            ),
            padding: EdgeInsets.symmetric(
              vertical: 30.0
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              //* SOMBRA
              boxShadow: <BoxShadow>[

                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 3.0
                )

              ]
            ),
            child: Column(
              children: <Widget>[

                Text('Login',
                  style:  TextStyle(
                    fontSize: 18.0
                  )
                ),


                SizedBox(
                  height: 20.0,
                ),


                _crearEmail( bloc ),

                SizedBox(
                  height: 10.0,
                ),

                _crearPassword( bloc ),

                SizedBox(
                  height: 25.0,
                ),

                _crearBoton( bloc )

              ],
            ),
          ),


          Text('¿Olvido su contraseña?'),


          //* Cuando lo ponga en horizontal quede ese espacio siempre
          SizedBox(
                  height: 70.0,
          ),



        ],
      )

    );

  }





  Widget _crearEmail(LoginBloc bloc){


    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20.0
            ),
            child: TextField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                icon: Icon( Icons.alternate_email, 
                  color: Colors.deepPurple
                ),
                hintText: 'ejemplo@ejemplo.com',
                labelText: 'Correo electrónico',
                counterText: snapshot.data,
                errorText:  snapshot.error
              ),
              onChanged: ( value ) => bloc.changeEmail( value ),
            ),
          );

      },
    );

    
  }



  Widget _crearPassword(LoginBloc bloc){

    //* Conectar input con nuetro stream
    return StreamBuilder(
      stream: bloc.passwordStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: 20.0
          ),
          child: TextField(
          //* Ocultar la contraseña
          obscureText: true,
          decoration: InputDecoration(
            icon: Icon( Icons.lock_outline, 
              color: Colors.deepPurple
            ),
            labelText: 'Contraseña',
            counterText: snapshot.data,
            errorText:  snapshot.error
          ),
          onChanged:( value ) => bloc.changePassword( value ) ,
        ),
      );
        
      },
    );

    

  }


  Widget _crearBoton( LoginBloc bloc){

    return StreamBuilder(
      stream: bloc.formValidStreamCombinado ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 50.0,
              vertical: 15.0
            ),
            child: Text('Ingresar'),
          ),
          // * BORDES
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular((5.0))
          ),
          // * Elevación
          elevation: 0.0,
          color: Colors.deepPurple,
          textColor: Colors.white,
          // Si el sanpshot tiene información, retono el callback 
          // de lo contrario retorno null
          onPressed: snapshot.hasData ? () => _login( bloc, context ) : (){},
        );
      },
    );    

  }

  //* Obtener el ultimo valor del stream del email y password
  _login( LoginBloc bloc, BuildContext context ){

   /*  print('=============================');
    print('Email: ${ bloc.email } ');
    print('Password: ${ bloc.password } ');
    print('============================='); */

    Navigator.pushReplacementNamed(context, HomePage.routeName );

  }






}