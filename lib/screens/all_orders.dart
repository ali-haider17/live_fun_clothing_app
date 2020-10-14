import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/side_drawer.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';


class OrdersScreen extends StatefulWidget {

  static const routeName = "/orders_screen";

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {

//  var isLoading = false;
//
//  @override
//  void initState() {
//    // TODO: implement initState
//
//    Future.delayed(Duration.zero).then((_) async {
//      setState(() {
//        isLoading = true;
//      });
//      await Provider.of<Orders>(context, listen: false).getOrders();
//      setState(() {
//        isLoading = false;
//      });
//
//    });
//
//    super.initState();
//  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        appBar: AppBar(
          title: Text("Orders"),
        ),

        drawer: SideDrawer(),

        body: FutureBuilder(
            future: Provider.of<Orders>(context, listen: false).getOrders(),
            builder: (ctx, data) {
              if (data.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              else{
                return Consumer<Orders>(
                  builder: (ctx, orderData, child ){
                     return ListView.builder(
                      itemBuilder: (context, index) {
                        return OrderItem(
                          orderData.orders[index],
                        );
                      },

                      itemCount: orderData.orders.length,
                    );
                  },

                );
              }
            }
        )


//      })isLoading ? Center(
//              child: CircularProgressIndicator(),
//            )
//
//          : ListView.builder(
//            itemBuilder: (context, index){
//              return OrderItem(
//                orderData.orders[index],
//              );
//            },
//
//          itemCount: orderData.orders.length,
//      ),
    );
  }
}


