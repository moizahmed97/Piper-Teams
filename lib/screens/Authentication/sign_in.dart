import 'package:flutter/material.dart';
import 'package:piper_team_tasks/services/auth.dart';
import 'package:piper_team_tasks/widgets/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> with SingleTickerProviderStateMixin {
  Animation animation, delayedAnimation, muchDelayedAnimation;

  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    animation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        curve: Curves.easeIn, parent: animationController));

    delayedAnimation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        curve: Interval(0.5, 1.0, curve: Curves.easeIn),
        parent: animationController));

    muchDelayedAnimation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        curve: Interval(0.8, 1.0, curve: Curves.easeIn),
        parent: animationController));
  }

  final textInputDecoration = InputDecoration(
    fillColor: Colors.grey[100],
    filled: true,
    contentPadding: EdgeInsets.all(12.0),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 2.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.tealAccent, width: 2.0),
    ),
  );

  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;
  final AuthService _auth = AuthService();
  // text field state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    animationController.forward();
    return loading
        ? Loading()
        : AnimatedBuilder(
            animation: animationController,
            builder: (BuildContext context, Widget child) {
              return Scaffold(
                  // resizeToAvoidBottomInset: false,
                  appBar: AppBar(
                    elevation: 0.0,
                    title: Text('Login',
                        style: Theme.of(context).textTheme.headline6),
                    actions: <Widget>[
                      FlatButton.icon(
                        icon: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        label: Text("Register",
                            style: TextStyle(color: Colors.white)),
                        onPressed: () => widget.toggleView(),
                      )
                    ],
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Transform(
                          transform: Matrix4.translationValues(
                              animation.value * width, 0.0, 0.0),
                          child: Container(
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  padding:
                                      EdgeInsets.fromLTRB(15.0, 40.0, 0.0, 0.0),
                                  child: Text('Welcome Back To',
                                      style: TextStyle(
                                        fontSize: 40.0,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      16.0, 100.0, 0.0, 0.0),
                                  child: Text('Piper Team Tasks',
                                      style: TextStyle(
                                          fontSize: 40.0,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Transform(
                          transform: Matrix4.translationValues(
                              delayedAnimation.value * width, 0.0, 0.0),
                          child: Container(
                              padding: EdgeInsets.only(
                                  top: 35.0, left: 20.0, right: 20.0),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: <Widget>[
                                    TextFormField(
                                      validator: (val) =>
                                          val.isEmpty ? 'Enter an email' : null,
                                      onChanged: (val) {
                                        setState(() => email = val);
                                      },
                                      decoration: InputDecoration(
                                          labelText: 'EMAIL',
                                          labelStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.green))),
                                    ),
                                    SizedBox(height: 20.0),
                                    TextFormField(
                                      validator: (val) => val.length < 6
                                          ? 'Enter a password 6+ chars long'
                                          : null,
                                      onChanged: (val) {
                                        setState(() => password = val);
                                      },
                                      decoration: InputDecoration(
                                          labelText: 'PASSWORD',
                                          labelStyle: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.green))),
                                      obscureText: true,
                                    ),
                                    SizedBox(height: 30.0),
                                    RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 12),
                                        elevation: 7.0,
                                        child: Center(
                                          child: Text(
                                            'LOGIN',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        color: Colors.teal,
                                        onPressed: () async {
                                          if (_formKey.currentState
                                              .validate()) {
                                            setState(() => loading = true);
                                            dynamic result = await _auth
                                                .signInWithEmailAndPassword(
                                                    email, password);
                                            if (result == null) {
                                              setState(() {
                                                loading = false;
                                                error =
                                                    'Could not sign in with those credentials';
                                              });
                                            } else if (result == 1) {
                                              setState(() {
                                                loading = false;
                                                error =
                                                    'You are not connected to the Internet';
                                              });
                                            }
                                          }
                                        }),
                                    SizedBox(height: 12.0),
                                    Text(
                                      error,
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 14.0),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        SizedBox(height: 15.0),
                        Transform(
                          transform: Matrix4.translationValues(
                              muchDelayedAnimation.value * width, 0.0, 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'New to Piper Teams ?',
                                style: TextStyle(fontSize: 22),
                              ),
                              SizedBox(width: 5.0),
                              InkWell(
                                onTap: () {
                                  widget.toggleView();
                                },
                                child: Text(
                                  'Register',
                                  style: TextStyle(
                                      color: Colors.indigo,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      fontSize: 22),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ));
            },
          );
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }
}
