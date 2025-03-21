import 'package:flutter/material.dart';
import 'dart:collection';
import '../../models/pokemon.dart';

class QuizzNameAllGameLogic with ChangeNotifier {
  final List<Pokemon> pokemonList;
  final Set<Pokemon> _guessedPokemon = {};

  QuizzNameAllGameLogic(this.pokemonList);

  bool checkGuess(String answer) {
    final pokemon = pokemonList.firstWhere(
      (p) {
        String pName = p.name.toLowerCase();
        String userAnswer = answer.trim().toLowerCase();

        // Special case for Nidoran male
        if (pName == 'nidoran ♂ (male)' &&
            (userAnswer == 'nidoran m' || userAnswer == 'nidoran male')) {
          return true;
        }

        // Special case for Nidoran female
        if (pName == 'nidoran ♀ (female)' &&
            (userAnswer == 'nidoran f' || userAnswer == 'nidoran female')) {
          return true;
        }

        // Default case
        return pName == userAnswer;
      },
      orElse:
          () => Pokemon(
            numDex: '000',
            name: '0',
            img: '',
            type: [],
            height: '0',
            weight: '0',
          ),
    );

    if (pokemon.numDex != '000' && !_guessedPokemon.contains(pokemon)) {
      _guessedPokemon.add(pokemon);
      notifyListeners();
      return true;
    }
    return false;
  }

  bool isPokemonGuessed(Pokemon pokemon) {
    return _guessedPokemon.contains(pokemon);
  }

  UnmodifiableSetView<Pokemon> get guessedPokemon =>
      UnmodifiableSetView(_guessedPokemon);
}
