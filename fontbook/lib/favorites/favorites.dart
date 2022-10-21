import 'package:flutter/material.dart';
import 'package:fontbook/mixins/fonts.dart';
import 'package:fontbook/widgets/font_cell.dart';
import 'package:fontbook/auth/mixins/auth.dart';
import 'package:fontbook/models/tuple.dart';

class FavoritesPage extends StatelessWidget with FontUtils, Auth {
  const FavoritesPage({Key? key}) : super(key: key);

  Future<Tuple<String, List<String>>> getUidAndFavoritedFonts() async {
    String uid = await getUidIfUserIsLoggedIn();
    return Tuple(first: uid, second: await getFavoritedFonts(uid));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Tuple<String, List<String>>>(
        future: getUidAndFavoritedFonts(),
        builder: (BuildContext context, AsyncSnapshot<Tuple<String, List<String>>> snapshot) {
          if (snapshot.hasData) {
            String uid = snapshot.data!.first;
            List<String> fonts = snapshot.data!.second;
            return Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.cancel_outlined, color: Colors.black, size: 28,),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              body: ListView.builder(
                itemCount: fonts.length + 1,
                itemBuilder: (BuildContext context, int i) {
                  if (i == 0) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                      child: Center(
                        child: Text(
                          "FAVORITE FONTS",
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                    );
                  }
                  return FontCell(
                    text: fonts[i - 1],
                    fontName: fonts[i - 1],
                    showFavorited: false,
                    favorited: true,
                    callback: () {},
                  );
                },
              ),
            );
          } else { return Container(color: Colors.white); }
        }
    );
  }
}
