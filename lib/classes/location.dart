class Location {
  final double latitude;
  final double longitude;

  Location(this.latitude, this.longitude);

  // Convert Location object to a map
  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  // Create a Location object from a map
  factory Location.fromMap(Map<String, dynamic> map) {
    return Location(map['latitude'], map['longitude']);
  }
}