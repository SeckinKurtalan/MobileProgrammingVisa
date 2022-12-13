// ignore_for_file: avoid_unnecessary_containers, non_constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';

Widget create_container(
    String imgPath, String gameName, int metacritic, String genre,double screenHeight,double screenWidth) {

  return Container(
    margin: EdgeInsets.only(top: 5, bottom: 5),
    color: Color.fromARGB(255, 241, 241, 241),
    child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
      Column(
        children: [
          Container(
            margin: EdgeInsets.only(left:15),
            height: screenHeight/5 ,
            width: screenWidth/3,
            child: Image.asset(imgPath),
          )
        ],
      ),
      Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            //color: Colors.amber.shade100,
            margin: EdgeInsets.only(top: 20,left: 15),
            height: screenHeight/13,
            width: screenWidth/2,
            child: Text(
              gameName,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
              Container(
                //color: Colors.amber.shade100,
                margin: EdgeInsets.only(left:15),
                height: screenHeight/30,
                width: screenWidth/4.5,
                child: Align(alignment: Alignment.center,
                  child: Text(
                    "metacritic:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                )),
                 Container(
                //color: Colors.amber.shade100,
                height: screenHeight/19,
                width: screenWidth/12,
                child: Align(alignment: Alignment.center,
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
              height: screenHeight/20,
              width: screenWidth/2,
              child: Text(
                genre,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
              ))
        ],
      )
    ]),
  );
}
