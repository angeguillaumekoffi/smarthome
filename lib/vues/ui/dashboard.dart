import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/vues/ui/graph.dart';
import 'package:app/models/rqt_connecte.dart';
import 'dart:math';

class Dashboard extends StatefulWidget {
  Dashboard({Key key, this.title, this.userId}) : super(key: key);

  final String title;
  final userId;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  var userId, nomEqmnt;

  Widget bloc({url_image='assets/festival.png', double width=50, double height=50, nom, bool etat=false, void onClick(), void onLongClick(),}){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            blurRadius: 1.0,
            color: Colors.black.withOpacity(.5),
            offset: Offset(0.0, 1.0),
          ),
        ],
      ),
      child: FlatButton(
        onPressed: (){},
        onLongPress: (){
          setState(() {
            userId = 1;
            nomEqmnt = nom;
          });
          onLongClick();
        },
        color: Colors.white,
        child: Container(
          height: 150,
          width: MediaQuery.of(context).size.width*0.38,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Image(image: AssetImage(url_image), width: width, height: height,),
                      )
                  ),
                  Container(
                    child: Icon(Icons.check_circle, color: etat ? Colors.green: Colors.grey, size: 20,),
                  )
                ],
              ),
              Spacer(),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('$nom', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Maison principale', style: TextStyle(fontSize: 14, color: Colors.grey),)
              ),
              SizedBox(height: 5,)
            ],
          )
        ),
      ),
    );
  }
  void _showSnackBar(String text) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    var color = 0xff1f224e;
    void dialog(){
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            title: Text('Maison intelligente', style: TextStyle(color: Colors.blue),),
            content: Text('Que voulez vous faire ?'),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                child: Text('Allumer/Eteindre'),
                onPressed: () => Navigator.pop(context, 'eteindre'),
              ),
              FlatButton(
                color: Colors.blue,
                child: Text('Voir la consommation'),
                onPressed: () => Navigator.pop(context, 'voir'),
              ),
            ],
          )
      ).then((Valretour) {
        if(Valretour == 'voir'){
          Navigator.push(context, new MaterialPageRoute(builder: (context)=> new Graph(userId: userId, nomEqmnt: nomEqmnt,)));
        }
      });
    }
    return Scaffold(
      body: Container(
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white70,
            ),
            child: ListView(
              children: <Widget>[
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 1.0,
                      color: Colors.black.withOpacity(.5),
                      offset: Offset(0.0, 1.0),
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 5,),
                    Row(
                      children: <Widget>[
                        SizedBox(width: 20,),
                        Image(
                          image: AssetImage('assets/weather.png'),
                          width: 100,
                        ),
                        Text('Maison Intelligente', style: TextStyle(fontSize: 28, color: Colors.blue, fontWeight: FontWeight.bold),)
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text("Admin", style: TextStyle(fontSize: 24, color: Colors.red, fontWeight: FontWeight.bold),),
                            Text("Connecté!"),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text("28°", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                            Text("Temperature \n de la maison"),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text("54%", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                            Text("Humitité \nd'interieur"),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    bloc(
                      url_image:'assets/clim.jpg',
                      width: 70,
                      etat: true,
                      nom: 'Climatiseur',
                      onLongClick: dialog,
                    ),
                    bloc(
                      url_image:'assets/ampoule.png',
                      width: 70,
                      nom: 'Ampoule',
                      onLongClick: dialog,
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    bloc(
                      url_image:'assets/prise.png',
                      width: 70,
                      nom: 'Prise Electrique',
                      onLongClick: dialog,
                    ),
                    bloc(
                      url_image:'assets/ampoule.png',
                      width: 70,
                      etat: true,
                      nom: 'Autre',
                      onLongClick: dialog,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}
