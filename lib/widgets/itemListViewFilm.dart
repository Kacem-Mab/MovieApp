import 'package:flutter/material.dart';
import '../models/Film.dart';
import '../services/FavoritesHelper.dart';

class itemListViewFilm extends StatefulWidget {
  final Film film;
  const itemListViewFilm({super.key, required this.film});

  @override
  State<itemListViewFilm> createState() => _itemListViewFilmState();
}

class _itemListViewFilmState extends State<itemListViewFilm> {
  final FavoritesHelper _favHelper = FavoritesHelper();
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavorite();
  }

  Future<void> _checkFavorite() async {
    final result = await _favHelper.isFavorite(widget.film.title);
    if (mounted) setState(() => _isFavorite = result);
  }

  Future<void> _toggleFavorite() async {
    if (_isFavorite) {
      await _favHelper.removeFavorite(widget.film.title);
    } else {
      await _favHelper.addFavorite(widget.film);
    }
    if (mounted) setState(() => _isFavorite = !_isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Image.asset('assets/images/${widget.film.image}'),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.film.title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: _toggleFavorite,
                    child: Icon(
                      _isFavorite ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 27,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
