import 'package:flutter/material.dart';
import 'package:poke_project/models/pokemon.dart';
import 'package:poke_project/utils/constants.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  const PokemonCard({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      height: MediaQuery.of(context).size.height - 100,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(color: Colors.black, width: 4),
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              pokemon.type.length == 2
                  ? [
                    typeColors[pokemon.type[0]]!,
                    Colors.white,
                    typeColors[pokemon.type[1]]!,
                  ]
                  : [
                    typeColors[pokemon.type[0]]!,
                    Colors.white,
                    typeColors[pokemon.type[0]]!,
                  ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          _buildPokemonBasicInfo(),
          _buildPokemonImage(),
          _buildPokemonStats(),
          _buildPokemonEvolutions(),
        ],
      ),
    );
  }

  Widget _buildPokemonBasicInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            pokemon.numDex,
            style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
          Text(formatPokemonName(pokemon.name), style: TextStyle(fontSize: 36)),
        ],
      ),
    );
  }

  Widget _buildPokemonImage() {
    return SizedBox(
      height: 200,
      child: Image.network(
        pokemon.img,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
      ),
    );
  }

  Widget _buildPokemonStats() {
    return Column(
      spacing: 16,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'Height: ${pokemon.height}',
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              'Weight: ${pokemon.weight}',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
        Text('Type', style: TextStyle(fontSize: 28)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 80,
          children: [
            for (int i = 0; i < pokemon.type.length; i++)
              _buildTypeIcon(pokemon.type[i]),
          ],
        ),
        Text('Weaknesses', style: TextStyle(fontSize: 28)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (int i = 0; i < pokemon.weaknesses!.length; i++)
              _buildTypeIcon(pokemon.weaknesses![i]),
          ],
        ),
      ],
    );
  }

  Widget _buildPokemonEvolutions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (pokemon.prevEvolution != null) ...[
          Text('Previous Evolutions', style: TextStyle(fontSize: 20)),
          ...(pokemon.prevEvolution as List).map(
            (evolution) => Text('- ${evolution['name']} (${evolution['num']})'),
          ),
        ],
        SizedBox(height: 16),
        if (pokemon.nextEvolution != null) ...[
          Text('nexts Evolutions', style: TextStyle(fontSize: 20)),
          ...(pokemon.nextEvolution as List).map(
            (evolution) => Text('- ${evolution['name']} (${evolution['num']})'),
          ),
        ],
      ],
    );
  }

  Widget _buildTypeIcon(String type) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: typeColors[type] ?? Colors.black,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Text(type, style: TextStyle(fontSize: 16, color: Colors.white)),
    );
  }

  // --- Methods ---

  String formatPokemonName(String name) {
    name = name.replaceAll('♂', '');
    name = name.replaceAll('♀', '');
    name = name.trim();
    return name;
  }
}
