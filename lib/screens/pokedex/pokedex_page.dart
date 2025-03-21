import 'package:flutter/material.dart';
import 'package:poke_project/models/pokemon.dart';
import 'package:poke_project/screens/pokedex/pokemon_detail_page.dart';
import 'package:poke_project/utils/constants.dart';

class PokedexPage extends StatefulWidget {
  final List<Pokemon> pokemonList;
  const PokedexPage({super.key, required this.pokemonList});

  @override
  State<PokedexPage> createState() => _PokedexPageSate();
}

class _PokedexPageSate extends State<PokedexPage> {
  late List<Pokemon> pokemonList;
  late List<Pokemon> filteredPokemonList;
  late TextEditingController _searchController;
  bool isSearching = false;
  String? selectedType;
  List<String> allTypes = [];

  @override
  void initState() {
    super.initState();
    pokemonList = widget.pokemonList;
    filteredPokemonList = List.from(pokemonList);
    _searchController = TextEditingController();
    _searchController.addListener(_filteredPokemon);
    _extractAllTypes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [_buildTypeFilter(), Expanded(child: _buildPokemonList())],
      ),
    );
  }

  // --- Widget Building Methods ---

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title:
          isSearching
              ? TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search ...',
                  hintStyle: TextStyle(color: Colors.white),
                ),
              )
              : const Text(
                'Pokedex',
                style: TextStyle(fontSize: 40, color: Colors.white),
              ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              isSearching = !isSearching;
              if (!isSearching) {
                _searchController.clear();
                _filteredPokemon();
              }
            });
          },
          icon: Icon(isSearching ? Icons.cancel : Icons.search),
        ),
      ],
      backgroundColor: Colors.red,
    );
  }

  Widget _buildTypeFilter() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: allTypes.length,
        itemBuilder: (context, index) {
          final type = allTypes[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              labelStyle: const TextStyle(color: Colors.white),
              backgroundColor: typeColors[type],
              selectedColor: typeColors[type],
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(30),
              ),
              label: Text(type),
              selected: selectedType == type,
              onSelected: (selected) => _selectedType(type),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPokemonList() {
    return filteredPokemonList.isEmpty
        ? const Center(
          child: Text('No Pokemon Found', style: TextStyle(fontSize: 32)),
        )
        : ListView.builder(
          itemCount: filteredPokemonList.length,
          itemBuilder: (context, index) {
            var pokemon = filteredPokemonList[index];
            return _buildPokemonListItem(pokemon);
          },
        );
  }

  Widget _buildPokemonListItem(Pokemon pokemon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(3, 3),
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PokemonDetailPage(pokemon: pokemon),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(pokemon.numDex, style: const TextStyle(fontSize: 24)),
                SizedBox(width: 30),
                Image.network(
                  width: 56,
                  height: 56,
                  pokemon.img,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error);
                  },
                ),
                SizedBox(width: 50),
                Text(pokemon.name, style: const TextStyle(fontSize: 24)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Methods ---

  void _filteredPokemon() {
    String searchName = _searchController.text.toLowerCase().trim();
    setState(() {
      if (searchName.isEmpty) {
        filteredPokemonList = List.from(pokemonList);
      } else {
        filteredPokemonList =
            pokemonList.where((pokemon) {
              return (pokemon.name).toLowerCase().contains(searchName);
            }).toList();
      }
    });
  }

  void _filteredPokemonByType() {
    if (selectedType == null) {
      filteredPokemonList = List.from(pokemonList);
    } else {
      filteredPokemonList =
          pokemonList.where((pokemon) {
            List<String> types = List<String>.from(pokemon.type);
            return types.contains(selectedType);
          }).toList();
    }
  }

  void _selectedType(String type) {
    setState(() {
      selectedType = (type == selectedType) ? null : type;
      _filteredPokemonByType();
    });
  }

  void _extractAllTypes() {
    Set<String> types = {};
    for (var pokemon in pokemonList) {
      types.addAll(List<String>.from(pokemon.type));
    }
    allTypes = [...types.toList()..sort()];
  }
}
