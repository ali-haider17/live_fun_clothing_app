import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:new_clothing_shop/widgets/product_item.dart';

import '../providers/products_provider.dart';

//TODO: Listening to the provider set up (ProductsProvider in main.dart)


class AllProductsScreen extends StatelessWidget {

  final bool showFavourite;
  AllProductsScreen(this.showFavourite);

  @override
  Widget build(BuildContext context) {

    //Todo: The provider package allows to set up a connection to the provided class (ProductsProvider)
    //todo: Only this listening widget's build method will rebuild if changes are made to the provider class
    //todo: Must have a provider set up in its Parent widget to listen to it.

    //Todo: Using the (of method) to tell the provider package that interested in the
    //todo: in the instance of ProductsProvider class
    //todo: Here (of) is a generic method and by adding angled brackets to we can specify the type of data
    //todo: want to listen to.

    //Todo: Giving access to ProductsProvider object
    final productsData = Provider.of<ProductsProvider>(context);

    final productsList = showFavourite ? productsData.onlyfavouriteproducts : productsData.allproducts;

    //Todo: Using GridView.builder to render items that are on the screen/available
    return GridView.builder(

        itemBuilder: (context, index) {

          return ChangeNotifierProvider.value(
            value: productsList[index],

            child: ProductItem(
                //Todo: Don't need to pass the productsList anymore as registered as provider
//                id: productsList[index].id,
//                title: productsList[index].title,
//                imageUrl: productsList[index].imageUrl
            ),
          );

          },

        itemCount: productsList.length,

        //Todo: Using WithFixedCrossAxisCount to define the certain amount of elements
        //todo: displayed and squeezed onto the screen
        //Todo: Whereas WithMaxCrossAxisExtent to define the maximum with width for each element
        //todo: and create as many columns to accomodate the items
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, //the number of columns
          childAspectRatio: 3/2,

          crossAxisSpacing: 15,  //space between columns
          mainAxisSpacing: 15,  //space between rows

        ),

        padding: const EdgeInsets.all(15),
    );


  }
}
