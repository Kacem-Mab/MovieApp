import 'package:flutter/material.dart';

import '../models/Film.dart';
import '../services/DatabaseHelper.dart';
import '../widgets/MyCartItem.dart';

class MyCart extends StatefulWidget {
  const MyCart({super.key});

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // Key used to force FutureBuilder to rebuild after a delete.
  Key _futureKey = UniqueKey();

  Future<List<Film>> _loadCart() => _dbHelper.getCartFilms();

  void _refresh() {
    setState(() {
      _futureKey = UniqueKey();
    });
  }

  Future<void> _deleteItem(int id) async {
    await _dbHelper.deleteFilm(id);
    _refresh();
  }

  double _totalPrice(List<Film> films) =>
      films.fold(0.0, (sum, film) => sum + film.price);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: FutureBuilder<List<Film>>(
        key: _futureKey,
        future: _loadCart(),
        builder: (context, snapshot) {
          // Still waiting
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error from DB
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Erreur : ${snapshot.error}',
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final films = snapshot.data ?? [];

          // Empty cart
          if (films.isEmpty) {
            return const Center(
              child: Text(
                'Votre panier est vide.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          // Cart with items
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: films.length,
                  itemBuilder: (context, index) {
                    final film = films[index];
                    return MyCartItem(
                      image: film.image,
                      title: film.title,
                      onDelete: () => _deleteItem(film.id!),
                    );
                  },
                ),
              ),
              // Total price footer
              Container(
                color: Colors.black87,
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total :',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${_totalPrice(films).toStringAsFixed(0)} DT',
                      style: const TextStyle(
                          color: Colors.deepOrange,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
