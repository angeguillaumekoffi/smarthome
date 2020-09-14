import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:app/models/rqt_connecte.dart';
import 'dart:math';

class Graph extends StatefulWidget {
  Graph({Key key, this.title, this.userId, this.nomEqmnt}) : super(key: key);

  final String title;
  final userId;
  final nomEqmnt;

  @override
  _GraphState createState() => _GraphState(userId: userId, nomEqmnt: nomEqmnt);
}

class _GraphState extends State<Graph> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final userId;
  final nomEqmnt;
  String nomEtat;
  bool etatActuel;
  _GraphState({this.userId, this.nomEqmnt});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    etatActuel = false;
    nomEtat = 'En arrêt';
  }

  int _convert_bool_entier(bool val) {
    return val == true ? 1 : 0;
  }
  void _showSnackBar(String text) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    var data = [
      new ClicksPerYear('Jan', 12, Colors.red),
      new ClicksPerYear('Fév', 42, Colors.yellow),
      new ClicksPerYear('Mars', 35, Colors.green),
      new ClicksPerYear('Avr', 15, Colors.purple),
      new ClicksPerYear('Mai', 75, Colors.blue),
      new ClicksPerYear('Juin', 30, Colors.green),
    ];
    var series = [
      new charts.Series(
        id: 'conso',
        domainFn: (ClicksPerYear clickData, _) => clickData.mois,
        measureFn: (ClicksPerYear clickData, _) => clickData.conso,
        colorFn: (ClicksPerYear clickData, _) => clickData.color,
        data: data,
      ),
    ];
    var chart = new charts.BarChart(series, animate: true,);
    var chartWidget = new Padding(
      padding: new EdgeInsets.all(10.0),
      child: new SizedBox(
        height: 200.0,
        child: chart,
      ),
    );

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
                              Text("Connecté! $userId"),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text("87 KWH", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                              Text("Consommation\n du mois"),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text("348 KWH", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
                              Text("Consommation\n totale"),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: Center(
                    child: Text("$nomEqmnt", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                  ),
                ),
                chartWidget,
                SizedBox(height: 40,),
                Divider(),
                SwitchListTile(
                  activeColor: Colors.red,
                  title: Text("$nomEtat", style: TextStyle(fontWeight: FontWeight.bold),),
                  value: etatActuel,
                  secondary: Icon(
                    Icons.lightbulb_outline, color: Colors.red,),
                  onChanged: (value) {
                    setState(() {
                      etatActuel = value;
                      nomEtat = etatActuel? 'En marche': 'En arrêt';
                    });
                  },
                ),
                Divider()
              ],
            ),
          ),
        ),
      )
    );
  }

}
