/*
 * 2021.01.02  - Created basic UI | Added form validation support
 * 2021.01.03  - Added Service error notification text widget. Modularized the Widget build methods
 *               Remember account email and auto-populate UI.
 * 
 */

import 'package:flutter/material.dart';
import 'secured/secured_views.dart';
import '../services/services.dart' as service;

final String logo = "assets/images/logo.png";
//

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  //
  String _errorMessage;
  //
  bool _autovalidate = false; //if true, form is validated after each change.

  Widget _buildErrorTextWidget(String message) => message == null ? Text("") : Text(message, style: TextStyle(color: Colors.red));

  Widget _buildEmailTextField() {
    // final String email = service.getEmail() ?? '';
    // print('INITIAL VALUE: $email');
    _emailTextController.text = service.getEmail() ?? '';
    return TextFormField(
      controller: _emailTextController,
      ///initialValue: email, we already set initial text with controller
      decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Email address", prefixIcon: Icon(Icons.alternate_email), fillColor: Colors.white54, filled: true),
      validator: (value) {
        if (value.isEmpty) {
          return 'Email is required';
        }
        return null;
      },
      onChanged: (String val) {
        setState(() => _errorMessage = null);
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      obscureText: true,
      controller: _passwordTextController,
      decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Password", prefixIcon: Icon(Icons.vpn_key), fillColor: Colors.white54, filled: true),
      validator: (value) {
        if (value.isEmpty) {
          return 'Password is required';
        }
        return null;
      },
      onChanged: (String val) {
        setState(() => _errorMessage = null);
      },
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 10.0)),
        //color: Theme.of(context).primaryColor,
        onPressed: () {
          if (_formKey.currentState.validate()) {
            if (service.authenticate(email: _emailTextController.text, currentPassword: _passwordTextController.text)) {
              //account authenticated!
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SecuredPageView()));
            } else {
              setState(() => _errorMessage = 'Login failed. Please check your login details.');
            }
          } else {
            //submissiom attempt has failed, so we want the form to validate on each change,
            //rather than wait till next submit, so that the user has realtime feedback on whether issues are fixed
            setState(() {
              _autovalidate = true;
            });
          }
        },
        child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 20.0)),
      ),
    );
  }

  Widget _buildCreateAccountViewButton() {
    bool accountIsSetup = service.getEmail() != null;
    return SizedBox(
      width: double.infinity,
      child: Visibility(
        child: OutlinedButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => CreateAccountView()));
          },
          child: Text("Not yet set up!!? Create Account", style: TextStyle(color: Colors.blue)),
        ),
        visible: !accountIsSetup,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   titleSpacing: 0,
        //   //backgroundColor: Colors.transparent,
        //   automaticallyImplyLeading: true,
        //   elevation: 0,
        //   title: Text('Create Account'),
        // ),
        body: Form(
            autovalidateMode: _autovalidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
            key: _formKey,
            child: SingleChildScrollView(
                padding: EdgeInsets.all(20.0),
                child: Column(children: <Widget>[
                  SizedBox(
                    height: 40.0,
                  ),
                  // Expanded(
                  //   child: Container(
                  //     color: Colors.amber,
                  //     width: 100,
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 60.0,
                  // ),
                  Image.asset(
                    logo,
                    height: 100,
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  _buildEmailTextField(),
                  SizedBox(
                    height: 10.0,
                  ),
                  _buildPasswordTextField(),
                  SizedBox(
                    height: 20.0,
                  ),
                  _buildLoginButton(),
                  _buildCreateAccountViewButton(),
                  SizedBox(
                    height: 10.0,
                  ),
                  _buildErrorTextWidget(_errorMessage)
                ]))));
  }
}

