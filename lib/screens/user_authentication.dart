import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/authentication.dart';
import '../model/http_exception.dart';

//TODO: USER SIGN-UP & SIGN-IN FORMS

//Todo: To switch between two modes of forms
enum AuthenticationMode {
  Signup,
  Login
}

class AuthenticationScreen extends StatelessWidget {
  static const routeName = '/authentication';

  @override
  Widget build(BuildContext context) {

    //Todo: Fetching device size
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [1, 1],
              ),
            ),
          ),

          SingleChildScrollView(
            child: Container(

              //Todo: To take the full width and height of the device
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.0),
                      padding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 50.0),

                      //TODO: :transform" argument which is supported by Container, allows to
                      //todo: transform how the container is displayed/transformed (i-e to rotate it,
                      //todo: scale it or move it)
                      //todo: takes Matrix4 object which describes transformation of the container

                      //Todo: Matrix4 allows to describe the rotation, scaling and offset of a container
                      //todo: all in one object.
                      //todo: All n all contains a bundle of information on how to position and
                      //todo: transform this container

                      //Todo: Using 'rotationZ constructor' which constructs a new Matrix4 object
                      //todo: (rotation along the z-axis)
                      //todo: has a 'translate method' which adds some offset to the Matrix4 object
                      //todo: translate method returns a void
                      //todo: translate does not return a new object but edits that object on which
                      //todo: it's called (i-e Matrix4 object)

                      //Todo: Problem: Transform needs a Matrix4 object not a void which using
                      //todo: .translate we get if we use directly as:
                      //                        //todo: Matrix4.rotationZ(-8 * pi / 180).translate(-10.0)

                      //Todo: Solution: Using dot dot operator(..) calls translate on that object
                      //todo: (as ..translate()) but does not return what translate returns
                      //todo: rather it returns what the previous notation (.rotationsZ())
                      //todo: returns

                      //todo: this Cascade operator, simply a replacement for having a variable
                      //todo: and multiple lines of code to set something up and call
                      //todo: something on that and use the originally set up object(4Matrix4)

                      //Todo: Alternate solution: Changing the Matrix4 object from inside
                      //todo: final transformConfig = Matrix4.rotationZ(-8 * pi /180);
                      //todo: transformConfig.tranlate(-10.0);

                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrangeAccent,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(
                        'Live Fun Clothing',
                        style: TextStyle(
                          color: Theme.of(context).accentTextTheme.title.color,
                          fontSize: 30,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthenticationCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthenticationCard extends StatefulWidget {
  const AuthenticationCard({
    Key key,
  }) : super(key: key);

  @override
  _AuthenticationCardState createState() => _AuthenticationCardState();
}

//TODO:3. BUILD AN ANIMATION
//Todo: SingleTickerProviderStateMixin add a couple of methods to this state which can
//todo: be implicitly used by vsync or animation controller to find out if it's
//todo: currently visible or not
class _AuthenticationCardState extends State<AuthenticationCard> with SingleTickerProviderStateMixin {

  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthenticationMode _authenticationMode = AuthenticationMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();


  //TODO:1. BUILD AN ANIMATION
  //Todo: 1. Setting up an AnimationController
  //todo: which is a class that helps with controlling animations.
  AnimationController _animationController;

  //Todo: 2. Setting up an Animation object
  //todo: it is a generic type so need to tell Dart what to animate (such as Size)
  //Animation<Size> _heightAnimation;

  //Todo: 2. Using SLIDETRANSITION
  //Todo: Defining an animation with an offset type
  Animation<Offset> _slideAnimation;

  //TODO: 2. USING FADETRANSITION WIDGET
  //Todo: Adding a new Animation to animate opacity which is value anywhere
  //todo: from 0 to 0.1,0.2 ... (double)

  Animation<double> _opacityAnimation;



  //TODO:2. BUILD AN ANIMATION
  //todo: Using initState to set up the controller & animation.
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //Todo: AnimationController takes two arguments,
    //todo: 1. vsync = pointing to the object/widget which should be watched
    //todo: and play the animation only when that widget is visible. This, also
    //todo: optimizes the performance. Here for this to work, need to add a
    //todo: mixin (SingleTickerProviderStateMixin) for AnimationController

    //Todo: 2. duration = specifying the duration of the animation
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(microseconds: 300)
    );

//    //Todo: Animation object requires a Tween() class, is also a generic type
//    //todo: which gives an object that knows how to animate b/w two values
//    //todo: Also, need to call 'animate' method in the end to create an animation object
//    //todo: describing how to animate
//      _heightAnimation = Tween<Size>(
//      begin: Size(double.infinity, 260),
//      end: Size(double.infinity, 320)).
//
//      animate(
//      //Todo: Using a CurvedAnimation constructon
//      //Todo: 1. parent = pointing out to the animationController by which it
//      //todo: should be controlled
//
//      //Todo: 2. curve = defines how the duration time in animationController is
//      //todo: split up
//
//      CurvedAnimation(
//          parent: _animationController,
//          curve: Curves.easeOut)
//      );

    //Todo: 2. Using SLIDETRANSITION
    //Todo: Setting up slideAniamtion
      _slideAnimation = Tween<Offset>(

        //Todo: Now offset takes an x-axis and a y-axis
      begin: Offset(0, -1.5),
      end: Offset(0, 0)).

      animate(
      //Todo: Using a CurvedAnimation constructon
      //Todo: 1. parent = pointing out to the animationController by which it
      //todo: should be controlled

      //Todo: 2. curve = defines how the duration time in animationController is
      //todo: split up

      CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeOut)
      );


    //TODO: 3. USING FADETRANSITION WIDGET
    //Todo: Setting up the opacityAnimation

    _opacityAnimation =  Tween(
      begin: 0.0, //invisible
      end: 1.0, //visible
    ).animate(
        CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOut)
    );


    //TODO:6. BUILD AN ANIMATION
    //Todo: Need to add a listener to call setState whenever this animation updates to
    //todo: just redraw the screen (leave it empty)
