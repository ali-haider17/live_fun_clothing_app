import 'package:flutter/material.dart';

//TODO: 1. CREATING A CUSTOM PAGE ROUTE/NEW SCREEN

//Todo: Creating a CustomRoute class of generic type and also extending
//todo: MaterialPageRoute which is of generic type
//todo: to be used for single routes
class CustomRoute<T> extends MaterialPageRoute<T>{

  //Todo: Creating a constructor that get a WidgetBuilder and RouteSetting
  CustomRoute({
    WidgetBuilder builder,
    RouteSettings settings

    //Todo: Now to forward these arguments to the parent class using :super
  }): super(builder: builder, settings: settings);


  //Todo: Important - Adding a buildTransitions method which is part of the
  //todo: MaterialPageRoute and controls how the page transition is animated
  //todo: and can set our own animation by overriding
  @override
  Widget buildTransitions(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child
      ) {

    //Todo: Check if settings is the initial route which means this is te first
    //todo: route that loads in the app, then return a child which is the
    //todo: page being navigated to. Cause dont want to animate the first page
    //todo: from being loaded
    if(settings.isInitialRoute)
      {
        return child;
      }

    else{
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    }

//    return super.buildTransitions(context, animation, secondaryAnimation, child);
  }
}

//TODO: 4. CREATING A CUSTOM PAGE ROUTE/NEW SCREEN
//Todo: Creating a custom PageTransitionBuilder class
//todo: to be used for general theme which affects all
//todo: route transitions

class CustomPageTransitionBuilder extends PageTransitionsBuilder{

  CustomPageTransitionBuilder({
    WidgetBuilder builder,
    RouteSettings settings
  });

  @override
  Widget buildTransitions<T>(
      //Todo: Defining a PageRoute
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child
      ) {

    if(route.settings.isInitialRoute)
    {
      return child;
    }

    else{
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    }

//    return super.buildTransitions(context, animation, secondaryAnimation, child);
  }
}