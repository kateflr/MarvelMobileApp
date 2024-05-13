import 'package:flutter/material.dart';

import 'package:marvel_comics_app/models/character.dart';
import 'package:marvel_comics_app/models/comic.dart';
import 'package:marvel_comics_app/requests.dart';
import 'package:marvel_comics_app/screens/ComicDetailWebPage.dart';

class DetailScreen extends StatefulWidget {
  final Character character;

  DetailScreen({
    Key? key,
    required this.character,
  }) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<void> futureComics;
  late ScrollController _scrollController;
  List<Comic> comics = [];
  int currentPage = 1;
  int comicsPerPage = 5;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    futureComics = fetchComics();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      fetchComics();
    }
  }

  Future<void> fetchComics() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      try {
        List<dynamic> comicItems = widget.character.comics['items'];

        int startIndex = (currentPage - 1) * comicsPerPage;
        int endIndex = startIndex + comicsPerPage;

        for (int i = startIndex; i < endIndex && i < comicItems.length; i++) {
          String resourceURI = comicItems[i]['resourceURI'];
          int comicId = int.parse(resourceURI.split('/').last);
          Comic comic = await fetchComic(comicId);
          if (!comic.thumbnail['path'].contains('image_not_available')) {
            comics.add(comic);
          }
        }

        currentPage++;
      } catch (error) {
        print('Failed to fetch comics: $error');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<void>(
        future: futureComics,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
              ),
            );
          } else {
            // List<Comic> comics = snapshot.data ?? [];

            return Container(
              height: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    '${widget.character.thumbnail['path']}.${widget.character.thumbnail['extension']}',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50.0,
                    left: 16.0,
                    child: IconButton(
                      iconSize: 25,
                      icon:
                          const Icon(Icons.arrow_back_ios, color: Colors.black),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Positioned(
                    top: 55.0,
                    left: 16.0,
                    right: 16.0,
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            widget.character.name.contains('(')
                                ? widget.character.name
                                    .substring(
                                        0, widget.character.name.indexOf('('))
                                    .trim()
                                : widget.character.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          if (widget.character.name.contains('('))
                            Text(
                              widget.character.name
                                  .substring(widget.character.name.indexOf('('))
                                  .trim(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      const SizedBox(
                        height: 120,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.character.description,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    left: 16.0,
                    right: 16.0,
                    bottom: 16.0,
                    child: SizedBox(
                      height: 200,
                      child: ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: comics.length + 1,
                        itemBuilder: (context, index) {
                          if (index < comics.length) {
                            Comic comic = comics[index];

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ComicDetailWebPage(
                                      comicUrl: comic.urls[0]['url'],
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: comic.thumbnail['path'] != null &&
                                          comic.thumbnail['extension'] != null
                                      ? Image.network(
                                          comic.thumbnail['path'] +
                                              '.' +
                                              comic.thumbnail['extension'],
                                          fit: BoxFit.cover,
                                        )
                                      : const SizedBox(),
                                ),
                              ),
                            );
                          } else {
                            return isLoading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : const SizedBox.shrink();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
