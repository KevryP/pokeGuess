import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

class AutoName extends StatefulWidget {
  final Function(String)? onSubmit;
  final bool isActive;

  const AutoName({super.key, required this.onSubmit, required this.isActive});

  @override
  AutoNameState createState() => AutoNameState();
}

class AutoNameState extends State<AutoName> {
  Future<Map<String, dynamic>>? _post;
  List<String> pokeList = [];

  @override
  void initState() {
    super.initState();
    if (pokeList.isEmpty) {
      _post = fetchPost();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white,
            ),
            child: pokeList.isEmpty ? inputWithSearch() : nameSearchField()));
  }

  FutureBuilder<Map<String, dynamic>> inputWithSearch() {
    return FutureBuilder(
        future: _post,
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            for (int i = 0; i < 811; i++) {
              pokeList.add(snapshot.data['results'][i]['name']);
            }
            return nameSearchField();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return const CircularProgressIndicator();
        });
  }

  Autocomplete<String> nameSearchField() {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        }
        return pokeList.where((names) {
          return names.contains(textEditingValue.text.toLowerCase());
        });
      },
      fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
        return TextField(
          enabled: widget.isActive ? true : false,
          controller: controller,
          focusNode: focusNode,
          onEditingComplete: onEditingComplete,
          decoration: InputDecoration(
              hintText: "Enter your guess...",
              hintStyle: TextStyle(
                  fontWeight:
                      widget.isActive ? FontWeight.w900 : FontWeight.w100)),
        );
      },
      onSelected: (String item) {
        print('The $item was selected');
        widget.onSubmit?.call(item);
      },
    );
  }
}
