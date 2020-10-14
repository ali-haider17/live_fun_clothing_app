import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/side_drawer.dart';
import '../providers/products_provider.dart';

import '../widgets/manage_product_item.dart';

import '../screens/edit_product.dart';


class ManageProductScreen extends StatelessWidget {

  static const routeName = "/manage_products_screen";

  //TODO: Implementing PULL-TO-REFRESH

  Future<void> refreshProducts(BuildContext context) async {

    //TODO:4. ATTACHING PRODUCTS TO USERS
    //todo: setting the filterByUser value to true
    await Provider.of<ProductsProvider>(context).getProduct(true);
  }

  @override
  Widget build(BuildContext context) {

    final productsData = Provider.of<ProductsProvider>(context);
//    final products = productsData.allproducts;

    void displayEditProduct(bool change){
      Navigator.of(context).pushNamed(EditProductScreen.routeName,
      arguments: {
        'change' : change,
      }
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Products"),

        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: (){
                displayEditProduct(false);
              })
        ],
      ),

      drawer: SideDrawer(),

        //TODO:5. ATTACHING PRODUCTS TO USERS
        //Todo: Need to fetch data when the products first load
        //Todo: Using FutureBuilder and inorder to use ProductsProvider which
        //todo: rebuilds the entire page and causes FutureBuilder to be in an
        //todo: infinite loop, need to use Consumer for the widget only needed to
        //todo: rebuild
      body: FutureBuilder(
        future: refreshProducts(context),
        builder: (ctx, data) {
          return RefreshIndicator(
            onRefresh: (){
              return refreshProducts(context);
            },

            //Todo: Using consumer to break the infinite loop and rather than
            //todo: building the entire page just rebuild this specific widget
            child: Consumer<ProductsProvider>(
              builder: (ctx, products , _ ){
                return ListView.builder(
                  itemBuilder: (ctx, index)
                  {
                    print( products.allproducts[index].title);
                    return ManageProductItem(
                      id: products.allproducts[index].id,
                      title: products.allproducts[index].title,
                      imageUrl: products.allproducts[index].imageUrl,
                    );
                  },


                  itemCount: products.allproducts.length,
                );
              }
            ),
          );
        }

      )

    );
  }
}
