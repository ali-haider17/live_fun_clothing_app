import 'package:flutter/material.dart';

//Todo: 1. Need to import provides package to register the provider/class
import 'package:provider/provider.dart';

import './screens/product_detail.dart';
import './screens/home.dart';
import './screens/show_cart.dart';
import './screens/all_orders.dart';
import './screens/manage_products.dart';
import './screens/edit_product.dart';
import './screens/user_authentication.dart';
import './screens/loading.dart';

import './providers/products_provider.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/authentication.dart';

import './helper/custom_route.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {


    //Todo: 2. Wrap the MaterialApp widget with a provider (ChangeNotifierProvider)

    //Todo: MultiProvider allows to define a list of providers (multiple providers)
    //todo: needed and takes a child widget (e.g MaterialApp)

    return MultiProvider(
        providers: [
            ChangeNotifierProvider.value(
                value: Authentication(),
            ),

            ChangeNotifierProvider.value(
                value: Cart()
            ),

          //TODO: ATTACHING ORDERS TO USERS
          //todo: passing the userID to orders
            ChangeNotifierProxyProvider<Authentication, Orders>(
               update: (ctx, auth, previousOrdersState){
                 return Orders(auth.token, auth.userId, previousOrdersState == null ? [] : previousOrdersState.orders);
               },
            ),

            //TODO: 2. PASSING THE TOKEN
            //Todo: Using the ChangeNotifierProxyProvider which is a generic class
            //todo: and using <> brackets allows to set up a provider that depends
            //todo: on another provider itself (that provider must be defined before
            //todo: this dependent one)
            //todo: The first argument is <> brackets is the type of data being
            //todo: provider on which depend on, the other is the type of data
            //todo: provided

            //todo: The Provide package now looks for the Authentication object and
            //todo: pass it down to this provider

            //Todo: Also, this provider will be rebuilt when the dependent(Authentication)
            //todo: changes

            ChangeNotifierProxyProvider<Authentication, ProductsProvider>(
              //todo: takes a context and dynamic value (auth) and
              //todo: old providers state
              update: (ctx , auth, previousProductsState){
                return ProductsProvider(
                    auth.token,
                    auth.userId,
                    previousProductsState == null ? [] : previousProductsState.allproducts);
              },
            )
    ],

    //TODO: 1. NAVIGATING AFTER LOGGED IN
    child: Consumer<Authentication>(
          builder: (context, auth, _){
            return MaterialApp(
              title: "Live Fun CLothing",
              debugShowCheckedModeBanner: false,

              //TODO: 3. CREATING A CUSTOM PAGE ROUTE/NEW SCREEN
              //todo: applying animation to all page routes.

              theme: ThemeData(
                //Todo: Setting up a paget transition theme which takes a builder argument
                //todo: which is a map of different builder funtions for different OS,

                pageTransitionsTheme: PageTransitionsTheme(
                  builders: {
                    //todo: can also have different transitions for different OS (android/iOS)
                    //todo: (e.g TargetPlatform.android: - )the value after colon has to be a
                    //todo: builder function which defines how that should look like
                    //todo: takes a TransitionBuilder
                    TargetPlatform.android: CustomPageTransitionBuilder(),
                    TargetPlatform.iOS: CustomPageTransitionBuilder()
                  }
                ),

                  canvasColor: Colors.orangeAccent,
                  primarySwatch: Colors.deepOrange,
                  fontFamily: "Anton",
                  textTheme: ThemeData.light().textTheme.copyWith(
                    title: TextStyle(fontFamily: "Lato", fontSize: 24),

                  )
              ),

              routes: {
                ProductDetail.routeName: (ctx) => ProductDetail(),
                ShowCartScreen.routeName: (ctx) => ShowCartScreen(),
                OrdersScreen.routeName: (ctx) => OrdersScreen(),
                HomePage.routeName: (ctx) => HomePage(),
                ManageProductScreen.routeName: (ctx) => ManageProductScreen(),
                EditProductScreen.routeName : (ctx) => EditProductScreen(),
                AuthenticationScreen.routeName : (ctx) => AuthenticationScreen(),
              },

              //TODO: 4. NAVIGATING AFTER LOGGED IN
              //Todo: Using the authenticate instance above in Consumer to fetch the
              //todo: getter method (isLoggedIn)
              home: auth.isLoggedIn ? HomePage()

              //TODO:3. AUTOMATICALLY LOGGING USERS IN
              //Todo: if not logged in Using FutureBuilder use the future automaticallyLogin
                  : FutureBuilder(
                      future: auth.automaticallyLogin(),
                      builder: (ctx, authResult){
                        return authResult.connectionState == ConnectionState.waiting
                            ? LoadingScreen()
                        :AuthenticationScreen();
                      },
                    )
                     ,

            );

          },
        ),
    );
  }
}