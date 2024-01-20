import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Pokedex extends StatefulWidget {
  const Pokedex({super.key});

  @override
  State<Pokedex> createState() => _PokedexState();
}

class _PokedexState extends State<Pokedex> {
  CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('users');

  Future<List> _getCaught() async {
    User? user = FirebaseAuth.instance.currentUser;
    QuerySnapshot qSnapshot =
        await collectionRef.doc(user?.uid).collection('caught').get();

    return qSnapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<int> _getNumCaught() async {
    User? user = FirebaseAuth.instance.currentUser;
    AggregateQuerySnapshot qSnapshot =
        await collectionRef.doc(user?.uid).collection('caught').count().get();

    return qSnapshot.count;
  }

  List<String> caughtPokes = [];
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 150, height: 150, child: pokedexWidget());
  }

  Widget pokedexWidget() {
    return FutureBuilder(
      future: _getCaught(),
      builder: (context, snapshot) {
        if (snapshot.hasData == false) {
          return const Text("Loading...");
        }
        return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Text(snapshot.data![index]['name'].toString());
            });
      },
    );
  }
}