class CreateAccountView extends StatefulWidget {
  @override
  _CreateAccountViewState createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends State<CreateAccountView> {
  final _formKey = GlobalKey<FormState>();
  //
  bool _autovalidate = false; //if true, form is validated after each change.
  //
  final _fullnameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _password2TextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  //
  final FocusNode _fullnameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _passwordConfirmationFocusNode = FocusNode();
  //
  String _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          //backgroundColor: Colors.transparent,
          automaticallyImplyLeading: true,
          elevation: 0,
          title: Text('Create New Account'),
        ),
        backgroundColor: Colors.white,
        body: Form(
            autovalidateMode: _autovalidate ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
            key: _formKey,
            child: SingleChildScrollView(
                padding: EdgeInsets.all(20.0),
                child: Column(children: <Widget>[
                  _buildFullnameField(),
                  SizedBox(
                    height: 10.0,
                  ),
                  _buildEmailField(),
                  SizedBox(
                    height: 10.0,
                  ),
                  _buildPasswordField(),
                  SizedBox(
                    height: 10.0,
                  ),
                  _buildPasswordConfirmationField(),
                  SizedBox(
                    height: 10.0,
                  ),
                  _buildCreateAccountButton(),
                  _buildBackToLoginViewButton(),
                  SizedBox(
                    height: 10.0,
                  ),
                  _buildErrorTextWidget(_errorMessage)
                ]))));
  }

  Widget _buildCreateAccountButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 10.0)),
        //color: Theme.of(context).primaryColor,
        onPressed: () {
          _errorMessage = null;
          if (_formKey.currentState.validate()) {
            if (service.createAccount(_fullnameTextController.text, _emailTextController.text, _passwordTextController.text)) {
              //account created!
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => SecuredPageView()));
            } else {
              setState(() => _errorMessage = 'Create account failed');
            }
            //
          } else {
            //submissiom attempt has failed, so we want the form to validate on each change,
            //rather than wait till next submit, so that the user has realtime feedback on whether issues are fixed
            setState(() {
              _autovalidate = true;
            });
          }
        },
        child: Text("Create", style: TextStyle(color: Colors.white, fontSize: 20.0)),
      ),
    );
  }

  Widget _buildBackToLoginViewButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text("Already have an account? Login", style: TextStyle(color: Colors.blue)),
      ),
    );
  }

  Widget _buildFullnameField() {
    return TextFormField(
      autofocus: true,
      focusNode: _fullnameFocusNode,
      controller: _fullnameTextController,
      decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Full Name", prefixIcon: Icon(Icons.person), fillColor: Colors.white, filled: true),
      validator: (value) {
        if (value.isEmpty) {
          return 'Fullname is required';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailTextController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Email address", prefixIcon: Icon(Icons.alternate_email), fillColor: Colors.white54, filled: true),
      validator: _validateEmail,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      obscureText: true,
      controller: _passwordTextController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Password", prefixIcon: Icon(Icons.vpn_key), fillColor: Colors.white54, filled: true),
      validator: _validatePassword,
    );
  }

  Widget _buildPasswordConfirmationField() {
    return TextFormField(
      obscureText: true,
      controller: _password2TextController,
      focusNode: _passwordConfirmationFocusNode,
      decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Confirm Password", prefixIcon: Icon(Icons.vpn_key), fillColor: Colors.white54, filled: true),
      validator: _validatePasswordConfirmation,
    );
  }

  Widget _buildErrorTextWidget(String message) => message == null ? Text("") : Text(message, style: TextStyle(color: Colors.red));

  String _validatePasswordConfirmation(String pass2) {
    return (pass2 == _passwordTextController.text) ? null : "Passwords must match";
  }

  String _validatePassword(String pass1) {
    RegExp hasUpper = RegExp(r'[A-Z]');
    RegExp hasLower = RegExp(r'[a-z]');
    RegExp hasDigit = RegExp(r'\d');
    RegExp hasPunct = RegExp(r'[_!@#\$&*~-]');
    if (!RegExp(r'.{8,}').hasMatch(pass1)) return 'Passwords must have at least 8 characters';
    if (!hasUpper.hasMatch(pass1)) return 'Passwords must have at least one uppercase character';
    if (!hasLower.hasMatch(pass1)) return 'Passwords must have at least one lowercase character';
    if (!hasDigit.hasMatch(pass1)) return 'Passwords must have at least one number';
    if (!hasPunct.hasMatch(pass1)) return 'Passwords need at least one special character like !@#\$&*~-';
    return null;
  }

  String _validateEmail(String email) {
    RegExp regex = RegExp(r'\w+@\w+\.\w+');
    if (email.isEmpty || !regex.hasMatch(email)) {
      _emailFocusNode.requestFocus();
      return 'Valid email address required';
    }
    return null;
  }
}
