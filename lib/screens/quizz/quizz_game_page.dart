import 'package:flutter/material.dart';
import 'package:poke_project/models/pokemon.dart';
import 'package:poke_project/screens/quizz/quizz_game_logic.dart';

class QuizzGamePage extends StatefulWidget {
  final List<Pokemon> pokemonList;
  final String type;
  const QuizzGamePage({
    super.key,
    required this.pokemonList,
    required this.type,
  });

  @override
  State<QuizzGamePage> createState() => _QuizzGamePageState();
}

class _QuizzGamePageState extends State<QuizzGamePage> {
  late QuizzGameLogic gameLogic;
  late final TextEditingController _answerController;
  late final String type;
  bool? _isCorrect;
  bool _hasPass = false;

  @override
  void initState() {
    super.initState();
    _answerController = TextEditingController();
    gameLogic = QuizzGameLogic(widget.pokemonList);
    type = widget.type;
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).padding.top,
            child: Container(color: Colors.black.withValues(alpha: 0.5)),
          ),
          SafeArea(child: Center(child: _buildGameQuizzContent())),
        ],
      ),
    );
  }

  // --- Widget Building Methods ---

  Widget _buildGameQuizzContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 20,
      children: [
        if (gameLogic.count == 11) ...[
          Text(
            'score: ${gameLogic.score} / 10',
            style: const TextStyle(fontSize: 40),
          ),
          ElevatedButton(
            onPressed: () => {Navigator.pop(context)},
            child: Text('Return to menu'),
          ),
        ] else ...[
          Text('${gameLogic.count} / 10', style: const TextStyle(fontSize: 28)),
          if (type == 'Simple')
            _buildGameQuizzImage()
          else if (type == 'Silouhette')
            _buildGameSilouhetteImage()
          else if (type == 'Numdex')
            _buildGameNumdex(),
          _buildGameMessage(),
          _buildGameQuizzInput(),
          _buildGameQuizzButtons(),
        ],
      ],
    );
  }

  Widget _buildGameQuizzImage() {
    return SizedBox(
      height: 150,
      child: Image.network(
        gameLogic.currentPokemon.img,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error);
        },
      ),
    );
  }

  Widget _buildGameSilouhetteImage() {
    return SizedBox(
      height: 150,
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
        child: Image.network(
          gameLogic.currentPokemon.img,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.error);
          },
        ),
      ),
    );
  }

  Widget _buildGameNumdex() {
    return SizedBox(
      height: 80,
      child: Column(
        children: [
          Text('Pokedex Number'),
          Text(
            gameLogic.currentPokemon.numDex,
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildGameQuizzInput() {
    return SizedBox(
      width: 300,
      child: TextField(
        enabled: _hasPass ? false : true,
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        controller: _answerController,
        decoration: InputDecoration(
          labelText: 'Guess the pokemon',
          border: OutlineInputBorder(),
        ),
        onSubmitted:
            (value) => {
              setState(() {
                _isCorrect = gameLogic.checkAnswer(value);
                _answerController.clear();
                if (_isCorrect!) {
                  _nextPokemon();
                }
              }),
            },
      ),
    );
  }

  Widget _buildGameQuizzButtons() {
    return Column(
      children: [
        ElevatedButton(
          onPressed:
              _hasPass
                  ? () => {
                    _nextPokemon(),
                    setState(() {
                      _hasPass = false;
                    }),
                  }
                  : () => {
                    setState(() {
                      _hasPass = true;
                    }),
                  },
          child: _hasPass ? Text('Next') : Text('Pass'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => {Navigator.pop(context)},
          child: Text('QUIT'),
        ),
      ],
    );
  }

  Widget _buildGameMessage() {
    if (_hasPass) {
      return Text(
        'Correct answer: ${gameLogic.currentPokemon.name}',
        style: TextStyle(fontSize: 20, color: Colors.red),
      );
    } else {
      return (_isCorrect == null || _isCorrect!)
          ? const SizedBox.shrink()
          : const Text(
            'Incorrect',
            style: TextStyle(fontSize: 20, color: Colors.red),
          );
    }
  }

  // --- Methods ---

  void _nextPokemon() {
    if (gameLogic.count <= 10) {
      setState(() {
        gameLogic.getRandomPokemon();
        _answerController.clear();
        _isCorrect = null;
      });
    }
  }
}
