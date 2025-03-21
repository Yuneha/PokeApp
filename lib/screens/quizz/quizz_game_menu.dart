import 'package:flutter/material.dart';
import 'package:poke_project/models/pokemon.dart';
import 'package:poke_project/screens/quizz/quizz_game_all.dart';
import 'package:poke_project/screens/quizz/quizz_game_page.dart';
import 'package:poke_project/widgets/quizz_menu_button.dart';

class QuizzMenuPage extends StatefulWidget {
  final List<Pokemon> pokemonList;
  const QuizzMenuPage({super.key, required this.pokemonList});

  @override
  State<QuizzMenuPage> createState() => _QuizzMenuPageState();
}

class _QuizzMenuPageState extends State<QuizzMenuPage> {
  late final List<Pokemon> pokemonList;

  @override
  void initState() {
    super.initState();
    pokemonList = widget.pokemonList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Center(child: _buildQuizzMenuContent()),
    );
  }

  // --- Widget Building Methods ---

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Quizz Menu',
        style: const TextStyle(fontSize: 40, color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
  }

  Widget _buildQuizzMenuContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          [
                {
                  'text': 'Simple',
                  'onPressed': () => {_toQuizzPage('Simple')},
                },
                {
                  'text': 'Silhouette',
                  'onPressed': () => {_toQuizzPage('Silouhette')},
                },
                {
                  'text': 'Pokedex Number',
                  'onPressed': () => {_toQuizzPage('Numdex')},
                },
                {
                  'text': 'Name Them All !',
                  'onPressed':
                      () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    QuizzGameAll(pokemonList: pokemonList),
                          ),
                        ),
                      },
                },
              ]
              .map(
                (buttonData) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: QuizzMenuButton(
                    text: buttonData['text'] as String,
                    onPressed: buttonData['onPressed'] as VoidCallback,
                  ),
                ),
              )
              .toList(),
    );
  }

  // --- Nethods ---

  void _toQuizzPage(String type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => QuizzGamePage(pokemonList: pokemonList, type: type),
      ),
    );
  }
}
