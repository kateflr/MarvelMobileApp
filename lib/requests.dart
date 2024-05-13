import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:marvel_comics_app/models/comic.dart';
import './models/character.dart';

String generateMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}

const publicKey = '771e4473f65a86c90030c065b47cf6fc';
const privateKey = '9ec6789be82c8b2650af09855f88c8f9123e3208';
final timestamp = DateTime.now().millisecondsSinceEpoch;
final hash = generateMd5('$timestamp$privateKey$publicKey');

Future<List<Character>> fetchMarvelCharacters() async {
  String url =
      "https://gateway.marvel.com/v1/public/characters?apikey=$publicKey&ts=$timestamp&hash=$hash";
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = json.decode(response.body);
    final List<dynamic> charactersData = responseData['data']['results'];

    List<Character> characters = [];
    for (var characterData in charactersData) {
      Character character = Character(
        id: characterData['id'],
        name: characterData['name'],
        description: characterData['description'],
        thumbnail: characterData['thumbnail'],
        comics: characterData['comics'],
      );
      characters.add(character);
    }
    return characters;
  } else {
    throw Exception('Failed to fetch characters: ${response.statusCode}');
  }
}

Future<Comic> fetchComic(int comicId) async {
  final url =
      'http://gateway.marvel.com/v1/public/comics/$comicId?apikey=$publicKey&ts=$timestamp&hash=$hash';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData =
        json.decode(response.body)['data']['results'][0];
    Comic comic = Comic(
      title: responseData['title'],
      id: responseData['id'],
      thumbnail: responseData['thumbnail'],
      urls: responseData['urls'],
    );
    return comic;
  } else {
    throw Exception('Failed to fetch comic details: ${response.statusCode}');
  }
}
