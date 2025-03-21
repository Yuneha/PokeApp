import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:poke_project/models/pokemon.dart';
import 'package:poke_project/utils/constants.dart';

class ApiService {
  Future<List<Pokemon>> getApiDatas() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = jsonDecode(response.body);
        final List<dynamic> pokemonListJson = decodedData['pokemon'];
        return pokemonListJson.map((json) => Pokemon.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch api data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
