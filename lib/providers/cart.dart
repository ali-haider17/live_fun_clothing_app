import 'package:flutter/material.dart';

class CartItem{

  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    this.id,
    this.title,
    this.quantity,
    this.price
  });
}

class Cart with ChangeNotifier{

  //Todo: Map every card item to the product id it belongs to.
  //todo: Here String = product id
  //todo: Always initialize the map in order for the gesture to work.
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items{
    //todo: for list use [] and for map use {}
    return {..._items};
  }

  //Todo: Get the total count of items in cart
  int get itemCount{
    return _items.length;
  }

  //Todo: Get total amount of all items in the cart
  double get totalAmount{
    var total = 0.0;
    //Todo: Using forEach method which runs on each received key and item to
    //todo: do something
    _items.forEach((key, item){
      return total += item.price * item.quantity;
    });

    return total.abs();

  }

  void addItem(String productId, double price, String title){
   //todo: check it items already contains the key(productId)
    // todo: Using "containsKey"
   if(_items.containsKey(productId))
     {
       //todo: just change the quantity up updating the map
       //Todo: Using update method which takes key(productId) and a function
       //todo: that automatically gives the existing item
       _items.update(productId, (existingItem){
         return CartItem(
           id: existingItem.id,
           title: existingItem.title,
           price: existingItem.price,
           quantity: existingItem.quantity + 1
         );
       });

     }
   else {
     //Todo: Using putIfAbsend metbod to add new entry to map
     //todo: takes the key(id) and an anonymous function
     _items.putIfAbsent(productId, (){
       return CartItem(
         id: DateTime.now().toString(),
         title: title,
         price: price,
         quantity: 1
       );
     });
   }
    notifyListeners();
  }


  //Todo: Method to remove item (on swiping delete) from the cart
  void removeItem(String productId)
  {
    _items.remove(productId);
    notifyListeners();
  }

  //Todo: Method to clear items in the cart
  void clearCart(){
//    _items = {};
    _items.clear();
    notifyListeners();
  }


  void removeItemOnUndo(String productId){

    if(!_items.containsKey(productId)){
      return;
    }

    if(_items[productId].quantity > 1){
      _items.update(productId, (existingItem){
        CartItem(
          id: existingItem.id,
          title: existingItem.title,
          price: existingItem.price,
          quantity: existingItem.quantity - 1
        );
      });
    }
    else{
      _items.remove(productId);
    }

    notifyListeners();
  }

}