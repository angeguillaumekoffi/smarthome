import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:mysql1/mysql1.dart';
import 'dart:async';


class MySql{
  MySql();

  Future<MySqlConnection> connect_db() async{
    var param = new ConnectionSettings(
        host: 'localhost', port: 3306, user: 'root', db: 'sm_db'
    );
    try {
      var ret = await MySqlConnection.connect(param);
      return ret;
    } catch(e){
      print(e);
      return null;
    }
  }

  void creerTable(){
    connect_db().then((conn){
      conn.query(
          'CREATE TABLE users (id int NOT NULL AUTO_INCREMENT PRIMARY KEY, name varchar(255), email varchar(255), password varchar(40), session int, statut int)'
      ).then((value) => print(value));
    });
  }
}

class ClicksPerYear {
  final String mois;
  final int conso;
  final charts.Color color;

  ClicksPerYear(this.mois, this.conso, Color color)
      : this.color = new charts.Color(
      r: color.red, g: color.green, b: color.blue, a: color.alpha);
}