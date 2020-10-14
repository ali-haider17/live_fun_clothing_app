import 'package:flutter/material.dart';

//Todo: Offers tools to convert data
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../providers/products.dart';
import '../model/http_exception.dart';

//TODO: This class will be used by the provider package that uses inherited widgets behind the scene,
//todo: establishing a communication channel b/w this class and other widgets

//Todo: Adding a mixin (ChangeNotifier) to use the notifyListeners method
class ProductsProvider with ChangeNotifier {

  //Todo: making it private so it cant be accessed from outside and
  //todo: restricting it, so that one can not directly make changes to the list _products.
  //todo: and can only make certain changes from within this class.
  //todo: also, the main reason for using a getter function to provide a copy instead.
  List<Products> _products = [

//    Products(
//      id: 'p1',
//      title: 'Red Shirt',
//      description: 'A red shirt - it is pretty red!',
//      price: 29.99,
//      imageUrl: 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
//    ),
//
//    Products(
//      id: 'p2',
//      title: 'Trousers',
//      description: 'A nice pair of trousers.',
//      price: 59.99,
//      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
//    ),
//
//    Products(
//      id: 'p3',
//      title: 'Yellow Scarf',
//      description: 'Warm and cozy - exactly what you need for the winter.',
//      price: 19.99,
//      imageUrl:
//      'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
//    ),
//
//    Products(
//      id: 'p4',
//      title: 'A Pan',
//      description: 'Prepare any meal you want.',
//      price: 49.99,
//      imageUrl:
//      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
//    ),
  ];

  //TODO: 1. PASSING THE TOKEN
  final String authToken;

  //TODO:6. CONNECTING FAVOURITE TO THEIR RESPECTIVE USER
  //todo: need to get the userId as well
  final String userId;
  ProductsProvider(this.authToken, this.userId, this._products,);

  //Todo: Using a getter to return a copy of the above list
  List<Products> get allproducts {
    //Todo: The following is a syntax to make a copy.
    return [..._products];

  }

  List<Products> get onlyfavouriteproducts {
    //Todo: The following is a syntax to make a copy.
      return [..._products].where((product){
        return product.isFavourite;
      }).toList();

  }

  //Todo: A Products method to find details w.r.t id
  Products findById(String id){
    return _products.firstWhere((product){
      return product.id == id;
    });
  }



  //TODO: FETCHING DATA

  //TODO:3. ATTACHING PRODUCTS TO USERS
  //Todo: Need a way to show all the products on the home page.
  //Todo: Adding an optional positional argument using [] which will
  //todo: fetch data based on the value provided to it
  //todo: Here using a boolean value which by default set to false
  Future<void> getProduct([bool filterByUser = false]) async {
    const URL =  "https://new-clothing-app.firebaseio.com/";

    //TODO:4. ATTACHING PRODUCTS TO USERS
    //todo: Defining a variable to set the filter value if filterByUser is set to true
    //todo: Need to perform filtering on the server before database is hit and
    //todo: to get back what is needed.

    //todo: Remember the question mark(?) is placed before all the optional query and
    //todo: is separated using ampersand(&)
    //todo: Telling firebase to filter by adding a query parameter with an
    //todo: ampersand (&) with firebase commands such as orderBy, equalTo etc

    //Todo: Important - for these commands/filters to work need to configure index in
    //todo: rules to support filtering as:
    //todo: "products": {
    //todo:   ".indexOn" : [
    //todo:   "creatorId"
    //todo:     ]
    //todo:  }
    final filterString = filterByUser ? "orderBy = 'creatorId'&equalTo = '$userId'" : "";

    //TODO: PASSING THE TOKEN
    //Todo: Adding the authToken value to the auth key

    //TODO:2. ATTACHING PRODUCTS TO USERS
    final productsCollection = "$URL/products.json?auth=$authToken&$filterString";

    try{
      final response = await http.get(productsCollection);
      //todo: data is in the form of maps
//      print(response.body);

      //TODO: TRANSFORMING FETCHED DATA

      //Todo: Defining a map for the response
      //todo: using 'dynamic' instead of 'Object' because Dart doesn't understand
      //todo: the nested map in the map structure on response, otherwise will give an error
      //todo: therefore dynamic tells Dart that the values are dynamic

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      //Todo: Defining a temporary list
      final List<Products> fetchedProducts = [];

      //Todo: Using forEach method, which runs a function for every entry in the map
      //todo: takes two arguments (key and a value)
      //todo: let here key = prodId and value = prodData

      if(extractedData == null){
        return;
      }

      //TODO:6. CONNECTING FAVOURITE TO THEIR RESPECTIVE USER
      //Todo: Now, need to fetch all favourite products of a user from favouriteCollection
      final favouriteCollection = "$URL/favourites/$userId.json?auth=$authToken";
      final favouriteResponse = await http.get(favouriteCollection);

      //Todo: Fetching a map of favourite w.r.t the product Id
      final favouriteData = json.decode(favouriteResponse.body);
//      print(favouriteData);


      //TODO:5. CONNECTING FAVOURITE TO THEIR RESPECTIVE USER
      //Todo: Not fetching (isFavourite) from products
      //Todo: Now, need to fetch isFavourite from favouriteCollection
      extractedData.forEach((prodId, prodData){
        fetchedProducts.add(
            Products(
              id: prodId,
              title: prodData['title'],
              description: prodData['description'],
              price: prodData['price'],
              imageUrl: prodData['imageUrl'],

                //TODO:6. CONNECTING FAVOURITE TO THEIR RESPECTIVE USER
                //todo: assigning the value of favouriteData to the list
                //todo: checking if favouriteData == null then return false (means no product is favourited)
                //todo: otherwise check for the data,

                //Todo: Using Null Check Operator/ Double Question-mark Operator
                //todo: checks if favouriteData != null then use the value (favouriteData[prodId])
                //todo: otherwise use the alternate value false
              isFavourite: favouriteData == null ? false : favouriteData[prodId] ?? false,

            ));
      });

      _products = fetchedProducts;
      notifyListeners();
    }
    catch(error){
      throw error;
    }

  }


