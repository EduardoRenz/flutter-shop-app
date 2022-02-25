import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';

void _handleURL(Uri uri, BuildContext context) {
  //print(uri);

  //final path = uri.path;
  //final args = uri.queryParameters;

  //Navigator.pushReplacementNamed(context, path);
}

StreamSubscription<Uri?> handleIncomingLinks(BuildContext context) {
  StreamSubscription<Uri?> _sub = uriLinkStream.listen((Uri? uri) {
    print('got uri: $uri');
    if (uri != null) {
      _handleURL(uri, context);
    }
  }, onError: (Object err) {
    print('got err: $err');
  });
  return _sub;
}

Future<void> handleInitialUri() async {
  try {
    final uri = await getInitialUri();
    if (uri == null) {
      print('no initial uri');
    } else {
      print('got initial uri: $uri');
    }
  } on PlatformException {
    // Platform messages may fail but we ignore the exception
    print('falied to get initial uri');
  } on FormatException catch (err) {
    print('malformed initial uri');
  }
}
