// ignore_for_file: unused_import, prefer_const_literals_to_create_immutables, prefer_const_constructors, unrelated_type_equality_checks

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'favorites_view.dart';
import 'my_custom_icons_icons.dart';
import 'app_bar.dart';
import 'api_fetch.dart';
import 'package:http/http.dart' as http;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Step 3
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(MyApp()));
  runApp(MyApp());
}

List<LoadData> postList = [];

Future<List<LoadData>> apiCall() async {
  final response = await http.get(
      Uri(scheme: "https", host: "hi2media.com", path: "/asset/games.json"));
  var data = jsonDecode(response.body.toString());

  for (Map i in data) {
    postList.add(LoadData.fromJson(i));
  }
  return postList;
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
            const FavoritesView(),
        '/DetailPage': (context) => const DetailPage(value: UserClick(" ", " "),)
        //For the other tab which we named "Favorites", we created a "FavoritesView" state.
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
          FutureBuilder(
            future: apiCall(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return create_container(
                    snapshot.data![0].image,
                    snapshot.data![0].name,
                    snapshot.data![0].metacritic,
                    snapshot.data![0].genre,
                    screenSpecs.size.height,
                    screenSpecs.size.width,context);
              } else {
                return Text("No Data!");
              }
            },
          ),
          FutureBuilder(
            future: apiCall(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return create_container(
                    snapshot.data![1].image,
                    snapshot.data![1].name,
                    snapshot.data![1].metacritic,
                    snapshot.data![1].genre,
                    screenSpecs.size.height,
                    screenSpecs.size.width,context);
              } else {
                return Text("No Data!");
              }
            },
          ),
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

class FavoriteClick{
  final String imgPath, gameName, metacritic,genre;
  final double screenHeight;
  final double screenWidth;
  final BuildContext context;

const FavoriteClick(
    this.imgPath,
    this.gameName,
    this.metacritic,
    this.genre,
    this.screenHeight,
    this.screenWidth,
    this.context);
}


class UserClick{
  final String gameName,gameImageURL;

  const UserClick(
      this.gameName,
      this.gameImageURL
      );
}



class DetailPage extends StatefulWidget {

  final UserClick value;

  const DetailPage({Key? key, required this.value}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
   bool _isFavorited = false;

   void _toggleFavorite(){
    setState(() {
      if(_isFavorited){
        _isFavorited=false;
      }
      else{
        _isFavorited = true;
      }
    });
}

  @override
  Widget build(BuildContext context) {

    var screenSpecs = MediaQuery.of(context);
    var screenHeight = screenSpecs.size.height;
    var screenWidth = screenSpecs.size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          onPressed: () {Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => MyHomePage(title: "Games")));},
              color: Colors.black),
        title:Text("Games",style: TextStyle(
          fontSize: 25,color:Colors.black),
        ),
      ),
        body:ListView(
          children: [
            Column(
            children: [
              Stack(alignment: Alignment.bottomLeft,
                  children:[
                    SizedBox(width: screenWidth,height: screenHeight/3,
                  child: FittedBox(fit:BoxFit.fill,child: Image.network(widget.value.gameImageURL)),),
                  Align(alignment: Alignment.centerRight,
                    child: Padding(padding: EdgeInsets.only(bottom: 15,right: 15),
                      child: Text(widget.value.gameName,style: TextStyle(
                        fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white,
                      ),),
                    ),
                  ),
                ]
              ),
              Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                   Align(alignment: Alignment.centerLeft,
                     child: Padding(padding: EdgeInsets.only(top:15,left: 15),
                       child: Text("Game Description",
                         style:TextStyle(
                             fontSize: 30,fontWeight: FontWeight.w300
                         ),
                       ),
                     ),
                   ),
                   Padding(padding: EdgeInsets.only(top:15),
                     child: Container(width:50,height:50,
                         child: IconButton(onPressed:(){_toggleFavorite();},alignment: Alignment.center ,icon:(_isFavorited ? const Icon(Icons.favorite) : const Icon(Icons.favorite_border)))),
                   )
                 ],
                 )
                ,SizedBox(width: screenWidth,height: screenHeight/4,
                    child: Align(alignment: Alignment.center,
                      child: Padding(padding: EdgeInsets.only(left:13),
                        child: Text("Hiç internette otel aradınız mı? Trivago sizi büyük bir yükten kurtararak , 200'den fazla website ve uygulama üzerinden 700.000'den fazla otelin fiyatlarını anında karşılaştırır. Böylelikle ideal otelinizi en uygun fiyata bulduğunuzdan emin olabilirsiniz. Otel mi? Trivago.",
                          textAlign: TextAlign.start,
                          style:TextStyle(
                            height: 2.2,
                            fontWeight: FontWeight.w500
                          )
                        ,),
                      ),
                    )
                )
              ],

              ),
              Padding(padding:EdgeInsets.only(left: 15),
                child: SizedBox(width: screenWidth,height: screenHeight/8,
                    child:Align(alignment: Alignment.centerLeft,
                      child:
                        Text("Visit Reddit",textAlign: TextAlign.start,style: TextStyle(
                        color:Colors.blue,
                        fontWeight: FontWeight.w300,
                        fontSize: 30
                        ),
                      ),
                    )
                ),
              ),
              Padding(padding:EdgeInsets.only(left: 15),
                child: SizedBox(width: screenWidth,height: screenHeight/8,
                    child:Align(alignment: Alignment.centerLeft,
                      child:
                      Text("Visit Website",textAlign: TextAlign.start,style: TextStyle(
                          color:Colors.blue,
                          fontWeight: FontWeight.w300,
                          fontSize: 30
                      ),
                      ),
                    )
                ),
              )
            ],
      ),
          ],
        )
    );
  }
}
