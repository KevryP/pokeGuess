import 'package:flutter/material.dart';
import 'dart:math'; // For randomizing pokemon
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:poke_guess/widgets/image_widget.dart';
import 'package:poke_guess/widgets/game_widget.dart';

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
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            if (snapshot.data?.pokedexNo == null) {
              return const Text("Loading Pokemon Data...");
            } else {
              return Column(children: [
                ImageBox(
                  sprite: snapshot.data!.sprite,
                ),
                Text(snapshot.data?.name ?? "Loading Pokemon Name..."),
              ]);
            }
          }
        },
      ),
    );
  }
}
