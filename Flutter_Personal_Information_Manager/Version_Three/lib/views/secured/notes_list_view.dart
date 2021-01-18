/*
 * 2021.01.08  - Created
 * 
 */

//Some ideas from https://medium.com/aubergine-solutions/creating-a-note-taking-app-in-flutter-dart-f50852993cd0

import '../../models/models.dart';
import '../view_properties.dart';
import 'note_view.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../services/sqldb_service.dart' as dao;
import 'package:provider/provider.dart';

enum ViewType { List, Staggered }

class NotesGridPage extends StatefulWidget {
  final ViewType notesViewType;

  NotesGridPage(this.notesViewType);

  @override
  _NotesGridPageState createState() => _NotesGridPageState();
}

class _NotesGridPageState extends State<NotesGridPage> {
  @override
  Widget build(BuildContext context) {
    GlobalKey _stagKey = GlobalKey();
    return Container(
      child: Padding(
          padding: _paddingForView(context),
          child: StaggeredGridView.count(
            key: _stagKey,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            crossAxisCount: _colsForStaggeredView(context),
            children: context.watch<dao.EntityChangeManager<Note>>().entities.map((e) => NotesGridPageTile(e)).toList(),
            staggeredTiles: context.watch<dao.EntityChangeManager<Note>>().entities.map((e) => StaggeredTile.fit(1)).toList(),
          )),
    ); //can also use MultiProvider here!
  }

  EdgeInsets _paddingForView(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double padding;
    double topBottom = 8;
    if (width > 500) {
      padding = (width) * 0.05; // 5% padding of width on both side
    } else {
      padding = 8;
    }
    return EdgeInsets.only(left: padding, right: padding, top: topBottom, bottom: topBottom);
  }

  int _colsForStaggeredView(BuildContext context) {
    if (widget.notesViewType == ViewType.List) {
      return 1;
    }
    // for width larger than 600 on grid mode, return 3 irrelevant of the orientation to accommodate more notes horizontally
    return MediaQuery.of(context).size.width > 600 ? 3 : 2;
  }
}

class NotesGridPageTile extends StatefulWidget {
  final Note _note;

  NotesGridPageTile(this._note);

  @override
  _NotesGridPageTileState createState() => _NotesGridPageTileState();
}

class _NotesGridPageTileState extends State<NotesGridPageTile> {
  double _fontSize; 

  @override
  Widget build(BuildContext context) {
    _fontSize = _determineFontSizeForContent();
    return GestureDetector(
      onTap: () => _cellTapped(context),
      child: Container(
        decoration: BoxDecoration(border: widget._note.color == Colors.white ? Border.all(color: ViewProperties.BORDER_COLOR) : null, color: widget._note.color, borderRadius: BorderRadius.all(Radius.circular(8))),
        padding: EdgeInsets.all(8),
        child: _constructChildren(),
      ),
    );
  }

  void _cellTapped(BuildContext ctx) {
    Navigator.push(ctx, MaterialPageRoute(builder: (ctx) => NoteView(widget._note)));
  }

  Widget _constructChildren() {
    List<Widget> contentsOfCell = [];
    if (widget._note.title.length != 0) {
      contentsOfCell.add(
        AutoSizeText(
          widget._note.title,
          style: TextStyle(fontSize: _fontSize, fontWeight: FontWeight.bold),
          maxLines: widget._note.title.length == 0 ? 1 : 3,
          textScaleFactor: 1.5,
        ),
      );
      contentsOfCell.add(
        Divider(
          color: Colors.transparent,
          height: 6,
        ),
      );
    }
    contentsOfCell.add(AutoSizeText(
      widget._note.body,
      style: TextStyle(fontSize: _fontSize),
      maxLines: 10,
      textScaleFactor: 1.5,
    ));
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: contentsOfCell);
  }

  double _determineFontSizeForContent() {
    int charCount = widget._note.body.length + widget._note.title.length;
    double fontSize = 20;
    if (charCount > 110) {
      fontSize = 12;
    } else if (charCount > 80) {
      fontSize = 14;
    } else if (charCount > 50) {
      fontSize = 16;
    } else if (charCount > 20) {
      fontSize = 18;
    }
    return fontSize;
  }
}
