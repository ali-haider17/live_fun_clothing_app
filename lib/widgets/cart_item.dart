import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {

  final String id;
  final String title;
  final price;
  final quantity;
  final productId;

  CartItem({
    this.id,
    this.title,
    this.quantity,
    this.price,
    this.productId
  });


  @override
  Widget build(BuildContext context) {

    //Todo: Dismissible widget which gives a nice animation and removes the element wrapped internally by swiping
    //todo: requires a key to work correctly and avoid issues
    return Dismissible(
      //todo: this key argument takes a widget ValueKey
      key: ValueKey(id),

      //todo: sets the background w.r.t what is being displayed such as a color on swiping
      background: Container(
        color: Theme.of(context).errorColor,
        child: Column(
          children: <Widget>[
            Icon(Icons.delete, color: Colors.white ,),
            Text("Swipe to Delete!", style: TextStyle(color: Colors.white)),
          ],
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 4
        ),
      ),

      //todo: setting swiping direction
      direction: DismissDirection.endToStart,


      //todo: do something on Dismissed argument which takes the directon of swiping (above)
      onDismissed: (direction){
        if(direction == DismissDirection.endToStart)
          Provider.of<Cart>(context, listen: false).removeItem(productId);
      },

      confirmDismiss: (direction){
        
        //TODO: Displaying a Dialog Box using showDialog which can be shown anywhere
        //todo: does not require Scaffold (not attached to page)

        return showDialog(
            context: (context),
            builder: (ctx) {
              
              //Todo: Must return a dialog widget
              return AlertDialog(
                title: Text("Are you sure?"),
                content: Text("Do you want to remove this item?"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Yes"),
                    onPressed: () {
                      //setting to true the ite is removed
                      Navigator.of(ctx).pop(true);
                    },
                  ),

                  FlatButton(
                    child: Text("No"),
                    onPressed: (){
                      //setting to false the item remains
                      Navigator.of(ctx).pop(false);
                    },
                  )
                ],
              );
            }
        );
      },

      child: Card(
        margin: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 4
        ),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: ListTile(
            leading: CircleAvatar(
              maxRadius: 40,
              child: Text("\$ ${price}"),
            ),

            title: Text(title, style: TextStyle(color: Theme.of(context).accentColor),),
            subtitle: Text("quantity X ${quantity}"),
          ),
        ),
      ),
    );
  }
}
