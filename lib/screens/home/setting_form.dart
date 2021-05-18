import 'package:flutter/material.dart';
import 'package:flutter_testing/models/user.dart';
import 'package:flutter_testing/services/database.dart';
import 'package:flutter_testing/shared/constants.dart';
import 'package:flutter_testing/shared/loading.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];
//form values

  String _currentName;
  String _currentSugars;
  int _currentStrength;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser>(context);
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData userdata = snapshot.data;
          return Form(
              key: _formKey,
              child: Column(
                children: [
                  Text('Update your Coffee', style: TextStyle(fontSize: 18)),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    initialValue: userdata.name,
                    decoration: textInputDecoration.copyWith(hintText: 'Name'),
                    validator: (val) =>
                        val.isEmpty ? 'Please enter a name' : null,
                    onChanged: (val) => setState(() => _currentName = val),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //dropdown here
                  DropdownButtonFormField(
                    decoration: textInputDecoration,
                    value: _currentSugars ?? userdata.sugars,
                    items: sugars.map((sugar) {
                      return DropdownMenuItem(
                        value: sugar,
                        child: Text('$sugar sugars'),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _currentSugars = val),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  //slider
                  Slider(
                    value: (_currentStrength ?? userdata.strength).toDouble(),
                    activeColor:
                        Colors.brown[_currentStrength ?? userdata.strength],
                    inactiveColor:
                        Colors.brown[_currentStrength ?? userdata.strength],
                    min: 100,
                    max: 900,
                    divisions: 8,
                    onChanged: (val) =>
                        setState(() => _currentStrength = val.round()),
                  ),
                  //button
                  RaisedButton(
                      color: Colors.pink[400],
                      child: Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          await DatabaseService(uid: user.uid).updateUserData(
                              _currentSugars ?? userdata.sugars,
                              _currentName ?? userdata.name,
                              _currentStrength ?? userdata.strength);
                          Navigator.pop(context);
                        }
                      })
                ],
              ));
        } else {
          return Loading();
        }
      },
    );
  }
}
