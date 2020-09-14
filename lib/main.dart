import 'package:app/vues/ui/home.dart';
import 'package:flutter/material.dart';
import 'urls.dart';
import 'package:app/vues/login/login_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {

  bool _isLoading = true;
  bool _isUserLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _isLoggedIn().then((isLogged) {
      print("Connecté " + isLogged.toString());
      if(isLogged == true){
        setState(() {
          _isLoading = false;
          _isUserLoggedIn = isLogged;
        });
      }
      setState(() {
        _isLoading = false;
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.blue[400],
          accentColor: Colors.blue[400],
          hintColor: Colors.grey,
        ),
        routes: routes,
        debugShowCheckedModeBanner: false,
        home: _isLoading ? Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ) : SafeArea(
          top: true,
          left: true,
          bottom: true,
          right: true,
          child: _isUserLoggedIn ? HomePage() : LoginScreen(message: null,),
        )
    );
  }
}

Future<bool> _isLoggedIn() async{
  /*
  DatabaseHelper helper = new DatabaseHelper();
  await helper.initializaDatabase();
  var users = await helper.getUserList();
  if(users.length != null){
    for(var user in users){
      if(user.userLoggedIn == 1)
        return true;
    }
  }*/
  return false;

}
