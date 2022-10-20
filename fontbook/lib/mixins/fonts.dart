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

  Future<List<Tuple<String, bool>>> getFontDataMatchingQuery(String uid, String query, List<String> allFonts) async {
    List<String> searchedFonts = [];
    for (int i = 0; i < allFonts.length; i += 1) {
      if (allFonts[i].toLowerCase().contains(query.toLowerCase())) {
        searchedFonts.add(allFonts[i]);
      }
    }
    List<String> favoritedFonts = await getFavoritedFonts(uid);
    List<Tuple<String, bool>> fontData = [];
    for (int i = 0; i < searchedFonts.length; i += 1) {
      fontData.add(Tuple(
          first: searchedFonts[i],
          second: favoritedFonts.contains(searchedFonts[i])
      ));
    }
    return fontData;
  }

  void changeFavoriteStatus(String uid, String fontid, bool favorited) async {
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