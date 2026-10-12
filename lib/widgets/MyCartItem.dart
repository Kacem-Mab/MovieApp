import 'package:flutter/material.dart';

class MyCartItem extends StatelessWidget {
  final String image;
  final String title;
  final VoidCallback onDelete;

  const MyCartItem({
    super.key,
    required this.image,
    required this.title,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/images/$image',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red, size: 27),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
