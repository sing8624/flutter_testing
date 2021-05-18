import 'package:flutter/material.dart';
import 'package:flutter_testing/models/Coffee.dart';
import 'package:flutter_testing/screens/home/coffee_list.dart';
import 'package:flutter_testing/screens/home/setting_form.dart';
import 'package:flutter_testing/services/auth.dart';
import 'package:flutter_testing/services/database.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: SettingsForm(),
            );
          });
    }

    return StreamProvider<List<Coffee>>.value(
      value: DatabaseService().coffees,
      initialData: null,
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('Coffee Shop'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
            FlatButton.icon(
                onPressed: () => _showSettingsPanel(),
                icon: Icon(Icons.settings),
                label: Text('Settings'))
          ],
        ),
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/coffee_bg.png'), fit: BoxFit.cover),
            ),
            child: CoffeeList()),
      ),
    );
  }
}
