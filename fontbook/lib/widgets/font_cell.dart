import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class FontCell extends StatefulWidget {
  FontCell({required this.text, required this.fontName, required this.favorited});

  final String text;
  final String fontName;
  bool favorited;

  @override
  State<FontCell> createState() => _FontCellState();
}

class _FontCellState extends State<FontCell> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(10)
            ),
            height: 70,
            child: Center(
              child: Text(
                  widget.text,
                  style: GoogleFonts.getFont(widget.fontName).copyWith(
                      fontSize: 18
                  )
              ),
            ),
          ),
          Positioned(
            top: -10,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  color: Theme.of(context).backgroundColor,
                  child: Text(widget.fontName, style: Theme.of(context).textTheme.headline3,)
              ),
            ),
          ),
          Positioned(
            top: -20,
            right: 10,
            child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Container(
                  color: Colors.white,
                  child: IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    icon: Icon(
                        widget.favorited ? Icons.favorite : Icons.favorite_border,
                        color: Colors.black
                    ),
                    onPressed: () {
                      setState(() {
                        widget.favorited = !widget.favorited;
                      });
                    },
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }
}