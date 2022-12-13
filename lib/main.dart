// ignore_for_file: unused_import, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'favorites_view.dart';
import 'my_custom_icons_icons.dart';
import 'TopAppBar.dart';
import 'api_fetch.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Proje',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(
              title:
                  "Games", //The app is focused on game news so we set the title "Games".
            ),
        '/favorites': (context) =>
            const FavoritesView() //For the other tab which we named "Favorites", we created a "FavoritesView" state.
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  //This app has some user interacted widgets so we made the widget Stateful.
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex =
      0; //We hold a currentIndex variable so we can track our page index.
  @override
  Widget build(BuildContext context) {
    var screenSpecs = MediaQuery.of(context);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TopAppBar(
            PageName: 'Games',
          ),
          create_container(
              "pictures/bf1.png", "Battlefield", 96, "Action, Shooter",screenSpecs.size.height,screenSpecs.size.width),
          create_container("pictures/gta5.png", "Grand Theft Auto V", 93,
              "Action, Real World",screenSpecs.size.height,screenSpecs.size.width),
        ],
      ),
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
        currentIndex: 0,
        onTap: (value) {
          if (value != 0) {
            Navigator.pushNamed(context, '/favorites');
          }
        },
      ),
    );
  }
}
