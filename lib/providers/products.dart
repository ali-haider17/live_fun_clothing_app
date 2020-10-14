import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

//Todo: Now Products can notify listeners as they change (i-e isFavourite changes)
class Products with ChangeNotifier{

  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Products({
    this.id,
    this.title,
    this.description,
    this.price,
    this.imageUrl,
    this.isFavourite = false, //default
  });


  //TODO: UPDATING FAVOURITE STATUS USING OPTIMISTIC UPDATING
  //TODO: REMEMBER: http package throws its own errors for get and post requests only
            //todo: Whereas for patch, put and delete it doesn't throw error
            //todo: Thus can check the statusCode of the patch response manually
            //todo: to throw error

            //todo: to get statusCode must set await before the patch request

  Future<void> toggleFavourite(String authToken, String userId) async{

    //Todo: Storing the isFavourite value in variable
    var oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();

    const URL =  "https://new-clothing-app.firebaseio.com/";

    //TODO:1. CONNECTING FAVOURITE TO THEIR RESPECTIVE USER
    //todo: Passing the localId from the response when successfully logged in creating a
    //todo: a different collection
    final favouriteCollection = "$URL/favourites/$userId/$id.json?auth=$authToken";

    //TODO:3. CONNECTING FAVOURITE TO THEIR RESPECTIVE USER
    //Todo: Instead of using patch request(to update), Using put request to set
    //todo: a single value (isFavourite just returning true or false)
    //todo: Also, rather than passing a map just passing single value (isFavourite)
      final response = await http.put(
          favouriteCollection,
          body: json.encode(
            isFavourite
          )
      );

      if(response.statusCode >= 400){
        isFavourite = oldStatus;
        notifyListeners();

      }
  }
}