import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {

  final ord.OrderItem order;
  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {

  var expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(microseconds: 300),
      height: expanded ? min(widget.order.products.length * 20.0 + 200, 300) : 95,

      //Todo: Wrapping the Card Widget with a container
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[

            ListTile(
              title: Text("\$ ${widget.order.amount}"),
              subtitle: Text(DateFormat.MMMd().format(widget.order.dateTime)),

              trailing: IconButton(
                  icon: expanded ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
                  onPressed: (){
                    setState(() {
                      expanded = !expanded;
                    });
                  }),

            ),

//            if(expanded)
              //Todo: Attaching a widget if expanded is set to true
              AnimatedContainer(
                duration: Duration(microseconds: 300),

                //todo: setting a height w.r.t the products having the min value of either of two
                height: expanded ? min(widget.order.products.length * 20.0 + 100, 180) : 0,

                child: ListView.builder(
                    itemBuilder: (context, index){
                      return Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text(widget.order.products[index].title, style: TextStyle(
                              fontSize: 20,
                              color: Colors.black
                            ),),

                            Spacer(),
                            Text("${widget.order.products[index].quantity}x \$ ${widget.order.products[index].price}",
                                style: TextStyle(fontSize: 18, color: Colors.grey),
                            ),

                          ],

                        ),
                      );
                    },
                  itemCount: widget.order.products.length,
                ),
              ),

          ],
        ),
      ),
    );
  }
}