//    _heightAnimation.addListener((){
//      setState(() {
//
//      });
//    });

  }

  //TODO:6. BUILD AN ANIMATION
  //Todo: Need to dispose the listener afterwards
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
  }


  //TODO: 2. HANDLING AUTHENTICATION ERRORS
  void showErrorDialog(String message){
    showDialog(context: context,
      builder: (context){
        return AlertDialog(
          title: Text("Error Occurred!"),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok"),
              onPressed: (){
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

      try{
        if (_authenticationMode == AuthenticationMode.Login) {
        //TODO: ADDING USER SIGN-IN
        await Provider.of<Authentication>(context, listen: false).SignIn(
          _authData['email'],
          _authData['password'],
        );
      } else {
      //TODO:  ADDING USER SIGN-UP
      await Provider.of<Authentication>(context, listen: false).SignUp(
        _authData['email'],
        _authData['password'],
      );
    }
    }

    //Todo: Using 'on' keyword to check/filter for a specific kind of error
    //todo: Here 'HttpException' is used as the type of class/exception to handle

      on HttpException catch(error){

        //Todo: Default error message
        var errorMessage = "Authentication Failed!";
        if(error.toString().contains("EMAIL_EXISTS")){
          errorMessage = "This email address already exists!";
        }

        else if(error.toString().contains("INVALID_EMAIL")){
          errorMessage = "This email address is invalid!";
        }

        else if(error.toString().contains("INVALID_PASSWORD")){
          errorMessage = "This password is invalid!";
        }

        showErrorDialog(errorMessage);
      }

      //Todo: To handle errors not of type HttpException
      catch(error){
        const errorMessage = "Could not authenticate at the moment! Please try again later!";
      }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {


    if (_authenticationMode == AuthenticationMode.Login) {
      setState(() {
        _authenticationMode = AuthenticationMode.Signup;
      });

      //TODO:5. BUILD AN ANIMATION
      //Todo: Starting the animation using forward method
      _animationController.forward();

    } else {
      setState(() {
        _authenticationMode = AuthenticationMode.Login;
      });

      //Todo: Playing back the animation using reverse method
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,


      //TODO: USING ANIMATEDBUILDER WIDGET
      //todo: instead of managing the animation with listener (manually)
      //todo: helps with efficiently controlling animations on part of a screen
      //todo: to render a part of a widget when something changes
      //todo: take two arguments, animation and builder

      //todo: can also define a child argument that won't be re-rendered
      //todo: on animation
//      child: AnimatedBuilder(
//        animation: _heightAnimation,
//        builder: (ctx, child){
//          return Container(
//              //TODO:4. BUILD AN ANIMATION
//              //Todo: Connecting animation to widget
//
////        height: _authenticationMode == AuthenticationMode.Signup ? 320 : 260,
//              height: _heightAnimation.value.height,
//              constraints:
////        BoxConstraints(minHeight: _authenticationMode == AuthenticationMode.Signup ? 320 : 260),
//              BoxConstraints(minHeight: _heightAnimation.value.height),
//          width: deviceSize.width * 0.75,
//          padding: EdgeInsets.all(16.0),
//          child: child
//          );
//
//          },
//
//          //Todo: this child is being passed as the child argument in the builder
//        //todo: to the Container widget and this will not be re-rendered.
//          child:  Form(
//            key: _formKey,
//            child: SingleChildScrollView(
//              child: Column(
//                children: <Widget>[
//                  TextFormField(
//                    decoration: InputDecoration(labelText: 'E-Mail'),
//                    keyboardType: TextInputType.emailAddress,
//                    validator: (value) {
//                      if (value.isEmpty || !value.contains('@')) {
//                        return 'Invalid email!';
//                      }
//                    },
//                    onSaved: (value) {
//                      _authData['email'] = value;
//                    },
//                  ),
//                  TextFormField(
//                    decoration: InputDecoration(labelText: 'Password'),
//                    obscureText: true,
//                    controller: _passwordController,
//                    validator: (value) {
//                      if (value.isEmpty || value.length < 5) {
//                        return 'Password is too short!';
//                      }
//                    },
//                    onSaved: (value) {
//                      _authData['password'] = value;
//                    },
//                  ),
//                  if (_authenticationMode == AuthenticationMode.Signup)
//                    TextFormField(
//                      enabled: _authenticationMode == AuthenticationMode.Signup,
//                      decoration: InputDecoration(labelText: 'Confirm Password'),
//
//                      //Todo: ObscureText argument ensures that the input is not shown
//                      //todo: to the user (i-e have some stars masking the user input)4
//                      obscureText: true,
//                      validator: _authenticationMode == AuthenticationMode.Signup
//                          ? (value) {
//                        if (value != _passwordController.text) {
//                          return 'Passwords do not match!';
//                        }
//                      }
//                          : null,
//                    ),
//                  SizedBox(
//                    height: 20,
//                  ),
//                  if (_isLoading)
//                    CircularProgressIndicator()
//                  else
//                    RaisedButton(
//                      child:
//                      Text(_authenticationMode == AuthenticationMode.Login ? 'LOGIN' : 'SIGN UP'),
//                      onPressed: _submit,
//                      shape: RoundedRectangleBorder(
//                        borderRadius: BorderRadius.circular(30),
//                      ),
//                      padding:
//                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
//                      color: Theme.of(context).primaryColor,
//                      textColor: Theme.of(context).primaryTextTheme.button.color,
//                    ),
//                  FlatButton(
//                    child: Text(
//                        '${_authenticationMode == AuthenticationMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
//                    onPressed: _switchAuthMode,
//                    padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
//
//                    //Todo: materialTapTargetSize argument reduces the amount of surface one can hit
//                    //todo: with the finger to trigger the button
//                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                    textColor: Theme.of(context).primaryColor,
//                  ),
//                ],
//              ),
//            ),
//          ),
//

    //TODO: USING ANIMATEDCONTAINER WIDGET
    //Todo: it does all the heavy lifting such as efficiently running the animation
    //todo: and automatically transitioning between change in its configuration
    //Todo: it automatically detects that the value(_authenticationMode == AuthenticationMode.Signup ? 320 : 260)
    //todo: changed and animates between the value.

    //Todo: And therefore does not need a Animation controller anymore as it starts and
    //todo: reverses the animation automatically

    //Todo: It requires a duration argument as to how long it takes and need to configure the curve as well
    //todo: to show how the animation looks like
      child: AnimatedContainer(
        duration: Duration(microseconds: 300),
        curve: Curves.easeOut,
        child: Container(
              //TODO:4. BUILD AN ANIMATION
              //Todo: Connecting animation to widget

        height: _authenticationMode == AuthenticationMode.Signup ? 320 : 260,
//              height: _heightAnimation.value.height,
              constraints:
        BoxConstraints(minHeight: _authenticationMode == AuthenticationMode.Signup ? 320 : 260),
//              BoxConstraints(minHeight: _heightAnimation.value.height),
          width: deviceSize.width * 0.75,
          padding: EdgeInsets.all(16.0),
  
          child:  Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'E-Mail'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Invalid email!';
                      }
                    },
                    onSaved: (value) {
                      _authData['email'] = value;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    controller: _passwordController,
                    validator: (value) {
                      if (value.isEmpty || value.length < 5) {
                        return 'Password is too short!';
                      }
                    },
                    onSaved: (value) {
                      _authData['password'] = value;
                    },
                  ),


//                  if (_authenticationMode == AuthenticationMode.Signup)

                    //TODO: 1. USING FADETRANSITION WIDGET
                    //Todo: It takes a child that fades in but unlike the Animated
                    //todo: container it does not take a duration and curve.
                    //todo: It needs opacity that needs to be changed dynamically
                    //todo: using animation or animation controller (suchas _animationOpacity
                    //todo: defined and set up above)

                    //Todo: FadeTransition will also automatically register a listener, just
                    //todo: need to be run using forward and reverse methods to play the animation

                  //Todo: Problem: There might be some empty space left reserved due to the
                        //todo: FadeTransition widget as it's never added/removed part of tree

                  //Todo: Solution: Wrap it with an AnimatedContainer Widget which
                  //todo: will add this widget and remove that reserved space using
                  //todo: constraints

                    AnimatedContainer(
                      duration: Duration(microseconds: 300),
                      curve: Curves.bounceOut,
                      constraints: BoxConstraints(
                        minHeight: _authenticationMode == AuthenticationMode.Signup ? 60 : 0,
                        maxHeight: _authenticationMode == AuthenticationMode.Signup ? 120 : 0,
                      ),

                      child: FadeTransition(
                        opacity: _opacityAnimation,

                        //TODO: ADDING A TRANSITION TO FADETRANSITION
                        //Todo: Using SLIDETRANSITION to add a slide transition
                        //Todo: Needs an animation object for the position argument
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: TextFormField(
                            enabled: _authenticationMode == AuthenticationMode.Signup,
                            decoration: InputDecoration(labelText: 'Confirm Password'),

                            //Todo: ObscureText argument ensures that the input is not shown
                            //todo: to the user (i-e have some stars masking the user input)4
                            obscureText: true,
                            validator: _authenticationMode == AuthenticationMode.Signup
                                ? (value) {
                              if (value != _passwordController.text) {
                                return 'Passwords do not match!';
                              }
                            }
                                : null,
                          ),
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  if (_isLoading)
                    CircularProgressIndicator()
                  else
                    RaisedButton(
                      child:
                      Text(_authenticationMode == AuthenticationMode.Login ? 'LOGIN' : 'SIGN UP'),
                      onPressed: _submit,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).primaryTextTheme.button.color,
                    ),
                  FlatButton(
                    child: Text(
                        '${_authenticationMode == AuthenticationMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                    onPressed: _switchAuthMode,
                    padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),

                    //Todo: materialTapTargetSize argument reduces the amount of surface one can hit
                    //todo: with the finger to trigger the button
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
        )
      )
    );
  }
}
