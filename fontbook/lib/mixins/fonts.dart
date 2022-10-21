import 'package:flutter/services.dart';
import 'package:fontbook/models/tuple.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

mixin FontUtils {

  static final db = FirebaseFirestore.instance;

  Future<List<String>> getAllFontNames() async {
    String fileText = await rootBundle.loadString('assets/google_fonts_list.txt');
    return fileText.split("\n");
  }

  Future<List<String>> getFavoritedFonts(String uid) async {
    final fonts = await db.collection("savedFonts").where("uid", isEqualTo: uid);
    List<String> fontNames = [];
    await fonts.get().then(
      (res) {
        for (int i = 0; i < res.docs.length; i+= 1) {
          fontNames.add(res.docs[i]["fontid"]);
        }
      },
      onError: (e) => print("Error getting document: $e")
    );
    return fontNames;
  }

  Future<List<Tuple<String, bool>>> getFontsWithFavoriteData(String uid) async {
    List<String> fonts = await getAllFontNames();
    List<String> favorites = await getFavoritedFonts(uid);
    List<Tuple<String, bool>> data = [];
    for (int i = 0; i < fonts.length; i += 1) {
      data.add(
        Tuple(first: fonts[i], second: favorites.contains(fonts[i]))
      );
    }
    return data;
  }

  Future<List<Tuple<String, bool>>> getFontDataMatchingQuery(String uid, String query, List<Tuple<String, bool>> allFonts) async {
    List<Tuple<String, bool>> searchedFonts = [];
    for (int i = 0; i < allFonts.length; i += 1) {
      if (allFonts[i].first.toLowerCase().contains(query.toLowerCase())) {
        searchedFonts.add(Tuple(first: allFonts[i].first, second: allFonts[i].second));
      }
    }
    return searchedFonts;
  }
  
  Future<bool> isFontFavorited(String uid, String fontid) async {
    final savedFonts = await db.collection("savedFonts")
      .where("uid", isEqualTo: uid)
      .where("fontid", isEqualTo: fontid)
      .get();
    return savedFonts.docs.isNotEmpty;
  }

  Future<void> changeFavoriteStatus(String uid, String fontid, bool favorited) async {
    if (favorited) {
      await db.collection("savedFonts")
          .add({"uid": uid, "fontid": fontid});
      print("add done");
    } else {
      final savedFont = await db.collection("savedFonts")
          .where("uid", isEqualTo: uid).where("fontid", isEqualTo: fontid);
      await savedFont.get().then(
              (res) {
            if (res.docs.isNotEmpty) {
              db.collection("savedFonts").doc(res.docs[0].id).delete().then(
                    (doc) => print("Document deleted"),
                onError: (e) => print("Error updating document $e"),
              );
            }
          }
      );
    }
  }

}