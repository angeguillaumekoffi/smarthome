import 'dart:ui';
import 'package:app/models/rqt_connecte.dart';
import 'package:app/vues/login/login_screen.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  final String message;

  RegisterScreen({Key key, this.message}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen>{
  BuildContext _ctx;

  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _full_name, _email, _password1, _password2;

  var db= new MySql();
  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      print("CREDENTIALS: "+ _full_name+ "" + _email + " " + _password1+" "+_password2);
      db.connect_db().then((conn){
        if(conn == null){
          onRegisterError(
              "Erreur de connexion ! Vérifiez votre accès à internet");
        } else {
          conn.query(
              'insert into users (name, email, password, statut, session) values (?, ?, ?, ?, ?)',
              [_full_name, _email, _password1, 0, 0]
          ).then((user) {
            try {
              var _id = user.first['id'];
              print(_id);
              onRegisterSuccess('utilisateur bien créé !');
            } catch (e) {
              print(e);
              onRegisterError('erreur !');
            }
          });
        }
      });
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    bool showLoginScreen;
    print("MESSAGE: " + widget.message.toString());
    if(widget.message == "Successfully registered, please sign in."){
      showLoginScreen = true;
    }
    else if(widget.message  != null){
      showLoginScreen = false;
    }
    else{
      showLoginScreen = true;
    }

    var loginBtn = new RaisedButton(
      onPressed: _submit,
      child: new Text("CONNEXION", style: TextStyle(color: Colors.white),),
      color: Color.fromARGB(255, 69, 166, 216),
    );
    var loginForm = new Center(
        child:SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child:  new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(image: AssetImage('assets/logo.png'),),
                SizedBox(height: 5.0,),
                new Text(
                  "Smart Home",
                  textScaleFactor: 1.5,
                ),
                SizedBox(
                  height: 25.0,
                ),
                new Text(
                  "Connexion",
                  style: TextStyle(color:Colors.blue[700], fontWeight: FontWeight.bold),
                  textScaleFactor: 2.0,
                ),
                new Form(
                  key: formKey,
                  child: new Column(
                    children: <Widget>[
                      new Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new TextFormField(
                          onSaved: (val) => _full_name = val,
                          validator: (val) {
                            return (val.length < 5 && val.contains(" "))
                                ? "Veuillez entrer un nom"
                                : null;
                          },
                          decoration: new InputDecoration(labelText: "Nom utilisateur"),
                          style: texts,
                        ),
                      ),
                      new Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new TextFormField(
                          onSaved: (val) => _email = val,
                          validator: (val) {
                            return (!val.contains("@") || !val.contains(".") || val.length < 10)
                                ? "email invalide"
                                : null;
                          },
                          decoration: new InputDecoration(labelText: "Email"),
                          style: texts,
                        ),
                      ),
                      new Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new TextFormField(
                          obscureText: true,
                          onSaved: (val) => _password1 = val,
                          decoration: new InputDecoration(labelText: "Mot de passe"),
                          style: texts,
                        ),
                      ),
                      new Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new TextFormField(
                          obscureText: true,
                          onSaved: (val) => _password2 = val,
                          validator: (val) {
                            return (_password2 == _password1)
                                ? null : "Les mots de passe saisis ne correspondent pas !";
                          },
                          decoration: new InputDecoration(labelText: "Mot de passe encore"),
                          style: texts,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                _isLoading ? new CircularProgressIndicator() : loginBtn,
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Avez vous déja un compte?",),
                    FlatButton(
                      onPressed: (){
                        Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => LoginScreen(message: null,)),);
                      },
                      child:Text("Connexion", style:TextStyle(color: Colors.blue[700])),
                    ),
                    SizedBox(width:10),
                  ],
                )
              ],)
        )
    );


    return new Scaffold(
        appBar: null,
        key: scaffoldKey,
        body: showLoginScreen ? new Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/fonds/fond21.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: new Center(
            child: new ClipRect(
              child: new BackdropFilter(
                filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: new Container(
                  child: loginForm,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.height,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ) : AlertDialog(
          title: Text('Votre session a expirée.'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Veuillez vous connecter SVP'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                setState(() {
                  showLoginScreen = true;
                });
                Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => LoginScreen(message: null,)),);
              },
            ),
          ],
        )
    );
  }
  @override
  void onRegisterError(String errorTxt) {
    // TODO: implement onRegisterError
     _showSnackBar(errorTxt);
    setState(() => _isLoading = false);
  }

  @override
  void onRegisterSuccess(String res) {
    // TODO: implement onRegisterSuccess
    _showSnackBar(res);
    setState(() => _isLoading = false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginScreen(message: "Successfully registered, please sign in.",)));
  }
  TextStyle texts = TextStyle(color: Colors.grey);
}