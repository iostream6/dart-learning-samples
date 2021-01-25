/*
 * 2021.01.21  - Created | Add new contact support implemented.
 * 2021.01.25  - Added implementation for 'edit' and 'delete' contact
 */
import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../services/sqldb_service.dart' as dao;
import 'package:provider/provider.dart';

class ContactView extends StatefulWidget {
  final Contact _contact;

  ContactView(this._contact);

  @override
  _ContactViewState createState() => _ContactViewState();
}

class _ContactViewState extends State<ContactView> {
  final TextEditingController _fullnameTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _firstNumberTextController = TextEditingController();
  final TextEditingController _secondNumberTextController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _autovalidate = false; //if true, form is validated after each change.

 // String _errorMessage;

  @override
  void initState() {
    super.initState();
    _fullnameTextController.text = widget._contact.fullname;
    _emailTextController.text = widget._contact.email;
    final int numbers = widget._contact.numbersCount;
    switch (numbers) {
      case 1:
        _firstNumberTextController.text = widget._contact.firstNumber.number;
        break;
      case 2:
        _firstNumberTextController.text = widget._contact.firstNumber.number;
        _secondNumberTextController.text = widget._contact.secondNumber.number;
        break;
    }
  }

  @override
  void dispose() {
    _fullnameTextController.dispose();
    _emailTextController.dispose();
    _firstNumberTextController.dispose();
    _secondNumberTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: SafeArea(
          child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          leading: BackButton(),
          //actions: _appBarActions(context),
          //elevation: 1,
          title: Text(widget._contact.id == null ? 'New Contact' : 'Edit Contact'),
        ),
        body: _body(context),
      )),
      onWillPop: () async => true,
    );
  }

  Widget _body(BuildContext ctx) {
    return Form(
        autovalidateMode: _autovalidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
        key: _formKey,
        child: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Column(children: <Widget>[
              _buildFullnameField(),
              SizedBox(
                height: 10.0,
              ),
              _buildEmailField(),
              SizedBox(
                height: 10.0,
              ),
              _buildFirstNumber1Field(),
              SizedBox(
                height: 10.0,
              ),
              _buildSecondNumber1Field(),
              SizedBox(
                height: 10.0,
              ),
              _buildSaveContactButton(ctx),
              _buildDeleteContactButton(ctx),
              SizedBox(
                height: 10.0,
              ),
              //_buildErrorTextWidget(_errorMessage)
            ])));
  }

  Widget _buildFullnameField() {
    return TextFormField(
      //autofocus: true,
      controller: _fullnameTextController,
      decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Fullname", prefixIcon: Icon(Icons.person), fillColor: Colors.white, filled: true),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Fullname is required';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailTextController,
      decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Email address", prefixIcon: Icon(Icons.alternate_email), fillColor: Colors.white, filled: true),
      validator: _validateEmail,
    );
  }

  Widget _buildFirstNumber1Field() {
    return TextFormField(
      controller: _firstNumberTextController,
      decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Primary number", prefixIcon: Icon(Icons.phone), fillColor: Colors.white, filled: true),
      validator: (value) => _validateNumber(value, true),
    );
  }

  Widget _buildSecondNumber1Field() {
    return TextFormField(
      controller: _secondNumberTextController,
      decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Alternate number", prefixIcon: Icon(Icons.phone_enabled), fillColor: Colors.white, filled: true),
      validator: (value) => _validateNumber(value, false),
    );
  }

  Widget _buildSaveContactButton(BuildContext ctx) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 10.0)),
        //color: Theme.of(context).primaryColor,
        onPressed: () {
          //_errorMessage = null;
          if (_formKey.currentState.validate()) {
            final Contact c = widget._contact;
            c.fullname = _fullnameTextController.text;
            c.email = _emailTextController.text;
            c.numbers = (_secondNumberTextController.text == null || _secondNumberTextController.text.isEmpty)
                ? [_firstNumberTextController.text]
                : [_firstNumberTextController.text, _secondNumberTextController.text];
            final dao.EntityChangeManager<Contact> ecm = Provider.of<dao.EntityChangeManager<Contact>>(ctx, listen: false);
            if(c.id == null){
              ecm.insertEntity(c);
            }else{
              ecm.updateEntity(c, true);
            }
            Navigator.pop(ctx);
          } else {
            //submissiom attempt has failed, so we want the form to validate on each change,
            //rather than wait till next submit, so that the user has realtime feedback on whether issues are fixed
            setState(() {
              _autovalidate = true;
            });
          }
        },
        child: Text("Save", style: TextStyle(color: Colors.white, fontSize: 20.0)),
      ),
    );
  }

  Widget _buildDeleteContactButton(BuildContext ctx) {
    return SizedBox(
      width: double.infinity,
      child: Visibility(
        child: OutlinedButton(
          onPressed: () {
            //TODO Shoot out dialog to make sure!!
            Provider.of<dao.EntityChangeManager<Contact>>(ctx, listen: false).deleteEntity(widget._contact);
            Navigator.pop(ctx);
          },
          child: Text("Delete", style: TextStyle(color: Colors.blue)),
        ),
        visible: widget._contact.id != null,
      ),
    );
  }

  //Widget _buildErrorTextWidget(String message) => message == null ? Text("") : Text(message, style: TextStyle(color: Colors.red));

  String _validateEmail(String email) {
    RegExp regex = RegExp(r'\w+@\w+\.\w+');
    if (email.isEmpty || !regex.hasMatch(email)) {
      return 'Valid email address required';
    }
    return null;
  }

  String _validateNumber(String number, bool isRequired) {
    if (isRequired && (number == null || number.isEmpty)) {
      return 'Primary phone number is required';
    }

    if (!isRequired && (number == null || number.isEmpty)) {
      return null;
    }
    //https://stackoverflow.com/a/55552272
    const pattern = r'(^(?:[+0])?[0-9]{8,12}$)';
    final regExp = RegExp(pattern);
    if (!regExp.hasMatch(number)) {
      return 'Phone number is invalid';
    }
    return null;
  }

}
