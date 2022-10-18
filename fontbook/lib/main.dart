import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:fontbook/mixins/fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:fontbook/auth/pages/login.dart';
import 'package:fontbook/widgets/font_cell.dart';

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
          )
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

class _HomePageState extends State<HomePage> with FontUtils {

  String sampleText = "Ready, set, launch!";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: getAllFontNames(),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.hasData) {
          List<String> fonts = snapshot.data!;
          return Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                IconButton(
                  onPressed: () {
                    // Navigator.of(context).push(
                    //   CupertinoPageRoute(
                    //     fullscreenDialog: true,
                    //     builder: (context) => SearchPage(),
                    //   ),
                    // );
                  },
                  icon: const Icon(
                    Icons.search_rounded,
                    color: Colors.black,
                    size: 28,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          fullscreenDialog: true,
                          builder: (context) => LoginPage(),
                        ),
                      );
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
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextField(
                            style: Theme.of(context).textTheme.bodyText1,
                            decoration: InputDecoration(
                              hintText: "Enter example sentence"
                            ),
                            onSubmitted: (text) {
                              setState(() {
                                if (text == null || text.trim().isEmpty) {
                                  sampleText = "Ready, set, launch!";
                                } else { sampleText = text; }
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
                  fontName: fonts[i],
                  favorited: false,
                );
              },
            ),
          );
        } else { return Container(color: Colors.black); }
      }
    );
  }
}
