import 'dart:math';
import 'package:poke_project/models/pokemon.dart';

class QuizzGameLogic {
  late final List<Pokemon> pokemonList;
  late Pokemon _currentPokemon;
  int score = 0;
  int count = 0;
  late Set<Pokemon> alreadyPickedPokemon = {};

  QuizzGameLogic(this.pokemonList) {
    getRandomPokemon();
  }

  void getRandomPokemon() {
    final random = Random();
    _currentPokemon = pokemonList[random.nextInt(pokemonList.length)];
    if (alreadyPickedPokemon.contains(_currentPokemon)) {
      getRandomPokemon();
    } else {
      alreadyPickedPokemon.add(_currentPokemon);
      count++;
    }
  }

  Pokemon get currentPokemon => _currentPokemon;

  bool checkAnswer(String answer) {
    String currentPName = _currentPokemon.name.toLowerCase();
    String userAnswer = answer.trim().toLowerCase();

    // Special case for Nidoran male
    if (currentPName == 'nidoran ♂ (male)' &&
        (userAnswer == 'nidoran m' || userAnswer == 'nidoran male')) {
      score++;
      return true;
    }

    // Special case for Nidoran female
    if (currentPName == 'nidoran ♀ (female)' &&
        (userAnswer == 'nidoran f' || userAnswer == 'nidoran female')) {
      score++;
      return true;
    }

    bool isCorrect =
        answer.trim().toLowerCase() == _currentPokemon.name.toLowerCase();
    if (isCorrect) {
      score++;
    }
    return isCorrect;
  }
}
