import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './all_products.dart';
import './show_cart.dart';

import '../widgets/side_drawer.dart';
import '../widgets/badge.dart';

import '../providers/cart.dart';
import '../providers/products_provider.dart';

enum filterValue{
  showFavourite,
  showAll,
}


class HomePage extends StatefulWidget {

  static const routeName = "/home_screen";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool showFavourite = false;
  var isLoading = false;

  void displayCart(){
    Navigator.of(context).pushNamed(ShowCartScreen.routeName);
  }

  Future<void> refreshProducts() async {
    await Provider.of<ProductsProvider>(context).getProduct();
  }

  //TODO: FETCHING DATA
  @override
  void initState() {
    // TODO: implement initState

    //TODO: FETCHING DATA
    //Todo: As you know that provide.of(context) and ModalRoute.of(context) doesn't work in initState
    //todo: (that is all context things do not work)
    //todo: So need a work aroung to use Provider

    //todo: Solution 1: set (listen: false)
    setState(() {
      isLoading = true;
    });

    if(isLoading) {
      Provider.of<ProductsProvider>(context, listen: false).getProduct().then((_){
        setState(() {
          isLoading = false;
        });
      });


    }


    //todo: Solution 2: Using Future.delayed () which is a helper constructor to build
                      //todo: new future
//          Future.delayed(Duration.zero).then((_){
//            Provider.of<ProductsProvider>(context).getProduct();
//          });

    //todo: Solution 3: Using didChangeDependencies and setting a value to run the code within once
    super.initState();
  }


//  var isInit = true;
//
//  @override
//  void didChangeDependencies() {
//    // TODO: implement didChangeDependencies
//
//    if(isInit){
//      setState(() {
//        isLoading = true;
//      });
//
//      if(isLoading) {
//        Provider.of<ProductsProvider>(context, listen: false).getProduct().then((_){
//          setState(() {
//            isLoading = false;
//          });
//        });
//    }
//      isInit = false;
//    }
//
//    super.didChangeDependencies();
//  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text("Live Fun Clothing"),
        actions: <Widget>[

          Consumer<Cart>(
            child: IconButton(
                    icon: Icon(Icons.shopping_cart),
                      onPressed: () {
                        displayCart();
                      }
                  ),
            builder: (context, cartData, child) {
              //Todo: Using the badge widget as instructed by the instructor
              return Badge(
                //Todo: Also need to display the number of items in the cart.
                value: cartData.itemCount.toString(),

                //Todo: Passing the widget(child) on which the value above will be displayed
                child: child
              );
            }
          ),



          //Todo: Using a PopupMenuButton Widget which opens a drop over menu(as an overlay)
          //todo:
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            onSelected: (filterValue value){
              setState(() {
                if(value == filterValue.showFavourite){
                  showFavourite = true;
                }
                else {
                  showFavourite = false;
                }
                print(showFavourite);
              });

            },

            //todo: building entries by returning a list
            itemBuilder: (context){
              //todo: returning a list of PopupMenuItem widgets
              return [
                PopupMenuItem(
                  child: Text("Show All"),
//                        value: 0,   //todo: these values are passed to the onSelected argument to do stuff
                  value: filterValue.showAll,
                ),

                PopupMenuItem(
                  child: Text("Show Favourites"),
//                        value: 1,   //todo: these values are passed to the onSelected argument to do stuff
                  value: filterValue.showFavourite,
                ),
              ];
            },
          )

        ],
      ),


      drawer: SideDrawer(),

      //Todo: Passing the showFavourite value set above to render the correct products list
      body: isLoading ? Center(
              child: CircularProgressIndicator(),
          ) : RefreshIndicator(

          onRefresh: (){
            return refreshProducts();
          },
          child: AllProductsScreen(showFavourite)),
    );
  }
}
