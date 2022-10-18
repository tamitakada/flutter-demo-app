import 'package:flutter/services.dart';
import 'package:fontbook/models/tuple.dart';

mixin FontUtils {

  Future<List<String>> getAllFontNames() async {
    String fileText = await rootBundle.loadString('assets/google_fonts_list.txt');
    return fileText.split("\n");
  }

  Future<List<Tuple<String, bool>>> getFontsAndFavoriteStatus() async {
    List<String> allFonts = await getAllFontNames();
    return [];
  }

}