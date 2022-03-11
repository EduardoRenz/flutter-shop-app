import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/components/auth_form.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color.fromRGBO(215, 117, 255, 0.5),
            Color.fromRGBO(255, 188, 117, 0.9),
          ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
        ),
        SizedBox(
          width: double.infinity,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  transform: Matrix4.rotationZ(-8 * pi / 180)..translate(-10.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.deepOrange.shade900,
                      boxShadow: const [
                        BoxShadow(
                            blurRadius: 8,
                            offset: Offset(0, 2),
                            color: Colors.black26)
                      ]),
                  child: Text(
                    'My Shop',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 45,
                        fontFamily: 'Anton',
                        color: Theme.of(context)
                            .primaryTextTheme
                            .headline6!
                            .color),
                  ),
                ),
                AuthForm()
              ]),
        )
      ]),
    );
  }
}
