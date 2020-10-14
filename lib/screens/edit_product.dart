import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {

  static const routeName = "/edit_product_screen";

//  bool changeOnce;

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {


  //Todo: To manage the transition of going from one input to the other
  //Todo: 1. Using FocusNode() widget to manage which input is focused,
  //todo: works by assigning it to the focusNode argument of the input
  final priceFocusNode = FocusNode();
  final quantityFocusNode = FocusNode();
  final imageFocusNode = FocusNode();

  final imageUrlController = TextEditingController();


  //Todo: STEP 4 - Initializing a map to store the value ie Products
  var editedProducts = Products(
    id: null,
    title: "",
    price: 0,
    description: "",
    imageUrl: "",
  );

  //Todo: Default values for a new product
  var initProduct = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl':''
  };


  //TODO: STEP 1 - initializing the GlobalKey
  //Todo: IMPORTANT - Need a GlobalKey when want to interact with a widget form
  //todo: initializing a globalkey as:
  //todo: key is a generic type, need to specify the type of data to refer to
  // todo: using < > brackets

  //todo: globalkey will allow to interact with the state behind the form widget
  //todo: by assigning this form key to the form to establish the connection
  final form = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose

    //Todo: removing listener to avoid memory leaks
    imageFocusNode.removeListener(updateListener);

    priceFocusNode.dispose();
    quantityFocusNode.dispose();
    imageFocusNode.dispose();
    super.dispose();
  }


  //Todo: Solution - Using initState to add an initial listener for imageFocus node to maintain this focused image
  //todo: even after the focus changes

  @override
  void initState() {
    // TODO: implement initState

    //Todo: calls a function whenever the focus changes
    imageFocusNode.addListener(updateListener);
    super.initState();
  }

  void updateListener(){
    //todo: check if the imageFocusNode has focus or not
    if(!imageFocusNode.hasFocus){
      setState(() {
      });
    }
  }


  var _changeOnce = true;

  //Todo: LOADING INDICATOR - setting a value to render the UI
  var isLoading = false;


  @override
  void didChangeDependencies() {
    if(_changeOnce) {
      //TODO: To get the id(arguments) using ModalRoute which does not work in initState
      final routeArgs = ModalRoute.of(context).settings.arguments as Map<String, Object>;
      final productId = routeArgs['id'];

      if (productId != null) {
        //Todo: Fetching the details of the product w.r.t id
        final product = Provider.of<ProductsProvider>(context, listen: false).findById(productId);
        //Todo: setting the details of the product found

        editedProducts = product;

        initProduct = {
          'title': editedProducts.title,
          'price': editedProducts.price.toString(),
          'description': editedProducts.description,
//          'imageUrl' : editedProducts.imageUrl
        };

        print(initProduct['title']);
        //TODO: SOLUTION: set the editedProducts.imageUrl value to the controller
        imageUrlController.text = editedProducts.imageUrl;
      }
    }
      _changeOnce = false;


    super.didChangeDependencies();
  }


  //TODO: STEP 3 - Function to save data from the form which will be triggered by every
  //todo: TextFormField


  Future<void> saveFormData () async {

    final products = Provider.of<ProductsProvider>(context, listen: false);

    //todo: Using .currentState.validate to trigger all the validators in the form
    //todo: this returns true if all return null and returns false when atleast
    //todo: one validator returns a string
    var validated = form.currentState.validate();

    if(!validated){
      return;
    }

    else {
      //todo: Using .currentState.save() which will save the currentState of the form
      //todo: triggering all onSaved
      form.currentState.save();
      setState(() {
        isLoading = true;
      });

      //Todo: If the id in not null then edit the same product with the id

      if (editedProducts.id != null) {
        //Todo: Updating products
        await products.updateProduct(editedProducts.id, editedProducts);
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
      }

      //Todo: Otherwise if id == null then update add the new product
      else {
        //Todo: LOADING INDICATOR - Now here this is a future which can return
        //todo: a future (then) as well

        try {
          await products.addProduct(editedProducts);
        }

        catch (error) {
          await showDialog(context: context, builder: (ctx) {
            return AlertDialog(
              title: Text("An error has occurred!"),
              content: Text(error.toString()),
              actions: <Widget>[
                RaisedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Ok"),
                  color: Theme
                      .of(context)
                      .primaryColor,
                )

              ],
            );
          });
        }

        finally {
          setState(() {
            isLoading = false;
          });
          Navigator.of(context).pop();
        }
        //TODO: catchError is reached when there in error (such as the one throwing
        //todo: in products_provider.dart) but only the first catch error in line
        //todo: will execute then and handle the error.
//          .catchError((error){
//            //todo: also error is an object that has message that can be get using error.string
//
//            showDialog(context: context, builder: (ctx){
//              return AlertDialog(
//               title: Text("An error has occurred!"),
//               content: Text(error.toString()),
//                actions: <Widget>[
//                  RaisedButton(
//                    onPressed: (){
//                      Navigator.of(context).pop();
//                    },
//                  child: Text("Ok"),
//                    color: Theme.of(context).primaryColor,
//                  )
//
//                ],
//              );
//            });
//
//          })
//          .then((_){
//            setState(() {
//              isLoading = false;
//            });
//            Navigator.of(context).pop();
//          });
//
//          print(editedProducts.title);
//          print(editedProducts.description);
//          print(editedProducts.price);
//          print(editedProducts.imageUrl);
//        }

      }
    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.save),
              onPressed: (){
                saveFormData();
              })
        ],
      ),

      //TODO: FORM WIDGET (A widget that helps collecting user input and validation)
      //todo: -itself invisible and doesn't renders anything on the screen
      //todo: Inside the Form Widget can use special input widget which are grouped,
      //todo: submitted and validated together

      //Todo: LOADING INDICATOR - check if the loading widget is set to true
      body: isLoading ? Center(

        //Todo: Using the CircularProgressIndicator Widget
        child: CircularProgressIndicator(),
      )

      :
        Form(

        //Todo: STEP 2: assigning the globalkey
        key: form,

          //using ListView so that the elements are scrollable
          child: Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.center,
            child: ListView(
              children: <Widget>[

                //Todo: Instead of TextField using TextFormField Widget which is automatically
                //todo: connected to the Form
                TextFormField(
                  initialValue: initProduct['title'],

                  decoration: InputDecoration(
//                    hintText: "Title",
                    labelText: "Title",
                    helperText: "Enter product's title"
                  ),


                  //TODO: Validator argument takes a function
                  //todo: can be defined for every TextFormField
                  validator: (value){

                  if(value.isEmpty){
                    //todo: returning a text which is always treated as an error text.
                    return "Please provide the title!";
                  }

                  else
                    //todo: returning null which means that the input is Correct
                    return null;

                  },

                  //Todo: Performing an action when enter/Ok is pressed on the softkeyboard
                  //todo: (e.g: going to the next input field etc...)
                  textInputAction: TextInputAction.next,

                  //Todo: 3. Now to tell flutter that when this next button is pressed, need to
                  //todo: focus the element with priceFocusNode that is assigned to the next input field
                  onFieldSubmitted: (_){

                    //Todo: Using the FocusScope Class to use the FocusNode variable( priceFocusNode )
                    //todo: to move the focus from one input to the other.
                    //todo: Using the requestFocus () method which takes the FocusNode variable( priceFocusNode )
                    FocusScope.of(context).requestFocus(priceFocusNode);
                  },


                  //Todo: STEP 5 - execute a function on onSaved to save the value by updating the
                          //todo: the initialized editProducts variable

                  onSaved: (value){
                    editedProducts = Products(
                      title: value,
                      price: editedProducts.price,
                      description: editedProducts.description,
                      imageUrl: editedProducts.imageUrl,

                      //Todo: Maintaining the id and the value so that it doesn't get lost
                      id: editedProducts.id,
                      isFavourite: editedProducts.isFavourite

                    );
                  },

                ),


                //TODO: GETTING PRICE
                TextFormField(
                  initialValue: initProduct['price'],
                  decoration: InputDecoration(
//                    hintText: "Price",
                    labelText: "Price",
                    helperText: "Enter product's price"
                  ),

                  validator: (value){
                    if(value.isEmpty){
                      return "Please enter the price!";
                    }

                    else if(double.tryParse(value) == null){
                      return "Please enter a valid number";
                    }

                    else if(double.parse(value) <= 0){
                      return "Please enter number greater than 0";
                    }
                    else
                      return null;
                  },

                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,

                  //Todo: 2. Assigning and Pointing to the correct focus node
                  focusNode: priceFocusNode,

                  onFieldSubmitted: (_){
                    FocusScope.of(context).requestFocus(quantityFocusNode);
                  },

                  onSaved: (value){
                    editedProducts = Products(
                        title: editedProducts.title,
                        price: double.parse(value),
                        description: editedProducts.description,
                        imageUrl: editedProducts.imageUrl,

                        //Todo: Maintaining the id and the value so that it doesn't get lost
                        id: editedProducts.id,
                        isFavourite: editedProducts.isFavourite

                    );
                  },

                ),

                //TODO: GETTING DESCRIPTION
                TextFormField(
                  initialValue: initProduct['description'],
                  decoration: InputDecoration(
                      labelText: "Description",
                      helperText: "Enter product's description"
                  ),

                  validator: (value){
                    if(value.isEmpty){
                      return "Please provide the description!";
                    }

                    else if(value.length < 10){
                      return "Must be atleast 10 characters long!";
                    }

                    else
                      return null;
                  },

                  textInputAction: TextInputAction.next,

                  //Todo: Using maxLines argument, to set the number of lines to display
                  //todo: for the input field.
                  maxLines: 3,

                  //Todo: Using special keyboard type multiline
                  keyboardType: TextInputType.multiline,


                  focusNode: quantityFocusNode,
                  onFieldSubmitted: (_){
                    FocusScope.of(context).requestFocus(imageFocusNode);
                  },

                  onSaved: (value){
                    editedProducts = Products(
                        title: editedProducts.title,
                        price: editedProducts.price,
                        description: value,
                        imageUrl: editedProducts.imageUrl,

                        //Todo: Maintaining the id and the value so that it doesn't get lost
                        id: editedProducts.id,
                        isFavourite: editedProducts.isFavourite

                    );
                  },

                ),

                //TODO: GETTING IMAGE URL
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[

                //Todo: To get the image url
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                        labelText: "Image",

                      ),

                        validator: (value) {

                          if(value.isEmpty){
                            return "Please provide the image URL!";
                          }

                          //Todo: Using startsWith() method to check if the image Url starts
                          //todo: with 'http/https'
                          else if(!value.startsWith("http") || !value.startsWith("https")){
                            return "Please enter a valid URL!";
                          }

                          //Todo: Using endsWith() method to check if the image URL ends with
                          //todo: a valid image format
                          else if(!value.endsWith(".png") && !value.endsWith(".jpg")){
                            return "Image format is unsupported!";
                          }

                          else
                            return null;

                        },


                        //TODO: PROBLEM - can't use both initialValue and controller together
//                        initialValue: initProduct['imageUrl'],
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: imageUrlController,

                        //Todo: PROBLEM to solve - May loose the imageFocusNode when switching to the
                        //todo: next input ie when the focus changes.
                        focusNode: imageFocusNode,

                        onFieldSubmitted: (value){
                         // print(value);
                          //Todo: saving all the form data
                          saveFormData();

                        },

                        onSaved: (value){
                          editedProducts = Products(
                            imageUrl: value,
                            title: editedProducts.title,
                            description: editedProducts.description,
                            price: editedProducts.price,

                              //Todo: Maintaining the id and the value so that it doesn't get lost
                              id: editedProducts.id,
                              isFavourite: editedProducts.isFavourite
                          );



                        },

                      ),
                    ),


                    //Todo: Container to display the image
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top: 10, left: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Theme.of(context).primaryColor,
                        )
                      ),

                      child: imageUrlController.text.isEmpty ?
                      Text(
                        "Enter image Url!",
                        style: TextStyle(color: Theme.of(context).errorColor),
                      )
                      : FittedBox(
                          child: Image.network(imageUrlController.text),
                          fit: BoxFit.cover,
                      ),
                    ),


                  ],
                )



              ],
            ),
          )

      ),
    );
  }
}
