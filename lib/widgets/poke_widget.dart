import 'package:flutter/material.dart';
import 'dart:math'; // For randomizing pokemon
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Pokemon {
  final String name;
  final String sprite;
  final int pokedexNo;
  const Pokemon({
    required this.name,
    required this.sprite,
    required this.pokedexNo,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'],
      sprite: json['sprites']['front_default'],
      pokedexNo: json['id'],
    );
  }
}

class PokeWidget extends StatefulWidget {
  const PokeWidget({Key? key}) : super(key: key);

  @override
  PokeState createState() => PokeState();
}

class PokeState extends State<PokeWidget> {
  Future<Pokemon>? futurePokemon;

  @override
  void initState() {
    super.initState();
    var pokeRandomizer = Random().nextInt(500);
    //Get a random pokemon by pokedex number
    fetchPokemon('https://pokeapi.co/api/v2/pokemon/$pokeRandomizer')
        .then((pokemon) {
      setState(() {
        futurePokemon = Future.value(pokemon);
      });
    }).catchError((error) {
      print('Error: $error');
    });
  }

  Future<Pokemon> fetchPokemon(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Pokemon.fromJson(convert.jsonDecode(response.body));
    } else {
      throw Exception('Failed to load Pokemon');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<Pokemon>(
        future: futurePokemon,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Column(children: [
              Text(snapshot.data?.name ?? "Loading Pokemon..."),
              Text(snapshot.data?.pokedexNo.toString() ??
                  "Loading Pokedex Number"),
              if (snapshot.data == null)
                const CircularProgressIndicator()
              else
                Image.network(snapshot.data!.sprite),
            ]);
          }
        },
      ),
    );
  }
}
