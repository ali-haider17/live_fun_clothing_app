import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';

class ProductDetail extends StatelessWidget {

  static const routeName = "/product_detail";

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, Object>;
    final String id = routeArgs['id'];

    //Todo: Setting a listen argument to specify if we want the child to listen to the changes in the provider or not
    final productsData = Provider.of<ProductsProvider>(context,listen: false);

//    final productsDetails = productsData.products.firstWhere((product){
//                                return product.id == id;
//                            });

    //Todo: Using a method defined in provider class rather than defining directly above.
    final productsDetails = productsData.findById(id);


    return Scaffold(
//      appBar: AppBar(
//        title: Text(productsDetails.title),
//      ),


      //TODO: WORKING WITH SLIVERS
      //Todo: Adding a CustomScrollView instead of a SingleChildScrollView
      //todo: to add more control to scrolling or to do something when scrolling
      //todo: It takes a list of Slivers which are scrollable areas on the screen
      //todo: 1. Need to change the image into appbar
      body: CustomScrollView(

        slivers: <Widget>[
          SliverAppBar(
            //todo: the height if its not the app bar but the image
            expandedHeight: 300,
            //todo: setting pinned to true which means that the app bar will be
            //todo: visible and sticked to the top when scrolling
            pinned: true,

            //todo: what should be inside of the appbar
            flexibleSpace: FlexibleSpaceBar(
              title: Text(productsDetails.title),

              //Todo: the part which will be seen when it is expanded
              background: Hero(
                  tag: productsDetails.id,
                  child: Image.network(
                    productsDetails.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
            ),

          ),

          //Todo: SliverList is like a ListView as part of multiple slivers
          //todo: Used when the ListView is part of multiple scrollable things
          //todo: on a screen which should scroll independently and where want
          //todo: some special tricks when they scroll

          //todo: It takes a delegate argument that tells how to render the
          //todo: contents of a list.

          SliverList(
              //Todo: SliverChildListDelegate takes a list of items that should be
            //todo: part of the sliver list
              delegate: SliverChildListDelegate(
                [
                  SizedBox(width: 15,),

                  Container(
                      width: 180,
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      color: Theme.of(context).textTheme.title.color,
                      child: Text("\$ ${productsDetails.price}",
                        style: TextStyle(color: Colors.white, fontSize: 25),
                        softWrap: true,
                      )
                  ),

                  SizedBox(width: 15,),

                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 25
                    ),
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.center,
                    color: Theme.of(context).accentColor,
                    child: Text("${productsDetails.description}",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      softWrap: true,
                    ),
                  ),

                  SizedBox(height: 800,),
                ]
          ))
        ],

//        child: Container(
//          width: double.infinity,
//          child: Column(
//            children: <Widget>[
//              Container(
//                padding: EdgeInsets.all(10),
//                height: 300,
//                alignment: Alignment.center,
//
//                //TODO: ADDING THE HERO WIDGET
//                //todo: adding the same tag value in the old screen
//                child: Hero(
//                  tag: productsDetails.id,
//                  child: Image.network(
//                    productsDetails.imageUrl,
//                    fit: BoxFit.cover,
//                  ),
//                ),
//              ),


//              SizedBox(width: 15,),
//
//              Container(
//                  width: 180,
//                  padding: EdgeInsets.all(10),
//                  alignment: Alignment.center,
//                  color: Theme.of(context).textTheme.title.color,
//                  child: Text("\$ ${productsDetails.price}",
//                    style: TextStyle(color: Colors.white, fontSize: 25),
//                    softWrap: true,
//                  )
//              ),
//
//              SizedBox(width: 15,),
//
//              Container(
//                margin: EdgeInsets.symmetric(
//                    vertical: 10,
//                    horizontal: 25
//                ),
//                width: double.infinity,
//                padding: EdgeInsets.all(10),
//                alignment: Alignment.center,
//                color: Theme.of(context).accentColor,
//                child: Text("${productsDetails.description}",
//                  style: TextStyle(color: Colors.white, fontSize: 18),
//                  softWrap: true,
//                ),
//              ),


      ),
    );
  }
}
