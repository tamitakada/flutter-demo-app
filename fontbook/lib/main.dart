import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:fontbook/mixins/fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:fontbook/auth/pages/login.dart';
import 'package:fontbook/widgets/font_cell.dart';
import 'package:fontbook/favorites/favorites.dart';
import 'package:fontbook/auth/pages/register.dart';
import 'package:fontbook/auth/mixins/auth.dart';
import 'package:fontbook/models/tuple.dart';
import 'package:fontbook/search.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        '/favorites': (BuildContext context) => FavoritesPage(),
        '/register': (BuildContext context) => RegisterPage(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.white,
        textTheme: TextTheme(
          headline1: GoogleFonts.megrim(
            fontSize: 36,
            color: Colors.black
          ),
          headline3: GoogleFonts.zenMaruGothic(
            fontSize: 16,
            color: Colors.black
          ),
          bodyText1: GoogleFonts.zenMaruGothic(
              fontSize: 18,
              color: Colors.black
          ),
          bodyText2: GoogleFonts.megrim(
              fontSize: 20,
              color: Colors.black
          ),
        )
      ),
      home: const HomePage(title: 'FONTBOOK'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with FontUtils, Auth {

  String sampleText = "Ready, set, launch!";

  Future<Tuple<String, List<Tuple<String, bool>>>> getUidAndFontsList() async {
    String uid = await getUidIfUserIsLoggedIn();
    List<Tuple<String, bool>> allFonts = await getFontsWithFavoriteData(uid);
    return Tuple(first: uid, second: allFonts);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Tuple<String, List<Tuple<String, bool>>>>(
      future: getUidAndFontsList(),
      builder: (BuildContext context, AsyncSnapshot<Tuple<String, List<Tuple<String, bool>>>> snapshot) {
        if (snapshot.hasData) {
          String uid = snapshot.data!.first;
          List<Tuple<String, bool>> fonts = snapshot.data!.second;
          return Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => SearchPage(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.search_rounded,
                    color: Colors.black,
                    size: 28,
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      String uid = await getUidIfUserIsLoggedIn();
                      if (uid.isNotEmpty) {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => FavoritesPage(),
                          ),
                        );
                      } else {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => LoginPage(),
                          ),
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.star_border_rounded,
                      color: Colors.black,
                      size: 30,
                    )
                )
              ],
            ),
            body: ListView.builder(
              itemCount: fonts.length + 1,
              itemBuilder: (BuildContext context, int i) {
                if (i == 0) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: Column(
                      children: [
                        Text(
                          widget.title,
                          style: Theme
                              .of(context)
                              .textTheme
                              .headline1,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextField(
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyText1,
                            decoration: InputDecoration(
                                hintText: "Enter example sentence"
                            ),
                            onSubmitted: (text) {
                              setState(() {
                                if (text == null || text
                                    .trim()
                                    .isEmpty) {
                                  sampleText = "Ready, set, launch!";
                                } else {
                                  sampleText = text;
                                }
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  );
                }
                return FontCell(
                  text: sampleText,
                  fontName: fonts[i - 1].first,
                  showFavorited: uid.isNotEmpty,
                  favorited: fonts[i - 1].second,
                  callback: () {
                    fonts[i - 1].second = !fonts[i - 1].second;
                    changeFavoriteStatus(
                        uid,
                        fonts[i - 1].first,
                        fonts[i - 1].second
                    ).then((value) => { WidgetsBinding.instance
                        .addPostFrameCallback((_) => setState(() {})) });
                  }
                );
              }
            ),
          );
        } else {
          return Container(color: Colors.white,);
        }
      }
    );
  }
}
