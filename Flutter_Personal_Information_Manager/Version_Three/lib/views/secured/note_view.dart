/*
 * 2021.01.08  - Created
 * 
 */

//Some ideas from https://medium.com/aubergine-solutions/creating-a-note-taking-app-in-flutter-dart-f50852993cd0

import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../view_properties.dart';
import 'package:provider/provider.dart';
import '../../services/sqldb_service.dart' as dao;

class NoteView extends StatefulWidget {
  final Note _note;

  NoteView(this._note);

  @override
  _NoteViewState createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _bodyFocus = FocusNode();
  final GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();
  //
  Color _color;
  //
  bool _requiresSave = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget._note.title;
    _contentController.text = widget._note.body;
    _color = Color(widget._note.color.value);
  }

  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _titleFocus.dispose();
    _bodyFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        key: _globalKey,
        appBar: AppBar(
          brightness: Brightness.light,
          leading: BackButton(
              //color: Colors.black,
              ),
          actions: _appBarActions(context),
          //elevation: 1,
          //backgroundColor:_safeEditNote.color,
          title: Text(widget._note.id == null ? 'New Note' : 'Edit Note'),
        ),
        body: _body(context),
      ),
      onWillPop: () async => true,
    );
  }

  List<Widget> _appBarActions(BuildContext context) {
    List<Widget> actions = [];
    actions.add(Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        child: GestureDetector(
          onTap: _requiresSave ? () => _saveNoteObject(context) : null,
          child: Icon(
            Icons.save,
            color: _requiresSave ? Colors.white : ViewProperties.FONT_COLOR,
          ),
        ),
      ),
    ));

    actions.add(Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        child: GestureDetector(
          onTap: () => showModalBottomSheet(
              context: context,
              builder: (BuildContext ctx) {
                return MoreNoteOptionsView(
                  color: _color,
                  colorTappedHandler: _changeColor,
                  optionTappedHandler: _moreOptionsTapHandler,
                  //edited: _safeEditNote.edited,
                );
              }),
          child: Icon(
            Icons.more_vert,
            //color: ViewProperties.FONT_COLOR,
          ),
        ),
      ),
    ));

    actions.add(Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        child: GestureDetector(
          onTap: _requiresSave ? () => _saveAndStartNewNote(context): null,
          child: Icon(
            Icons.add,
            //color: ViewProperties.FONT_COLOR,
          ),
        ),
      ),
    ));

    return actions;
  }

  Widget _body(BuildContext ctx) {
    return Container(
        decoration: BoxDecoration(border: Border.all(color: _color, width: 2) /*,borderRadius: BorderRadius.all(Radius.circular(10))*/),
        padding: EdgeInsets.only(left: 10, right: 10, top: 5),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: Container(
                    padding: EdgeInsets.all(5),
                    ////decoration: BoxDecoration(border: Border.all(color: ViewProperties.BORDER_COLOR,width: 1 ),borderRadius: BorderRadius.all(Radius.circular(10)) ),
                    child: TextField(
                      onChanged: (str) => _setRequiresSave(),
                      maxLines: null, // line limit extendable later
                      controller: _titleController,
                      focusNode: _titleFocus,
                      style: TextStyle(/*color: Colors.black,*/ fontSize: 22, fontWeight: FontWeight.bold),
                      cursorColor: Colors.blue,
                      //decoration: BoxDecoration(border: Border.all(color: ViewProperties.BORDER_COLOR,width: 1),borderRadius: BorderRadius.all(Radius.circular(10)) ),
                    )),
              ),
              Flexible(
                  child: Container(
                      padding: EdgeInsets.all(5),
                      child: TextField(
                        onChanged: (str) => _setRequiresSave(),
                        keyboardType: TextInputType.multiline,
                        maxLines: null, // line limit extendable later
                        controller: _contentController,
                        focusNode: _bodyFocus,
                        style: TextStyle(/*color: Colors.black,*/ fontSize: 20),
                        cursorColor: Colors.blue,
                        //decoration: BoxDecoration(border: Border.all(color: ViewProperties.BORDER_COLOR,width: 1),borderRadius: BorderRadius.all(Radius.circular(10)) ),
                      )))
            ],
          ),
          left: true,
          right: true,
          top: false,
          bottom: false,
        ));
  }

  void _changeColor(Color newColorSelected) {
    setState(() {
      _requiresSave = true;
      _color = newColorSelected;
    });
  }

  void _saveAndStartNewNote(BuildContext context) {
    _saveNoteObject(context);

    Note newNote = Note(null, 'Title', 'Body', DateTime.now(), DateTime.now(), Colors.blue, false);
    Navigator.of(context).pop();
    Navigator.push(context, MaterialPageRoute(builder: (ctx) => NoteView(newNote)));
  }

  void _saveNoteObject(BuildContext ctx) {
    widget._note.body = _contentController.text;
    widget._note.title = _titleController.text;
    widget._note.color = Color(_color.value);

    widget._note.edited = DateTime.now();

    dao.EntityChangeManager<Note> ncm = Provider.of<dao.EntityChangeManager<Note>>(ctx, listen: false);
    if (widget._note.id != null) {
      ncm.updateEntity(widget._note, true);
    } else {
      ncm.insertEntity(widget._note);
    }

    setState(() => _requiresSave = false);
  }

  void _setRequiresSave() {
    setState(() => _requiresSave = true);
  }

  void _moreOptionsTapHandler(MoreOptions tappedOption) {
    switch (tappedOption) {
      case MoreOptions.DELETE:
        if (widget._note.id != null) {
          _deleteNote(_globalKey.currentContext);
        } else {
          _exitWithoutSaving(context);
        }
        break;
      case MoreOptions.SHARE:
        // if (_editableNote.content.isNotEmpty) {
        //     Share.share("${_editableNote.title}\n${_editableNote.content}"); //requires share package
        //   }
        break;
      case MoreOptions.COPY:
        //_copy();
        break;
    }
  }

  void _exitWithoutSaving(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _deleteNote(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Confirm ?"),
            content: Text("This note will be deleted permanently"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    dao.EntityChangeManager<Note> ncm = Provider.of<dao.EntityChangeManager<Note>>(context, listen: false);
                    Navigator.of(context).pop();
                    ncm.deleteEntity(widget._note);
                    Navigator.of(context).pop();
                  },
                  child: Text("Yes")),
              FlatButton(onPressed: () => {Navigator.of(context).pop()}, child: Text("No"))
            ],
          );
        });
  }
}

