import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import './cart.dart';

class OrderItem with ChangeNotifier{

  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime
  });

}


class Orders with ChangeNotifier{

  final String authToken;

  //TODO:1. ATTACHING ORDERS TO USERS
  final String userId;
  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> _orders = [];

  List<OrderItem> get orders{
    return [..._orders];
  }

  Future<void> getOrders() async {
    const URL =  "https://new-clothing-app.firebaseio.com/";

    //TODO:2. ATTACHING ORDERS TO USERS
    //todo: fetching an order w.r.t the userId
    final ordersCollection = "$URL/orders/$userId.json?auth=$authToken";

    try{
      final response = await http.get(ordersCollection);
      //todo: data is in the form of maps
      //print(response.body);

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      //Todo: Defining a temporary list
      final List<OrderItem> fetchedOrders = [];

      //Todo: Check if extractedData is null because forEach will prompt an error if null
      //todo: use it when fetching Products as well
      if(extractedData == null){
        return;
      }
      extractedData.forEach((orderId, orderData){
        fetchedOrders.add(
            OrderItem(
              id: orderId,
              amount: orderData['amount'],
              //Todo: Parsing the dateTime that was stored as timeStamp.toIso8601String
              dateTime: DateTime.parse(orderData['dateTime']),
              //Todo: Now to get the list of products use as List<dynamic> to tell Dart this is
                //todo: a list and use map function on it
              products: (orderData['products'] as List<dynamic>).map((product){
                return CartItem(
                  id: product['id'],
                  title: product['title'],
                  price: product['price'],
                  quantity: product['quantity'],

                );
              }).toList(),

            ));
      });


      //Todo: To show the latest order first reverse the list using reversed.toList()
      _orders = fetchedOrders.reversed.toList();
      notifyListeners();
    }
    catch(error){
      throw error;
    }

  }


  //TODO: STORING ORDERS
  Future<void> addOrder(List<CartItem> cartProducts, double total) async {

    final timeStamp = DateTime.now();

    const URL =  "https://new-clothing-app.firebaseio.com/";

    //TODO:3. ATTACHING ORDERS TO USERS
    //todo: adding an order to the order collection w.r.t the userId
    final ordersCollection = "$URL/orders/$userId.json?auth=$authToken";

    try{
      final response =  await http.post(ordersCollection, body: json.encode({
        'amount': total,

        //Todo: AS cartProducts is a map of CartItems
        'products' : cartProducts.map((items){
          return {
            'id': items.id,
            'title': items.title,
            'price': items.price,
            'quantity': items.quantity
          };
        }).toList(),
        'dateTime' : timeStamp.toIso8601String(),
      }));


      //Todo: Using the insert method to add elements to the list w.r.t position
      //todo: need every new item added to the beginning of the list
      _orders.insert(
          0, //adding item to the beginning of the list
          OrderItem(
              id: json.decode(response.body)['name'],
              amount: total,
              products: cartProducts,
              dateTime: timeStamp
          )
      );
      notifyListeners();
    }

    catch(error){
      throw error;
    }

  }

}