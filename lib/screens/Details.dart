import 'package:flutter/material.dart';

import '../models/Film.dart';
import '../services/DatabaseHelper.dart';

class Details extends StatefulWidget {
  final Film film;
  const Details({super.key, required this.film});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  /// Add the current film to the SQLite cart and show a confirmation snackbar.
  Future<void> _addToCart() async {
    await _dbHelper.insertFilm(widget.film);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${widget.film.title}" ajouté au panier !'),
        backgroundColor: Colors.deepOrange,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.film.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Image.asset(
              'assets/images/${widget.film.image}',
              height: 220,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            Text(
              widget.film.description,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 40),
            Text(
              '${widget.film.price.toStringAsFixed(0)} DT',
              style: const TextStyle(
                  fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 12),
              ),
              onPressed: _addToCart,
              label: const Text('Acheter', style: TextStyle(fontSize: 20)),
              icon: const Icon(Icons.shopping_basket, size: 23),
            ),
          ],
        ),
      ),
    );
  }
}
