import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:app/models/rqt_connecte.dart';

class LoginScreen extends StatefulWidget {
  final String message;

  LoginScreen({Key key, this.message}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>{
  BuildContext _ctx;

  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _email, _password;
  var db= new MySql();

  _connexion({email, passwd}){
    bool retr = false;

    return retr;
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      print("CREDENTIALS: " + _email + " " + _password);
      db.connect_db().then((conn){
        if(conn == null){
          onLoginError(
              "Erreur de connexion ! Vérifiez votre accès à internet");
        } else {
          conn.query('select id from users where email=? and password=?',
              [_email, _password]
          ).then((user) {
            try {
              var _id = user.first['id'];
              print(_id);
              onLoginSuccess();
            } catch (e) {
              print(e);
              onLoginError(
                  "Impossible de vous connecter. L'utilisateur pour ce compte n'a pas été trouvé. Veuillez vous inscrire.");
            }
          });
        }
      });
    }
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(text)));
  }
 
  @override
  Widget build(BuildContext context) {
    _ctx = context;
    bool showLoginScreen;
    print("MESSAGE: " + widget.message.toString());
    if(widget.message == "Féelicitations ! Le compte a bien été créé."){
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
              textScaleFactor: 1.5
            ),
            SizedBox(
              height: 25.0,
            ),
            new Text(
              "Connexion",
              textScaleFactor: 2.0, style: TextStyle(color:Colors.blue[700], fontWeight: FontWeight.bold)
            ),
            SizedBox(
                    height: 25.0,
                  ),
            new Form(
              key: formKey,
              child: new Column(
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new TextFormField(
                      onSaved: (val) => _email = val,
                      validator: (val) {
                        return (!val.contains("@") || !val.contains(".") || val.length < 10)
                            ? "email invalide"
                            : null;
                      },
                      decoration: new InputDecoration(labelText: "Email",),
                      style: texts,
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new TextFormField(
                      obscureText: true,
                      onSaved: (val) => _password = val,
                      decoration: new InputDecoration(labelText: "Mot de passe"),style: texts,
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
              Text("Vous n'avez pas de compte?",),
              FlatButton(
                onPressed: (){
                  Navigator.of(context).pushReplacementNamed('/register');
                },
                child:Text("Inscription", style:TextStyle(color: Colors.blue[700])),
                ),
            ],
          )
        ],)
      )
    );

    return new Scaffold(
      appBar: null,
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: showLoginScreen ? new Container(
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
  TextStyle texts = TextStyle(color: Colors.grey);

  @override
  void onLoginError(String errorTxt) {
    _showSnackBar(errorTxt);
    setState(() => _isLoading = false);
  }

  @override
  void onLoginSuccess() async {
    _showSnackBar('connecté !');
    setState(() => _isLoading = false);
    Navigator.of(_ctx).pushReplacementNamed('/home');
  }


  @override
  void afterFirstLayout(BuildContext context) {
    // TODO: implement afterFirstLayout
    if(widget.message != null){
      _showSnackBar(widget.message);
    }
  }
}