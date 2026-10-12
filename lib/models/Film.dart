class Film {
  final int? id;
  final String title, image, description;
  final double price;

  const Film(this.title, this.image, this.description, this.price, {this.id});

  /// Convert a Film into a Map for storage.
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'image': image,
      'description': description,
      'price': price,
    };
  }

  /// Create a Film from a stored map.
  factory Film.fromMap(Map<String, dynamic> map) {
    return Film(
      map['title'] as String,
      map['image'] as String,
      map['description'] as String,
      (map['price'] as num).toDouble(),
      id: map['id'] as int?,
    );
  }
}