enum MoreOptions { DELETE, SHARE, COPY }

class MoreNoteOptionsView extends StatefulWidget {
  final Color color;
  //final DateTime edited;
  final void Function(MoreOptions) optionTappedHandler;
  final void Function(Color) colorTappedHandler;

  MoreNoteOptionsView({Key key, this.color, /*this.edited,*/ this.colorTappedHandler, this.optionTappedHandler}) : super(key: key);
  @override
  _MoreNoteOptionsViewState createState() => _MoreNoteOptionsViewState();
}

class _MoreNoteOptionsViewState extends State<MoreNoteOptionsView> {
  var color;

  @override
  void initState() {
    super.initState();
    color = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: new Wrap(
        children: <Widget>[
          new ListTile(
              leading: new Icon(Icons.delete),
              title: new Text('Delete permanently'),
              onTap: () {
                Navigator.of(context).pop();
                widget.optionTappedHandler(MoreOptions.DELETE);
              }),
          new ListTile(
              leading: new Icon(Icons.content_copy),
              title: new Text('Duplicate'),
              onTap: () {
                Navigator.of(context).pop();
                widget.optionTappedHandler(MoreOptions.COPY);
              }),
          new ListTile(
              leading: new Icon(Icons.share),
              title: new Text('Share'),
              onTap: () {
                Navigator.of(context).pop();
                widget.optionTappedHandler(MoreOptions.SHARE);
              }),
          new Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: SizedBox(
              height: 44,
              width: MediaQuery.of(context).size.width,
              child: ColorSlider(
                colorTappedHandler: _changeColor,
                noteColor: color,
              ),
            ),
          ),
          // new Row(
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     SizedBox(
          //       height: 44,
          //       child: Center(child: Text(CentralStation.stringForDatetime(widget.edited))),
          //     )
          //   ],
          //   mainAxisAlignment: MainAxisAlignment.center,
          // ),
          new ListTile()
        ],
      ),
    );
  }

  void _changeColor(Color color) {
    setState(() {
      this.color = color;
      widget.colorTappedHandler(color);
    });
  }
}

class ColorSlider extends StatefulWidget {
  final void Function(Color) colorTappedHandler;
  final Color noteColor;

  ColorSlider({@required this.colorTappedHandler, @required this.noteColor});

  @override
  _ColorSliderState createState() => _ColorSliderState();
}

class _ColorSliderState extends State<ColorSlider> {
  final colors = [
    Colors.blue, // classic blue
    Color(0xfff28b81), // light pink
    Color(0xfff7bd02), // yellow
    Color(0xfffbf476), // light yellow
    Color(0xffcdff90), // light green
    Color(0xffa7feeb), // turquoise
    Color(0xffcbf0f8), // light cyan
    Color(0xffafcbfa), // light blue
    Color(0xffd7aefc), // plum
    Color(0xfffbcfe9), // misty rose
    Color(0xffe6c9a9), // light brown
    Color(0xffe9eaee) // light gray
  ];

  final Color borderColor = Color(0xffd3d3d3);
  final Color foregroundColor = Color(0xff595959);

  final Icon _check = Icon(Icons.check);

  Color noteColor;
  int indexOfCurrentColor;

  @override
  void initState() {
    super.initState();
    this.noteColor = widget.noteColor;
    indexOfCurrentColor = colors.indexOf(noteColor);
  }

  @override
  Widget build(BuildContext context) {
    // return Container();
    return ListView(
      scrollDirection: Axis.horizontal,
      children: List.generate(colors.length, (index) {
        return GestureDetector(
            onTap: () => _colorChangeTapped(index),
            child: Padding(
                padding: EdgeInsets.only(left: 6, right: 6),
                child: Container(
                    child: new CircleAvatar(
                      child: _checkOrNot(index),
                      foregroundColor: foregroundColor,
                      backgroundColor: colors[index],
                    ),
                    width: 38.0,
                    height: 38.0,
                    padding: const EdgeInsets.all(1.0), // border width
                    decoration: new BoxDecoration(
                      color: borderColor, // border color
                      shape: BoxShape.circle,
                    ))));
      }),
    );
  }

  void _colorChangeTapped(int indexOfColor) {
    setState(() {
      noteColor = colors[indexOfColor];
      indexOfCurrentColor = indexOfColor;
      widget.colorTappedHandler(colors[indexOfColor]);
    });
  }

  Widget _checkOrNot(int index) {
    if (indexOfCurrentColor == index) {
      return _check;
    }
    return null;
  }
}
