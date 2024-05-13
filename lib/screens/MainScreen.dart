import 'package:flutter/material.dart';
import 'package:marvel_comics_app/models/character.dart';
import 'package:marvel_comics_app/requests.dart';
import 'package:marvel_comics_app/screens/DetailScreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late ScrollController _scrollController;
  late List<Character> characters;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    characters = [];
    _scrollController = ScrollController()..addListener(_scrollListener);
    fetchCharacters();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      fetchCharacters();
    }
  }

  Future<void> fetchCharacters() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      try {
        List<Character> newCharacters =
            await fetchMarvelCharacters(offset: characters.length);

        setState(() {
          Set<String> existingCharacterIdentifiers = Set<String>.from(characters
              .map((character) => '${character.id}_${character.name}'));

          newCharacters = newCharacters.where((character) {
            String identifier = '${character.id}_${character.name}';
            return !existingCharacterIdentifiers.contains(identifier);
          }).toList();

          characters.addAll(newCharacters);
        });
      } catch (error) {
        print('Failed to fetch characters: $error');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    characters = characters
        .where((character) =>
            !character.thumbnail['path'].contains('image_not_available'))
        .toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Center(child: Text(widget.title)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: characters.isEmpty
              ? const CircularProgressIndicator()
              : GridView.builder(
                  controller: _scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 7,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: characters.length + 1,
                  itemBuilder: (context, index) {
                    if (index < characters.length) {
                      Character character = characters[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                character: character,
                              ),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Card(
                            elevation: 4,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    '${character.thumbnail['path']}.${character.thumbnail['extension']}',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withOpacity(0.8),
                                          ],
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        character.name,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : const SizedBox.shrink();
                    }
                  },
                ),
        ),
      ),
    );
  }
}
