# FlutterPIM

A flutter-based Personal Infomation Manager.

## Version One

In version 1, a basic flutter project project for ios/android is realized. This version includes basic UIs for login/signup and associated navigation. Actual authentication and input validation is not performed and there is no state management provided.


## Version Two

In version 2, Login and Signup UI are updated, dropping use of deprecated Widgets and methods/properties. Added form validation support and error notification for login/signup forms. Authentication implementation is now included based on a local (SharedPreference) persistence backend service. Basic skeleton of authenticated (i.e. secured) view implemented with PageView widget and BottomNavBar


## Version Three

Introduced Note data model and sqflite data persistence support for note objects. Added database init and provider state management for notes. Implemented first pass Notes list view with staggeredGrid view. First pass implementation of single NoteView UI and functionality (view/edit/save)

