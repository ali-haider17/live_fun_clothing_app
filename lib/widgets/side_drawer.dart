import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/all_orders.dart';
import '../screens/home.dart';
import '../screens/manage_products.dart';

import '../providers/authentication.dart';
import '../helper/custom_route.dart';

class SideDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    void displayOrders() {
      Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
    }

    void displayHome(){
      Navigator.of(context).pushReplacementNamed(HomePage.routeName);
    }

    void displayManageProducts(){
      Navigator.of(context).pushReplacementNamed(ManageProductScreen.routeName);
    }

    //TODO: 2. MANUAL USER LOGOUT
    //todo: calling the LogOut method
    void logoutUser(){
      Provider.of<Authentication>(context, listen: false).logOut();
    }


    return Drawer(

          child: Container(
            height: 450,
            width: double.infinity,
            child: ListView(

              children: <Widget>[

                Container(
                  alignment: Alignment.center,

                  width: double.infinity,
                  height: 200,

                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).accentColor, width: 10),
                    color: Colors.orangeAccent,

                  ),

//            child: Text(
//              "New Clothing House",
//              style: TextStyle(
//                  fontFamily: "Anton",
//                  color: Colors.white,
//                  fontSize: 26
//              ),
//            ),
                  child: Image.asset("assets/images/shop4.png", fit: BoxFit.cover, width: double.infinity, height: 150,),
                ),


                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  color: Theme.of(context).accentColor,
                  child: ListTile(
                    leading: Icon(Icons.shopping_cart, color: Colors.white,),
                    title: Text("Home", style: TextStyle(color: Colors.white, fontSize: 20),
                    ),

                    onTap: (){
                      displayHome();
                    },
                  ),
                ),


                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  color: Theme.of(context).accentColor,
                  child: ListTile(
                    leading: Icon(Icons.payment, color: Colors.white,),
                    title: Text("My Orders", style: TextStyle(color: Colors.white, fontSize: 20),
                    ),

                    onTap: (){

                      //TODO: 2. CREATING A CUSTOM PAGE ROUTE/NEW SCREEN
                      //todo: to create a new custom route.
//                        displayOrders();
                        Navigator.of(context).pushReplacement(
                            CustomRoute(
                              builder: (ctx){
                                return OrdersScreen();
                              }
                            )
                        );
                    },
                  ),
                ),

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  color: Theme.of(context).accentColor,
                  child: ListTile(
                    leading: Icon(Icons.apps, color: Colors.white,),
                    title: Text("My Products", style: TextStyle(color: Colors.white, fontSize: 20),
                    ),

                    onTap: (){
                      displayManageProducts();
                    },
                  ),
                ),


                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  color: Theme.of(context).accentColor,
                  child: ListTile(
                    leading: Icon(Icons.apps, color: Colors.white,),
                    title: Text("Logout", style: TextStyle(color: Colors.white, fontSize: 20),
                    ),

                    onTap: (){
                      //TODO: 3. MANUAL USER LOGOUT
                      //todo: calling the logoutUser method on tap
                      //todo: Problem: An error is generated as the drawer remains open
                      //todo: Need to close the drawer to remove error as:
                      Navigator.of(context).pop();

                      //Todo: To make sure no unexpected behaviour occurs once logged out
                      Navigator.of(context).pushReplacementNamed('/');


                      logoutUser();
                    },
                  ),
                ),


              ],
            ),
          )

    );
  }
}
