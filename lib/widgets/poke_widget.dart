import 'package:flutter/material.dart';
import 'dart:math'; // For randomizing pokemon
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:poke_guess/widgets/image_widget.dart';
import 'package:poke_guess/widgets/game_widget.dart';
import 'package:poke_guess/widgets/name_assist.dart';

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
  final PokeState pokeState;

  const PokeWidget({super.key, required this.pokeState});

  @override
  PokeState createState() => pokeState;

  ImageBoxState? getImageBox() {
    return pokeState.getImageBox();
  }

  String? getPokeName() {
    return pokeState.getPokeName();
  }
}

class PokeState extends State<PokeWidget> {
  Future<Pokemon>? futurePokemon;
  String? pokeName;

  ImageBoxState pokeImgState = ImageBoxState();
  ImageBox? pokeImg;

  ImageBoxState? getImageBox() {
    return pokeImgState;
  }

  String? getPokeName() {
    return pokeName;
  }

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
      print("ok");
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
              pokeName = snapshot.data?.name;
              return Column(children: [
                pokeImg = ImageBox(
                  sprite: snapshot.data!.sprite,
                  box: pokeImgState,
                ),
                //Text(snapshot.data?.name ?? "Loading Pokemon Name..."),
              ]);
            }
          }
        },
      ),
    );
  }
}
