import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poke_project/services/api_services.dart';
import 'package:poke_project/screens/pokedex/pokedex_page.dart';
import 'package:poke_project/screens/quizz/quizz_game_menu.dart';
import 'package:poke_project/models/pokemon.dart';
import 'package:poke_project/widgets/home_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final apiServices = ApiService();
  late List<Pokemon> pokemonList = [];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    _fetchPokemonData();
  }

  Future<void> _preloadImages() async {
    for (var pokemon in pokemonList) {
      await precacheImage(NetworkImage(pokemon.img), context);
    }
  }

  Future<void> _fetchPokemonData() async {
    try {
      final pokemonDatas = await apiServices.getApiDatas();
      setState(() {
        pokemonList = pokemonDatas;
      });
      await _preloadImages();
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          // Positioned.fill(
          //   child: Image.asset("assets/images/test.jpg", fit: BoxFit.fill),
          // ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).padding.top,
            child: Container(color: Colors.black.withValues(alpha: 0.5)),
          ),
          SafeArea(child: Center(child: _buildHomePageContent())),
        ],
      ),
    );
  }

  // --- Widget BUilding Methods ---

  Widget _buildHomePageContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Poke App',
          style: TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 100),
        _buildHomePageButtons(),
      ],
    );
  }

  Widget _buildHomePageButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        HomeButton(
          text: 'Pokedex',
          onPressed:
              () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PokedexPage(pokemonList: pokemonList),
                  ),
                ),
              },
        ),
        SizedBox(width: 20),
        HomeButton(
          text: 'Quizz',
          onPressed:
              () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => QuizzMenuPage(pokemonList: pokemonList),
                  ),
                ),
              },
        ),
      ],
    );
  }
}
