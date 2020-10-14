import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail.dart';
import '../providers/products.dart';
import '../providers/cart.dart';
import '../providers/authentication.dart';


class ProductItem extends StatelessWidget {


  void displayProductDetail(BuildContext context, String id, String title, String imageUrl) {

    Navigator.of(context).pushNamed(
        ProductDetail.routeName,

        arguments: {
          'id' : id,
          'title' : title,
          'imageUrl' : imageUrl
        }
    );
  }

  @override
  Widget build(BuildContext context) {

    //Todo: Listening to the products provider registered in all_products.dart
    final productsData = Provider.of<Products>(context, listen: false);
    final cartData = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),


      //Todo: GridTile Widget is same as the ListTile Widget but works
      //todo: better for GridView and provides additional properties (footer and header).

      //todo: Alternative to using Stack

      child: GridTile(

        child: InkWell(
            radius: 20,
            borderRadius: BorderRadius.circular(20),

            onTap: (){
              displayProductDetail(
                  context,
                  productsData.id,
                  productsData.title,
                  productsData.imageUrl
              );

            },

            //TODO: ADDING THE HERO WIDGET
            //Todo: It works by wrapping the Image you want to use in that Hero animation
            //todo: hero animation always works between two different pages/screens
            //Todo: It needs a tag which is used on the new page which is loaded to know which
            //todo: image on the old screen to float over to that should be animated over
            //todo: into the new screen.

            //todo: the tag must be unique

            child: Hero(
              tag: productsData.id,

              //TODO: FADING LOADING IMAGES
              //Todo: Using FadeInImage Widget which fades in the image when available
              //todo: and allows to define a placeholder which takes an image provider
              //todo: (such as NetworkImage/AssetImage
              //todo: also takes an image argument to render the actual image
              child: FadeInImage(
                  placeholder: AssetImage("assets/images/product.png"),
                  image: NetworkImage(productsData.imageUrl),
                  fit: BoxFit.cover,
              ),
            )
          ),

        //Todo: footer argument to add a widget to the footer of the child
        footer: GridTileBar(
          //Todo: GridTileBar Widget can also be used to diplay more content
          //todo: title, subtitle, and a leading and trailing argument to add widgets

          title: Text(
            productsData.title,
            style: TextStyle(color: Colors.white,),
            textAlign: TextAlign.center,
          ),

          trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              color: Theme.of(context).accentColor,
              onPressed: () {
                  cartData.addItem(productsData.id, productsData.price, productsData.title);

                  //TODO: Using a static method Scaffold.of(context), to establlish a connection to
                //todo: the nearest Scaffold widget.
                //todo: (i-e for this widget the nearest Scaffold is in 'home' where the ALlProductScreen is created)

                //Todo: Can do a couple of things with Scaffold.of(context) such as
                  // todo: opening the drawer:
//                Scaffold.of(context).openDrawer();

                //Todo: Important - Displaying some information using showSnackBar
                  //todo: Snackbar is a material design object shown at the bottom of the screen,
                //todo: an info popup that comes in from the bottom of the screen. Attached to the page.
                //todo: showSnackBar takes a SnackBar Widget

                //todo: hideCurrentSnackBar will hide the current one to show the new one
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                    SnackBar(
                        //content argument takes a widget
                        content: Text("Item added to Cart!"),
                        //duration sets the time to display that info
                        duration: Duration(seconds: 5),

                        //to add some functionality using SnackBarAction widget
                        action: SnackBarAction(
                            label: "Undo",
                            onPressed: (){
                                cartData.removeItemOnUndo(productsData.id);
                            }),
                    )
                );
              }
          ),

          leading: Consumer<Products>(
            builder: (context, products, child) {
              return IconButton(
                  icon: Icon(products.isFavourite ? Icons.favorite : Icons.favorite_border),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    products.toggleFavourite(
                      Provider.of<Authentication>(context).token,
                      Provider.of<Authentication>(context).userId

                    );
                  }
              );
            }
          ),

          backgroundColor: Colors.black54,

          //Todo: Alternative to using GridTileBar
//            Container(
//                  color: Colors.black54,
//                  padding: EdgeInsets.all(10),
//                    child: Text(listProducts[index].title,
//                      style: TextStyle(color: Colors.white),
//                    )
//            ),
        ),
      ),
    );
  }
}
