import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'favorites_view.dart';
import 'app_bar.dart';
import 'api_fetch.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Step 3
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(const MyApp()));
  runApp(const MyApp());
}

List<LoadData> postList = [];

Future<List<LoadData>> apiCall() async {
  postList.clear();
  final response = await http.get(
      Uri(scheme: "https", host: "hi2media.com", path: "/asset/games.json"));
  var data = jsonDecode(response.body.toString());

  for (Map i in data) {
    postList.add(LoadData.fromJson(i));
  }

  //print('${postList.length} runpaç');
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
        '/favorites': (context) => FavoritesView(),
        '/DetailPage': (context) => const DetailPage(
              value: UserClick(" ", " "),
            )
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
  late TextEditingController searchController;
  int currentIndex =
      0; //We hold a currentIndex variable so we can track our page index.
  List<LoadData> searchDatas = [];
  List<LoadData> datas = [];
  @override
  void initState() {
    searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSpecs = MediaQuery.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TopAppBar(
                PageName: 'Games', textEditingController: searchController),
            FutureBuilder(
              future: apiCall(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (datas.isNotEmpty) {
                    print('IS not EMPTY');
                  } else if (datas.isEmpty) {
                    print('IS EMPTY');
                    datas = [];
                    datas = snapshot.data as List<LoadData>;
                    //remove duplicates from datas
                    datas = datas.toSet().toList();
                  }

                  if (searchController.text.isEmpty) {
                    searchDatas = datas;
                  }
                  searchController.addListener(() {
                    if (searchController.text.isNotEmpty) {
                      if (searchController.text.length > 3) {
                        for (var i = 0; i < datas.length; i++) {
                          //search if datas contain the searchcontroller.text
                          setState(() {
                            searchDatas = datas
                                .where((element) => element.name
                                    .toLowerCase()
                                    .contains(searchController.text))
                                .toList();
                          });
                        }
                      } else {
                        setState(() {
                          searchDatas = [];
                          searchDatas = datas;
                        });

                        print('adflkgjaşldfkjgş ${searchDatas.length}');
                      }
                    } else {
                      setState(() {
                        searchDatas = [];
                        searchDatas = datas;
                      });
                    }
                  });

                  //remove the duplicates from searchDatas
                  //searchDatas = searchDatas.toSet().toList();

                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: searchDatas.length,
                    itemBuilder: (context, index) {
                      return create_container(
                          searchDatas[index].image,
                          searchDatas[index].name,
                          searchDatas[index].metacritic,
                          searchDatas[index].genre,
                          screenSpecs.size.height,
                          screenSpecs.size.width,
                          context);
                    },
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
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

class FavoriteClick {
  final String imgPath, gameName, metacritic, genre;
  final double screenHeight;
  final double screenWidth;
  final BuildContext context;

  const FavoriteClick(this.imgPath, this.gameName, this.metacritic, this.genre,
      this.screenHeight, this.screenWidth, this.context);
}

class UserClick {
  final String gameName, gameImageURL;

  const UserClick(this.gameName, this.gameImageURL);
}

class DetailPage extends StatefulWidget {
  final UserClick value;

  static List<UserClick> favoriteNameList = [];

  const DetailPage({Key? key, required this.value}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool _isFavorited = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var i = 0; i < DetailPage.favoriteNameList.length; i++) {
      if (DetailPage.favoriteNameList[i].gameName == widget.value.gameName) {
        _isFavorited = true;
      } else {
        if (i < DetailPage.favoriteNameList.length - 1) {
          _isFavorited = false;
        }
      }
    }
  }

  void _toggleFavorite() {
    if (DetailPage.favoriteNameList.isNotEmpty) {
      for (var i = 0; i < DetailPage.favoriteNameList.length; i++) {
        if (DetailPage.favoriteNameList[i].gameName == widget.value.gameName) {
          setState(() {
            _isFavorited = false;
          });
          DetailPage.favoriteNameList.removeAt(i);
          break;
        } else {
          if (i == DetailPage.favoriteNameList.length - 1) {
            DetailPage.favoriteNameList.add(
                UserClick(widget.value.gameName, widget.value.gameImageURL));
            setState(() {
              _isFavorited = true;
            });
            break;
          }
        }
      }
    } else {
      DetailPage.favoriteNameList
          .add(UserClick(widget.value.gameName, widget.value.gameImageURL));
      setState(() {
        _isFavorited = true;
      });
    }
  }

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    var screenSpecs = MediaQuery.of(context);
    var screenHeight = screenSpecs.size.height;
    var screenWidth = screenSpecs.size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MyHomePage(title: "Games")));
            },
            color: Colors.black),
        title: Text(
          "Games",
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              Stack(alignment: Alignment.bottomLeft, children: [
                SizedBox(
                  width: screenWidth,
                  height: screenHeight / 3,
                  child: FittedBox(
                      fit: BoxFit.fill,
                      child: Image.network(widget.value.gameImageURL)),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 15, right: 15),
                    child: Text(
                      widget.value.gameName,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ]),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(top: 15, left: 15),
                          child: Text(
                            "Game Description",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Container(
                            width: 50,
                            height: 50,
                            child: IconButton(
                                onPressed: () {
                                  _toggleFavorite();
                                },
                                alignment: Alignment.center,
                                icon: (_isFavorited
                                    ? const Icon(Icons.favorite)
                                    : const Icon(Icons.favorite_border)))),
                      )
                    ],
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(left: 13),
                      child: Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Imperdiet proin fermentum leo vel orci porta non pulvinar. Urna cursus eget nunc scelerisque. Adipiscing at in tellus integer feugiat scelerisque varius morbi. Et odio pellentesque diam volutpat. Eu tincidunt tortor aliquam nulla facilisi cras fermentum odio eu. Luctus accumsan tortor posuere ac ut consequat semper. Massa tincidunt nunc pulvinar sapien et. Duis at tellus at urna condimentum mattis pellentesque id nibh. Arcu odio ut sem nulla pharetra diam sit. Facilisi cras fermentum odio eu feugiat pretium nibh ipsum consequat. Posuere urna nec tincidunt praesent semper feugiat nibh sed pulvinar. Velit laoreet id donec ultrices tincidunt arcu non. Augue lacus viverra vitae congue eu consequat ac felis. Facilisi morbi tempus iaculis urna id volutpat lacus laoreet. Non nisi est sit amet facilisis magna etiam tempor orci. Scelerisque eu ultrices vitae auctor eu augue ut lectus arcu. Ac auctor augue mauris augue neque gravida. Et ultrices neque ornare aenean euismod elementum nisi. Sed enim ut sem viverra aliquet eget sit amet. Cras sed felis eget velit aliquet sagittis. Nisl tincidunt eget nullam non. Tempor orci dapibus ultrices in iaculis nunc sed. Amet nisl purus in mollis nunc sed id semper risus. Scelerisque felis imperdiet proin fermentum leo vel. Elementum integer enim neque volutpat. Sed vulputate odio ut enim blandit volutpat maecenas volutpat blandit. Viverra nam libero justo laoreet. Id porta nibh venenatis cras. Lacinia at quis risus sed. Maecenas volutpat blandit aliquam etiam erat velit scelerisque in dictum. Pharetra sit amet aliquam id diam. Blandit massa enim nec dui nunc mattis enim. Hac habitasse platea dictumst quisque sagittis purus sit. Aenean pharetra magna ac placerat vestibulum lectus mauris ultrices eros. At ultrices mi tempus imperdiet nulla malesuada pellentesque elit. Faucibus nisl tincidunt eget nullam non nisi. Tincidunt eget nullam non nisi est sit amet facilisis. Mattis pellentesque id nibh tortor. Eu sem integer vitae justo eget magna fermentum iaculis. Venenatis tellus in metus vulputate eu scelerisque. Semper eget duis at tellus at. Ullamcorper malesuada proin libero nunc consequat interdum varius. A arcu cursus vitae congue mauris. Tellus in hac habitasse platea. Morbi enim nunc faucibus a pellentesque. Morbi tincidunt ornare massa eget egestas purus viverra. Sem et tortor consequat id porta nibh venenatis cras sed. Ipsum nunc aliquet bibendum enim facilisis. Mauris a diam maecenas sed enim ut sem viverra. Faucibus purus in massa tempor nec. Id interdum velit laoreet id donec ultrices tincidunt arcu. Eu scelerisque felis imperdiet proin fermentum. Pellentesque pulvinar pellentesque habitant morbi tristique senectus. Lorem ipsum dolor sit amet consectetur adipiscing elit pellentesque. Enim neque volutpat ac tincidunt. Tincidunt praesent semper feugiat nibh sed pulvinar proin gravida. Neque laoreet suspendisse interdum consectetur libero. A diam sollicitudin tempor id eu nisl nunc mi ipsum. Nulla facilisi cras fermentum odio. Congue eu consequat ac felis donec et. Turpis massa sed elementum tempus egestas sed sed risus pretium. Ornare massa eget egestas purus viverra accumsan in nisl. Id faucibus nisl tincidunt eget nullam non. Dui vivamus arcu felis bibendum ut tristique. Tortor consequat id porta nibh. Non blandit massa enim nec dui nunc mattis enim ut. Malesuada fames ac turpis egestas. Cras sed felis eget velit aliquet sagittis id consectetur purus. Habitant morbi tristique senectus et netus et malesuada fames ac. Lorem ipsum dolor sit amet consectetur adipiscing elit pellentesque. Eu mi bibendum neque egestas congue. Nunc scelerisque viverra mauris in. Malesuada bibendum arcu vitae elementum. Sollicitudin ac orci phasellus egestas tellus rutrum tellus. Diam ut venenatis tellus in metus vulputate eu. Mattis pellentesque id nibh tortor id aliquet lectus. Nunc sed blandit libero volutpat sed. Leo a diam sollicitudin tempor. Id eu nisl nunc mi ipsum faucibus vitae aliquet nec. Morbi enim nunc faucibus a pellentesque sit amet porttitor. Aliquet bibendum enim facilisis gravida neque convallis. Enim diam vulputate ut pharetra sit. Commodo viverra maecenas accumsan lacus vel facilisis volutpat est. Imperdiet massa tincidunt nunc pulvinar sapien et ligula. Orci eu lobortis elementum nibh tellus. Integer quis auctor elit sed. Facilisis leo vel fringilla est ullamcorper eget nulla. Sit amet risus nullam eget felis. Eu sem integer vitae justo eget magna.",
                        maxLines: isExpanded ? 99 : 4,
                        overflow: isExpanded ? TextOverflow.ellipsis : null,
                        textAlign: TextAlign.start,
                        style:
                            TextStyle(height: 2.2, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  isExpanded
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  isExpanded = !isExpanded;
                                });
                              },
                              child: Text('Read Less')))
                      : Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  isExpanded = true;
                                });
                              },
                              child: Text('Read More'))),
                ],
              ),
              InkWell(
                onTap: () {
                  //open the browser page //https://www.reddit.com/r/GTAV/

                  launchUrl(Uri(
                      scheme: "https",
                      host: "www.reddit.com",
                      path: widget.value.gameName == 'Grand Theft Auto V'
                          ? "/r/GTAV/"
                          : '/r/BATTLEFIELD_ONE/'));
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: SizedBox(
                      width: screenWidth,
                      height: screenHeight / 8,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Visit Reddit",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w300,
                              fontSize: 30),
                        ),
                      )),
                ),
              ),
              InkWell(
                onTap: () {
                  //open the browser page
                  launchUrlString(widget.value.gameName == 'Grand Theft Auto V'
                      ? "https://www.rockstargames.com/gta-v"
                      : "https://www.ea.com/games/battlefield/battlefield-1");
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: SizedBox(
                      width: screenWidth,
                      height: screenHeight / 8,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Visit Website",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w300,
                              fontSize: 30),
                        ),
                      )),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
