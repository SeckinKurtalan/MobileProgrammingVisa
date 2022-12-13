// ignore_for_file: unnecessary_import, implementation_imports, unused_import, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'TopAppBar.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
          TopAppBar(
            PageName: 'Favorites',
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              'There is no favorites found',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        ]),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            //BottomNavigationBarItem(
            //icon: Icon(MyCustomIcons.gamepad), label: "Games"),
            //BottomNavigationBarItem(
            //icon: Icon(MyCustomIcons.fav), label: "Favorites")
            BottomNavigationBarItem(icon: Icon(Icons.gamepad), label: "Games"),
            BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: "Favorites",
            )
          ],
          currentIndex: 1,
          onTap: (value) {
            if (value != 1) {
              Navigator.pushNamed(context, '/');
            }
          },
        ));
  }
}