  //TODO: LOADING INDICATOR - Transforming the "void function" into a "Future", to return a future.
  //todo: As Future is a generic type, need to specify the kind of data to
  //todo: resolve once this future is done (e.g <void> as we dont want to pass anything.)

  Future<void> addProduct(Products products, ) async {

    const URL =  "https://new-clothing-app.firebaseio.com/";
    //Todo: Creating a new collection(products). Need to add .json at the end which is
    //todo: required by Firebase to parse the incoming request
    final productsCollection = "$URL/products.json?auth=$authToken";

    //Todo: Using a POST Request to add data
    //todo: Using a post method by http package, which to sends a post request to
    //todo: the specified argument, also need to specify what kind of data to send

    //todo: So, post takes a number of arguments:
    //todo: headers: - are metadata that can be attached to the request
    //todo: body: allows to define the request body, which is the data to attach
    //todo: to the request

    //Todo: Need to pass our products object as JSON, need to convert it using
    //todo: (dart: convert) library
    //Todo: Using the json.encode method which takes a map and converts it
    //Todo: This is also an example of asynchronous code that lets other code
    //todo: to continue their execution while producing it's own result in the
    //todo: future.

    //Todo: LOADING INDICATOR - returning a future value


    //TODO:4. CONNECTING FAVOURITE TO THEIR RESPECTIVE USER
    //Todo: No need to add isFavourite in products as storing it in a
    //todo: separate collection
    try {
      final response = await http.post(productsCollection, body: json.encode({
        'title': products.title,
        'description': products.description,
        'imageUrl': products.imageUrl,
        'price': products.price,

        //TODO:1. ATTACHING PRODUCTS TO USERS
        //todo: storing the id of the user within the products
        'creatorId' : userId
      })

        //Todo: post method in the end returns a future object
        //todo: such as then to call a function that waits to get the response object
        //todo: and then executes the code within
        //todo: also expects a result or _

        //Todo: REMEMBER that a future object can also return another future
        //todo: example then also returns a new future as: .then((_){}).then()
        //todo: which will be executed after the first then is done

        //todo: Future can also return errors using catchError() which also returns
        //todo: returns another future and catches any error thrown by future and will not
        //todo: catch errors of then block defined after it

      );

      //Todo: Using json.decode method to get response.body value
      //todo: converting into map
//      print(json.decode(response.body));

      //Todo: Assigning the same value of response.body as id to identify
      //todo: products with the id when deleting

      final id = json.decode(response.body)['name'];
//      print(id);
      if(!_products.contains(id)){
        _products.add(
            Products(
                id: id,
                title: products.title,
                price: products.price,
                description: products.description,
                imageUrl: products.imageUrl
            )
        );
      }

      else{
        return;
      }

      //Todo: Tell the listeners that new data is available and those widgets are rebuilt
      //todo: that are listening to this class
      notifyListeners();
    }

    catch(error){
      print(error);
      //Todo: Using throw keyword to throw the error being fetched
      //todo: throw takes an error object and creates a new error
      throw error;
    }


      //TODO: HANDLING ERRORS - Using catchError to fetch the rror
//    .catchError((error){
////      print(error);
//      //Todo: Using throw keyword to throw the error being fetched
//      //todo: throw takes an error object and creates a new error
//      throw error;
//    });
  }


  //TODO: USING PATCH REQUEST
  //todo: patch request will tell firebase to merge the incoming data with the
  //todo: data.
  //todo: only overriding the value specified.

  Future<void> updateProduct(String oldProductId, Products oldProduct) async {
//    print("Getting" +oldProductId);

    //Todo: return 0 if true otherwise false
    final productIndex = _products.indexWhere((product){
       return product.id == oldProductId;
    });


//    print(productIndex);
    if(productIndex >= 0){

      const URL =  "https://new-clothing-app.firebaseio.com/";
      final productsCollection = "$URL/products/$oldProductId.json?auth=$authToken";

      await http.patch(productsCollection, body: json.encode({
        'title': oldProduct.title,
        'price': oldProduct.price,
        'description' : oldProduct.description,
        'imageUrl' : oldProduct.imageUrl
      })
      );

      _products[productIndex] = oldProduct;
    }
    else{
      print("Not Found");
    }

    notifyListeners();

  }


  //TODO: OPTIMISTIC UPDATING

  Future <void> deleteProduct(String id) async {
    const URL =  "https://new-clothing-app.firebaseio.com/";
    final productsCollection = "$URL/products/$id.json?auth=$authToken";

    //Todo: Finding the index of the product to be deleted
    final existingProductIndex = _products.indexWhere((product){
      return product.id == id;
    });

    //Todo: Storing the product w.r.t the index
    var existingProduct = _products[existingProductIndex];

    _products.removeWhere((product){
      return product.id == id;
    });

    notifyListeners();

    final response = await http.delete(productsCollection);

    print(response.statusCode);
      if(response.statusCode >= 400){

        //Todo: Inserting/Restoring the product if an error occurs
        _products.insert(existingProductIndex, existingProduct);
        notifyListeners();

        throw HttpException("Could not delete product!");
      }
      existingProduct = null;


  }



}