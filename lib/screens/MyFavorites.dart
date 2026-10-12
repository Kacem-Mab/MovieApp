import 'package:flutter/material.dart';
import '../models/Film.dart';
import '../services/FavoritesHelper.dart';
import 'Details.dart';

class MyFavorites extends StatefulWidget {
  const MyFavorites({super.key});

  @override
  State<MyFavorites> createState() => _MyFavoritesState();
}

class _MyFavoritesState extends State<MyFavorites> {
  final FavoritesHelper _favHelper = FavoritesHelper();
  Key _futureKey = UniqueKey();

  Future<List<Film>> _loadFavorites() => _favHelper.getFavorites();

  void _refresh() => setState(() => _futureKey = UniqueKey());

  Future<void> _removeFromFavorites(String title) async {
    await _favHelper.removeFavorite(title);
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Favoris'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Film>>(
        key: _futureKey,
        future: _loadFavorites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }

          final films = snapshot.data ?? [];

          if (films.isEmpty) {
            return const Center(
              child: Text(
                'Aucun favori pour le moment.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: films.length,
            itemBuilder: (context, index) {
              final film = films[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/${film.image}',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => Details(film: film)),
                            );
                            _refresh();
                          },
                          child: Text(
                            film.title,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.star,
                            color: Colors.amber, size: 27),
                        onPressed: () => _removeFromFavorites(film.title),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
