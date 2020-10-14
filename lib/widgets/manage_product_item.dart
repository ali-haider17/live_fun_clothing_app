import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product.dart';
import '../providers/products_provider.dart';

class ManageProductItem extends StatelessWidget {

  final String id;
  final String title;
  final String imageUrl;

  ManageProductItem({
    this.id,
    this.title,
    this.imageUrl
  });


  @override
  Widget build(BuildContext context) {

    final product = Provider.of<ProductsProvider>(context, listen: false);

    void displayEditProduct(bool change){
      Navigator.of(context).pushNamed(EditProductScreen.routeName,
          arguments: {
        'id': id,
        'change' : change
      });
      print(id);
    }

    return Column(
      children: <Widget>[
        ListTile(
          title: Text(title),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imageUrl),
          ),

          trailing: Container(
            alignment: Alignment.center,
            width: 100,
            child: Row(
              children: <Widget>[
                IconButton(
                    icon: Icon(Icons.edit, color: Theme.of(context).accentColor,),
                    onPressed: (){
                        displayEditProduct(true);
                    }),

                IconButton(
                    icon: Icon(Icons.delete, color: Theme.of(context).accentColor,),
                    onPressed: () async {
                      try{
                        await product.deleteProduct(id);
                      }
                      catch(error){
                        Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text(error.toString())),
                        );
                      }

                    }
                )
              ],
            ),
          ),

        ),

        Divider(),
      ],
    );
  }
}
