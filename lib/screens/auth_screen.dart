import 'package:flutter/material.dart';

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
        Container(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    'My Shop',
                    style: TextStyle(
                        fontSize: 45,
                        fontFamily: 'Anton',
                        color: Theme.of(context)
                            .primaryTextTheme
                            .headline6!
                            .color),
                  ),
                )
              ]),
        )
      ]),
    );
  }
}
