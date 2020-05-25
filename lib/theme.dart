import 'package:flutter/material.dart';

class BuildTheme {

  static final lightTheme = ThemeData(
      textTheme: TextTheme(
        headline5: TextStyle(
            fontFamily: 'Metropolis',
            fontSize: 115.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 2
        ),
        // Used for the page title:
        headline6: TextStyle(
            fontFamily: 'Metropolis',
            fontWeight: FontWeight.bold,
            color: Colors.white
        ),
        // For subtitle1ings in the page
        subtitle1: TextStyle(
          fontFamily: 'Metropolis',
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 18.0,
        ),
        // For main body text
        bodyText2: TextStyle(
          fontFamily: 'Metropolis',
          color: Colors.green,
          fontWeight: FontWeight.w600,
        ),
        // For smaller body text
        bodyText1: TextStyle(
            fontFamily: 'Metropolis',
            color: Colors.green
        ),
        // Used for any captions also the default for the bottom nav bar:
        caption: TextStyle(
          fontFamily: 'Metropolis',
          color: Colors.black,
        ),
        // Could be useful later
        subtitle2: TextStyle(
          fontFamily: 'Metropolis',
          color: Colors.black,
        ),
        button: TextStyle(
          fontFamily: 'Metropolis',
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 18.0,
        ),
        overline: TextStyle(
          fontFamily: 'Metropolis',
          fontSize: 15,
        ),
      ),
      primaryColor: Colors.green,
      indicatorColor: Colors.green,
      scaffoldBackgroundColor: Colors.white,
      accentColor: Colors.green,
      buttonColor: Colors.white,
      backgroundColor: Colors.white,
      tabBarTheme: TabBarTheme(
        labelColor: Colors.green,
        unselectedLabelColor: Colors.grey,
      )
  );
  static final darkTheme = ThemeData(
      textTheme: TextTheme(
        headline5: TextStyle(
            fontFamily: 'Metropolis',
            fontSize: 115.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 2
        ),
        // Used for the page title:
        headline6: TextStyle(
            fontFamily: 'Metropolis',
            fontWeight: FontWeight.bold,
            color: Colors.white
        ),
        // For subtitle1ings in the page
        subtitle1: TextStyle(
          fontFamily: 'Metropolis',
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 18.0,
        ),
        // For main body text
        bodyText2: TextStyle(
          fontFamily: 'Metropolis',
          color: Colors.green,
          fontWeight: FontWeight.w600,
        ),
        // For smaller body text
        bodyText1: TextStyle(
            fontFamily: 'Metropolis',
            color: Colors.green
        ),
        // Used for any captions also the default for the bottom nav bar:
        caption: TextStyle(
          fontFamily: 'Metropolis',
          color: Colors.black,
        ),
        // Could be useful later
        subtitle2: TextStyle(
          fontFamily: 'Metropolis',
          color: Colors.black,
        ),
        button: TextStyle(
          fontFamily: 'Metropolis',
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 18.0,
        ),
        overline: TextStyle(
          fontFamily: 'Metropolis',
          fontSize: 15,
        ),
      ),
      primaryColor: Colors.indigo,
      indicatorColor: Colors.indigo,
      scaffoldBackgroundColor: Colors.grey,
      accentColor: Colors.indigoAccent,
      buttonColor: Colors.white,
      backgroundColor: Colors.grey,
      tabBarTheme: TabBarTheme(
        labelColor: Colors.indigo,
        unselectedLabelColor: Colors.grey,
      )
  );
}


