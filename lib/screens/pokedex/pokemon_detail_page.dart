import 'package:flutter/material.dart';
import 'package:poke_project/models/pokemon.dart';
import 'package:poke_project/widgets/pokemon_card.dart';

class PokemonDetailPage extends StatefulWidget {
  final Pokemon pokemon;
  const PokemonDetailPage({super.key, required this.pokemon});

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  late final Pokemon pokemon;

  @override
  void initState() {
    super.initState();
    pokemon = widget.pokemon;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Center(
        child: PokemonCard(pokemon: pokemon),
      ), // _buildPokemonDetails()
    );
  }

  // --- Widget Building Methods ---

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        pokemon.name,
        style: const TextStyle(fontSize: 40, color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
  }
}
