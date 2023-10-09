import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PokeyName {
  final String name;

  const PokeyName({
    required this.name,
  });
}

Future<Map<String, dynamic>> fetchPost() async {
  final response =
      await http.get(Uri.parse("http://pokeapi.co/api/v2/pokemon/?limit=811"));
  if (response.statusCode == 200) {
    Map<String, dynamic> post = jsonDecode(response.body);
    return post;
  } else {
    throw Exception("Failed to load post");
  }
}

class PokeNames extends StatefulWidget {
  final String? guessInput;
  const PokeNames({super.key, required this.guessInput});

  @override
  PokeNamesState createState() => PokeNamesState();
}

class PokeNamesState extends State<PokeNames> {
  Future<Map<String, dynamic>>? _post;
  List<PokeyName>? pokeyNames = [];
  List<PokeyName>? filteredNames = [];

  @override
  void initState() {
    super.initState();

    _post = fetchPost();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _post,
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            for (int i = 0; i < 811; i++) {
              pokeyNames
                  ?.add(PokeyName(name: snapshot.data['results'][i]['name']));
            }
            return pokeList(snapshot);
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return const CircularProgressIndicator();
        });
  }

  filterNames() {
    filteredNames = [];
    if (widget.guessInput == "") {
      return filteredNames = pokeyNames;
    }
    for (int i = 0; i < 811; i++) {
      if (widget.guessInput!.length < pokeyNames![i].name.length) {
        if (pokeyNames![i].name.contains(widget.guessInput.toString())) {
          filteredNames?.add(pokeyNames![i]);
        }
      }
    }
  }

  SizedBox pokeList(AsyncSnapshot<dynamic> snapshot) {
    filterNames();
    return SizedBox(
      height: 100,
      child: ListView.builder(
          itemCount: filteredNames?.length,
          itemBuilder: (BuildContext context, int index) {
            return Text(filteredNames![index].name);
          }),
    );
  }
}
