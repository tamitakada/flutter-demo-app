import 'package:flutter/material.dart';
import 'package:fontbook/mixins/fonts.dart';
import 'package:fontbook/widgets/font_cell.dart';
import 'package:fontbook/auth/mixins/auth.dart';
import 'package:fontbook/models/tuple.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with FontUtils, Auth {

  String query = "";
  List<String> allFonts = [];

  Future<List<Tuple<String, bool>>> getUidAndFontsList() async {
    String uid = await getUidIfUserIsLoggedIn();
    allFonts = await getAllFontNames();
    return await getFontDataMatchingQuery(uid, query, allFonts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<List<Tuple<String, bool>>>(
        future: getUidAndFontsList(),
        builder: (BuildContext context, AsyncSnapshot<List<Tuple<String, bool>>> snapshot) {
          if (snapshot.hasData) {
            List<Tuple<String, bool>> fonts = snapshot.data!;
            return ListView.builder(
              itemCount: fonts.length + 1,
              itemBuilder: (BuildContext context, int i) {
                if (i == 0) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: Column(
                      children: [
                        Text(
                          "SEARCH",
                          style: Theme.of(context).textTheme.headline1,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextField(
                            style: Theme.of(context).textTheme.bodyText1,
                            decoration: const InputDecoration(
                              hintText: "Search for a font"
                            ),
                            onSubmitted: (text) {
                              setState(() { query = text; });
                            }
                          )
                        ),
                      ],
                    ),
                  );
                } else {
                  return FontCell(
                    text: fonts[i - 1].first,
                    fontName: fonts[i - 1].first,
                    showFavorited: true,
                    favorited: fonts[i - 1].second,
                  );
                }
              },
            );
          } else {
            return Container(color: Colors.white,);
          }
        },
      ),
    );
  }
}
