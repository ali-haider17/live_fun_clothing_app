import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';


//TODO: EITHER USE "SHOW" OR "AS (PREFIX)" IF MUTLIPLE FILES HAVE CLASSED WITH SAME NAME
//Todo: Need to import only a specific class in a file use "show"
//import '../providers/cart.dart' show Cart;
import '../providers/cart.dart';

//Todo: Using a prefix if two classes have the same name (e.g CartItem)
import '../widgets/cart_item.dart' as ct;

class ShowCartScreen extends StatelessWidget {

  static const routeName = "/show_cart";

  @override
  Widget build(BuildContext context) {

    final cardData = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("My Cart"),
      ),

      body: Container(
          margin: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 4
          ),

          child: Column(
            children: <Widget>[
              Card(

                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,

                    children: <Widget>[
                      Text("Total Amount", style: TextStyle(fontSize: 20),),

                      //Todo: Spacer widget takes up all the available space and
                      //todo: reserves if for itself.
                      Spacer(),

                      //Todo: Chip widget is similar to the badge.dart exported earlier
                      //todo: an element with rounded corners to display information
                      Chip(
                        label: Text('${cardData.totalAmount}'),
                      ),

                      SizedBox(
                        width: 10,
                      ),

                      //TODO: STORING ORDERS
                      //todo: 1. Disabling the button if no items in the cart or total amount <= 0
                      OrderButton(cardData: cardData)
                    ],
                  ),
                ),
              ),

              SizedBox(
                width: 10,
              ),

              Expanded(
                  child: ListView.builder(
                      itemBuilder: (context, index){
                          return ct.CartItem(

                            //Todo: Getting error (getter id = null)

                            //Todo: Using .values.toList() method
                            //todo: Need to get only the values in the map
                            id: cardData.items.values.toList()[index].id,
                            title: cardData.items.values.toList()[index].title,
                            price: cardData.items.values.toList()[index].price,
                            quantity: cardData.items.values.toList()[index].quantity,

                            //todo: Using .key.toList()
                            //todo: Need to pass the productId which is a key
                            productId: cardData.items.keys.toList()[index],

                          );
                      },

                      itemCount: cardData.items.length,

                      ),

              )

            ],
          )
          ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cardData,
  }) : super(key: key);

  final Cart cardData;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {

  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: (widget.cardData.totalAmount <= 0 || isLoading) ? null
          : () async {

            setState(() {
              isLoading = true;
            });

            await Provider.of<Orders>(context, listen: false)
                .addOrder(
                widget.cardData.items.values.toList(),
                widget.cardData.totalAmount
                )
                .then((_){
                  setState(() {
                    isLoading = false;
                  });
                });
            widget.cardData.clearCart();
            },
        color: Theme.of(context).accentColor,
        child: isLoading ? Padding(
                padding: EdgeInsets.all(2),
                child: CircularProgressIndicator()
              )
            : Text("Buy Now!", style: TextStyle(color: Colors.white),),
    );
  }
}
