import 'package:flutter/material.dart';
import 'package:poke_project/models/pokemon.dart';
import 'package:poke_project/screens/quizz/quizz_game_menu.dart';
import 'package:poke_project/screens/quizz/quizz_name_all_game_logic.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class QuizzGameAll extends StatefulWidget {
  final List<Pokemon> pokemonList;
  const QuizzGameAll({super.key, required this.pokemonList});

  @override
  State<QuizzGameAll> createState() => _QuizzGameAllState();
}

class _QuizzGameAllState extends State<QuizzGameAll> {
  late TextEditingController _answerController;
  bool? _isCorrect;
  late Timer _timer;
  int _seconds = 0;
  bool _isRunning = false;

  @override
  void initState() {
    _startTimer();
    _answerController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<QuizzNameAllGameLogic>(
      create: (_) => QuizzNameAllGameLogic(widget.pokemonList),
      child: Scaffold(appBar: _buildAppBar(), body: _buildGameContent()),
    );
  }

  // --- Building Widget Methods ---

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        'Name Them All !',
        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildGameContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('$_seconds s'),
          _buildPokemonGrid(),
          _buildGameMessage(),
          SizedBox(height: 10),
          _buildGameInput(),
        ],
      ),
    );
  }

  Widget _buildPokemonGrid() {
    return Consumer<QuizzNameAllGameLogic>(
      builder: (context, gameLogic, child) {
        return Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 9,
            ),
            itemBuilder: (BuildContext context, int index) {
              var pokemon = gameLogic.pokemonList[index];
              return _buildPokemonGridItem(context, pokemon);
            },
            itemCount: gameLogic.pokemonList.length,
          ),
        );
      },
    );
  }

  Widget _buildPokemonGridItem(BuildContext context, Pokemon pokemon) {
    return Consumer<QuizzNameAllGameLogic>(
      builder: (context, gameLogic, child) {
        final isGuessed = gameLogic.isPokemonGuessed(pokemon);
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          child: SizedBox(
            key: ValueKey<bool>(isGuessed),
            child: Center(
              child:
                  isGuessed ? Image.network(pokemon.img) : Text(pokemon.numDex),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGameMessage() {
    if (_isCorrect == null) {
      return const SizedBox.shrink();
    } else {
      return _isCorrect!
          ? const Text(
            'Correct',
            style: TextStyle(fontSize: 20, color: Colors.green),
          )
          : const Text(
            'Incorrect',
            style: TextStyle(fontSize: 20, color: Colors.red),
          );
    }
  }

  Widget _buildGameInput() {
    return Consumer<QuizzNameAllGameLogic>(
      builder: (context, gameLogic, child) {
        return SizedBox(
          height: 50,
          child: TextField(
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            controller: _answerController,
            decoration: InputDecoration(
              labelText: 'Enter a pokemon Name',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              setState(() {
                _isCorrect = gameLogic.checkGuess(value);
                _answerController.clear();
                if (gameLogic.guessedPokemon.length ==
                    gameLogic.pokemonList.length) {
                  _stopTimer();
                  _showWinDialog();
                }
              });
            },
          ),
        );
      },
    );
  }

  // --- Methods ---

  void _showWinDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Congratulation !'),
          actions: [
            Text('$_seconds s'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            QuizzMenuPage(pokemonList: widget.pokemonList),
                  ),
                );
              },
              child: Text('Back to menu'),
            ),
          ],
        );
      },
    );
  }

  void _startTimer() {
    if (!_isRunning) {
      _isRunning = true;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          _seconds++;
        });
      });
    }
  }

  void _stopTimer() {
    _timer.cancel();
    _isRunning = false;
  }
}
