class PlaceCategory {
  PlaceCategory({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlaceCategory && other.id == id && other.name == name;
  }

  @override  
  int get hashCode => Object.hash(id, name);
}
