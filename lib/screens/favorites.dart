import 'package:flutter/material.dart';


class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xff20124d),

      body: Center(child: Text('Last Page', style:  TextStyle(fontSize: 18, color: Colors.white),),),
    );   
  }
}