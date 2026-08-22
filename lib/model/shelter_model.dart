class Shelter {
  final String address;
  final String descriptions;
  final String name;
  final int id;
  final double lat;
  final double lng;

  Shelter({
    required this.address,
    required this.descriptions,
    required this.name,
    required this.id,
    required this.lat,
    required this.lng,
  });

  factory Shelter.fromMap(Map<String, dynamic> data) {
    return Shelter(
      address: data['address'] ?? '',
      descriptions: data['descriptions'] ?? '',
      name: data['name'] ?? '',
      id: data['id'] ?? 0,
      lat: data['lat'] ?? 0.0,
      lng: data['lng'] ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'descriptions': descriptions,
      'name': name,
      'id': id,
      'lat': lat,
      'lng': lng,
    };
  }
}
