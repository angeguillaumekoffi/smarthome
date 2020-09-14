import 'package:flutter/material.dart';
import 'package:app/vues/login/login_screen.dart';
import 'package:app/vues/register/register_screen.dart';
import 'package:app/vues/ui/dashboard.dart';

final routes = {
  '/login': (BuildContext context) => new LoginScreen(),
  '/register': (BuildContext context) => new RegisterScreen(),
  '/home': (BuildContext context) => new Dashboard(),
};