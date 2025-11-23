import 'package:flutter/material.dart';
import 'view/home_screen.dart';

void main() => runApp(MealDbApp());

class MealDbApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MealDB Recipes',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: HomeScreen(),
    );
  }
}
