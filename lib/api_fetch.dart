// ignore_for_file: avoid_unnecessary_containers, non_constant_identifier_names, prefer_const_constructors, sized_box_for_whitespace, unnecessary_string_interpolations

import 'package:flutter/material.dart';

import 'main.dart';

//https://api.rawg.io/api/games?key=fdaed442f35b4f25b70d5a94947e3310

class LoadData {
  String name;
  String image;
  String metacritic;
  String genre;

  LoadData(
      {this.name = 'N',
      this.image = 'https://giphy.com/gifs/mashable-3oEjI6SIIHBdRxXI40',
      this.metacritic = 'N',
      this.genre = 'N'});

  factory LoadData.fromJson(Map<dynamic, dynamic> json) {
    return LoadData(
      name: json['name'],
      image: json['image'],
      metacritic: json['metacritic'],
      genre: json['genre'],
    );
  }
}

InkWell create_container(String imgPath, String gameName, String metacritic,
    String genre, double screenHeight, double screenWidth,BuildContext context) {
    return InkWell(onTap: () {Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => DetailPage(value: UserClick(gameName,imgPath),)));},
    child: Container(
      margin: EdgeInsets.only(top: 5, bottom: 5),
      color: Color.fromARGB(255, 241, 241, 241),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 15),
              height: screenHeight / 5,
              width: screenWidth / 3,
              child: Image.network(imgPath),
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              //color: Colors.amber.shade100,
              margin: EdgeInsets.only(top: 20, left: 15),
              height: screenHeight / 13,
              width: screenWidth / 2,
              child: Text(
                gameName,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                  //color: Colors.amber.shade100,
                  margin: EdgeInsets.only(left: 10),
                  height: screenHeight / 30,
                  width: screenWidth / 4.5,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "metacritic:",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  )),
              Container(
                  //color: Colors.amber.shade100,
                  height: screenHeight / 19,
                  width: screenWidth / 12,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "$metacritic",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Colors.red),
                    ),
                  )),
            ]),
            Container(
                //color: Colors.amber.shade100,
                margin: EdgeInsets.only(left: 15),
                height: screenHeight / 20,
                width: screenWidth / 2,
                child: Text(
                  genre,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
                ))
          ],
        )
      ]),
    ),
  );
}
