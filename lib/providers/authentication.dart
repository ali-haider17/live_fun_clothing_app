import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


import '../model/http_exception.dart';

class Authentication with ChangeNotifier{

  //Todo: Remember token is available for a short amount of time and then expires
  //todo: in firebase expires about after an hour
  String _token;
  //Todo: To keep in track when the token will expire
  DateTime _tokenExpiryDate;
  String _id;
  Timer _logoutTimer;


  //TODO: 1. MANUAL USER LOGOUT
  Future<void> logOut() async {
    _token = null;
    _tokenExpiryDate = null;
    _id = null;

    //TODO:3. AUTOMATICALLY LOGGING USERS OUT
    //todo: cancelling the timer at manual logout too.
    if(_logoutTimer != null){
      _logoutTimer.cancel();
    }
    notifyListeners();

    //TODO:4. AUTOMATICALLY LOGGING USERS IN
    //Todo: Need to clear out the data store in shared preferences so that
    //todo: don't get automatically logged in once logged out

    //Todo: Convert this method into a future
    final prefs = await SharedPreferences.getInstance();
    //Todo: Using remove to clear some specific data only
//    prefs.remove('userData');

    //Todo: Using clear to delete all the app data
    prefs.clear();
    }


  //TODO:1. AUTOMATICALLY LOGGING USERS OUT
  //todo: Using the dart:async library to set a Timer logoutTimer
  void automaticLogout(){
    //todo: Check if there is already an old timer running then cancel it
    if(_logoutTimer != null){
      _logoutTimer.cancel();
    }
    final timeToExpire = _tokenExpiryDate.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(Duration(seconds: timeToExpire), logOut);
  }

  //TODO: 3. NAVIGATING AFTER LOGGED IN
  bool get isLoggedIn{
    if(token != null)
      return true;
    else
      return false;
  }

  //TODO: 3. NAVIGATING AFTER LOGGED IN
  String get token{
    if(_token != null && _tokenExpiryDate != null && _tokenExpiryDate.isAfter(DateTime.now()))
      {
        return _token;
      }
    else
      return null;
  }

  //TODO:2. CONNECTING FAVOURITE TO THEIR RESPECTIVE USER
  //todo: defining a getter to fetch the user_id (localId)
  String get userId{
    if(token != null)
      return _id;
    else
      return null;
  }

  //TODO: ADDING USER SIGN-UP
  Future<void> SignUp(String email, String password) async {

    const URL = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAFZZbnETt2I6XRwhjVlrFfg1Ap1y9qbxs";
    try {
      final response = await http.post(URL,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));

      final responseData = json.decode(response.body);
      if(responseData['error'] != null){
        //Todo: Forwarding the error message
        throw HttpException(responseData['error']['message']);
      }
    }
    catch(error){
      throw error;
    }
  }

  //TODO: ADDING USER SIGN-IN
  Future<void> SignIn(String email, String password) async {

    print(email);
    print(password);
    const URL = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAFZZbnETt2I6XRwhjVlrFfg1Ap1y9qbxs";
    try{
      final response = await http.post(URL,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));


      //TODO: 1. HANDLING AUTHENTICATION ERRORS
      //Todo: As the above signin request gives a response (bunch of useful information) on success
      //Todo: Also, gives some error information on an error
      //todo: as the response returned is some sort of a map

      final responseData = json.decode(response.body);
      if(responseData['error'] != null){
        //Todo: Forwarding the error message
        throw HttpException(responseData['error']['message']);
      }

      //print(responseData);

      //TODO: 5. NAVIGATING AFTER LOGGED IN
      //Todo: Storing the tokenId and localId values from the response
      _token = responseData['idToken'];
      //print(_token);
      _id = responseData['localId'];

      //Todo: Also storing expiresIn value that is the number of seconds in which
      //todo: the token will expire
      //todo: Here we're parsing the string (expiresIn value) into integer and
      //todo: adding it to the current time to get the precise time the token
      //todo: will expire in the future
      _tokenExpiryDate = DateTime.now().add(
          Duration(
              seconds: int.parse(responseData['expiresIn'])));

      //TODO:1. AUTOMATICALLY LOGGING USERS OUT
      //todo: calling automatic logout method on login
      automaticLogout();
      notifyListeners();

      //TODO:1. AUTOMATICALLY LOGGING USERS IN
      //todo: Store data in Shared Preferences when the user is logged in
      //todo: Shared Preference also require working with futures

      //Todo:1.1 Getting access to shared preferences
      //todo: here this also returns a future that returns a shared preference instance as well
      //todo: using await to get real access to Shared preferences and not the future
      final prefs = await SharedPreferences.getInstance();

      //Todo: Using json.endode to store some data
      final userData = json.encode({
        'token' : token,
        'userId' : userId,
        'tokenExpiryDate' : _tokenExpiryDate.toIso8601String()
      });
      //Todo:1.2 Writing data to shared preferences using set methods (boolean, string etc ...)
      //todo: Passing the above data as value and a key 'userData' to shared preferences storage
      prefs.setString('userData', userData);
    }

    catch(error){
      throw error;
        }
    }


  //TODO:2. AUTOMATICALLY LOGGING USERS IN
  //todo: a method to retrieve data from shared preferences
  Future<bool> automaticallyLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')){
      return false;
    }

    //Todo: Using get methods to retrieve data w.r.t the key used to store the
    //todo: map
    final extractData = json.decode(prefs.getString('userData')) as Map<String, Object>;

    //Todo: fetching the tokenExpiryDate
    final expiryDate = DateTime.parse(extractData['tokenExpiryDate']);

    //Todo: Check if the expiry date is old
    if(expiryDate.isBefore(DateTime.now()))
      {
        return false;
      }

    _token = extractData['token'];
    _tokenExpiryDate = extractData['tokenExpiryData'];
    _id = extractData['userId'];
    notifyListeners();
    automaticLogout();
    return true;

  }


}