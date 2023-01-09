// ignore_for_file: unnecessary_import, implementation_imports, unused_import, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:dnemee/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'app_bar.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  @override
  Widget build(BuildContext context) {
    var ResponsiveWidth = MediaQuery.of(context).size.width;
    var ResponsiveHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Column(children: [
          TopAppBar(
            textEditingController: TextEditingController(),
            PageName: 'Favorites (${DetailPage.favoriteNameList.length})',
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: DetailPage.favoriteNameList.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key('${DetailPage.favoriteNameList[index].gameName}'),
                onDismissed: (direction) {
                  setState(() {
                    DetailPage.favoriteNameList.removeAt(index);
                  });
                },
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DetailPage(
                              value: UserClick(
                                  DetailPage.favoriteNameList[index].gameName,
                                  DetailPage
                                      .favoriteNameList[index].gameImageURL),
                            )));
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 5, bottom: 5),
                    color: Color.fromARGB(255, 241, 241, 241),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 15),
                                height: ResponsiveHeight / 5,
                                width: ResponsiveWidth * 0.3,
                                child: Image.network(DetailPage
                                    .favoriteNameList[index].gameImageURL),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                //color: Colors.amber.shade100,
                                margin: EdgeInsets.only(top: 20, left: 15),
                                height: ResponsiveHeight / 13,
                                width: ResponsiveWidth / 2,
                                child: Text(
                                  DetailPage.favoriteNameList[index].gameName,
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900),
                                ),
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        //color: Colors.amber.shade100,
                                        margin: EdgeInsets.only(left: 10),
                                        height: ResponsiveHeight / 30,
                                        width: ResponsiveWidth / 4.5,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "metacritic:",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        )),
                                    Container(
                                        //color: Colors.amber.shade100,
                                        height: ResponsiveHeight / 19,
                                        width: ResponsiveWidth / 12,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "93",
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
                                  height: ResponsiveHeight / 20,
                                  width: ResponsiveWidth / 2,
                                  child: Text(
                                    "Action, Shooter",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey.shade800),
                                  ))
                            ],
                          )
                        ]),
                  ),
                ),
              );
            },
          ))
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
