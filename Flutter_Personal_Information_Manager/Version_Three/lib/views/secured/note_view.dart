/*
 * 2021.01.08  - Created
 * 
 */

//Some ideas from https://medium.com/aubergine-solutions/creating-a-note-taking-app-in-flutter-dart-f50852993cd0

import 'package:flutter/material.dart';
import '../../models/models.dart';
//import '../view_properties.dart';
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
  String initialTitle;
  String initialBody;

  //dao.NotesChangeManager

  @override
  void initState() {
    super.initState();
    _titleController.text = widget._note.title;
    _contentController.text = widget._note.body;
    initialTitle = widget._note.title;
    initialBody = widget._note.body;
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
    if (widget._note.id == null && widget._note.title.isEmpty) {
      FocusScope.of(context).requestFocus(_titleFocus);
    }
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
          //backgroundColor: widget._note.color,
          title: _viewTitle(),
        ),
        body: _body(context),
      ),
      onWillPop: _readyToPop,
    );
  }

  Widget _viewTitle() => Text(widget._note.id == null ? 'New Note' : 'Edit Note');

  List<Widget> _appBarActions(BuildContext context) {
    List<Widget> actions = [];
    if (widget._note.id != null) {
      // actions.add(Padding(
      //   padding: EdgeInsets.symmetric(horizontal: 5),
      //   child: InkWell(
      //     child: GestureDetector(
      //       //!onTap: () => _undo(),
      //       child: Icon(
      //         Icons.undo,
      //         color: ViewProperties.FONT_COLOR,
      //       ),
      //     ),
      //   ),
      // ));
    }
    actions.add(Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        child: GestureDetector(
          onTap: () => _saveNoteObject(context),
          child: Icon(
            Icons.save,
            //color: ViewProperties.FONT_COLOR,
          ),
        ),
      ),
    ));

    actions.add(Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: InkWell(
        child: GestureDetector(
          //!onTap: () => _archivePopup(context),
          child: Icon(
            Icons.archive,
            //color: ViewProperties.FONT_COLOR,
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
                  color: widget._note.color,
                  colorTappedHandler: _changeColor,
                  optionTappedHandler: _moreOptionsTapHandler,
                  edited: widget._note.edited,
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
          //!onTap: () => {_saveAndStartNewNote(context)},
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
        color: widget._note.color,
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
                      // onChanged: (str) => _updateNoteObject(ctx),
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
                        // onChanged: (str) => _updateNoteObject(ctx),
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

  Future<bool> _readyToPop() async {
    //!_persistenceTimer.cancel();
    //!_persistData();
    return true;
  }

  void _changeColor(Color newColorSelected) {
    //print("note color changed");
    setState(() {
      widget._note.color = newColorSelected;
    });
    //_persist();
  }

  void _saveNoteObject(BuildContext ctx) {
    widget._note.body = _contentController.text;
    widget._note.title = _titleController.text;

    if (!(widget._note.title == initialTitle && widget._note.body == initialBody) || (widget._note.id == null)) {
      // Change last edit time only if the title/body of the note is mutated wrt the note which the page was initialized with.
      widget._note.edited = DateTime.now();
      //! CentralStation.updateNeeded = true;
    }
    dao.NotesChangeManager ncm = Provider.of<dao.NotesChangeManager>(ctx, listen: false); //.insertNote(widget._note);
    if (widget._note.id != null) {
      ncm.updateNote(widget._note);
    } else {
      ncm.insertNote(widget._note);
    }
  }

  void _moreOptionsTapHandler(MoreOptions tappedOption) {
    switch (tappedOption) {
      case MoreOptions.DELETE:
        break;
      case MoreOptions.SHARE:
        break;
      case MoreOptions.COPY:
    }
  }

  // void _exitWithoutSaving(BuildContext context) {
  //   //!_persistenceTimer.cancel();
  //   Navigator.of(context).pop();
  // }

  // void _deleteNote(BuildContext context) {
  //   if (widget._note.id != null) {
  //     showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: Text("Confirm ?"),
  //             content: Text("This note will be deleted permanently"),
  //             actions: <Widget>[
  //               FlatButton(
  //                   onPressed: () {
  //                     //!_persistenceTimer.cancel();
  //                     var noteDB = NotesDBHandler();
  //                     Navigator.of(context).pop();
  //                     noteDB.deleteNote(_editableNote);
  //                     CentralStation.updateNeeded = true;

  //                     Navigator.of(context).pop();
  //                   },
  //                   child: Text("Yes")),
  //               FlatButton(onPressed: () => {Navigator.of(context).pop()}, child: Text("No"))
  //             ],
  //           );
  //         });
  //   }
  // }
}

enum MoreOptions { DELETE, SHARE, COPY }

class MoreNoteOptionsView extends StatefulWidget {
  final Color color;
  final DateTime edited;
  final void Function(MoreOptions) optionTappedHandler;
  final void Function(Color) colorTappedHandler;

  MoreNoteOptionsView({Key key, this.color, this.edited, this.colorTappedHandler, this.optionTappedHandler}) : super(key: key);
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
    Color(0xffffffff), // classic white
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
