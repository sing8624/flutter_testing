import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_testing/models/Coffee.dart';
import 'package:flutter_testing/models/user.dart';

class DatabaseService {
  //collection referece
  final CollectionReference dbCollection =
      FirebaseFirestore.instance.collection("coffee");
  final String uid;
  DatabaseService({this.uid});

  Future updateUserData(String sugar, String name, int strength) async {
    return await dbCollection.doc(uid).set({
      'sugars': sugar,
      'name': name,
      'strength': strength,
    });
  }

  List<Coffee> _coffeeListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      //print(doc.data);
      return Coffee(
          name: doc.get('name') ?? '',
          strength: doc.get('strength') ?? 0,
          sugars: doc.get('sugars') ?? '0');
    }).toList();
  }

  // get brews stream
  Stream<List<Coffee>> get coffees {
    return dbCollection.snapshots().map(_coffeeListFromSnapshot);
  }

//user data from snapshots;
  UserData _userDataFromSnapShots(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.get('name'),
      sugars: snapshot.get('sugars'),
      strength: snapshot.get('strength'),
    );
  }

//get user doc strean
  Stream<UserData> get userData {
    return dbCollection.doc(uid).snapshots().map(_userDataFromSnapShots);
  }
}
