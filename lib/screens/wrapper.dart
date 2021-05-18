import 'package:flutter/material.dart';
import 'package:flutter_testing/models/user.dart';
import 'package:flutter_testing/screens/authenticate/authenticate.dart';
import 'package:flutter_testing/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser>(context);
    print(user);
    //return either Home or Authenticate Widget
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
