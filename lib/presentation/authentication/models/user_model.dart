class UserModel {
  final String? uid;
  final String name;
  final String email;

  final String? phone;
  final double? latitude;
  final double? longitude;
  final String? houseName;
  final String? street;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? country;

  const UserModel({
    this.uid,
    required this.email,
    required this.name,
    this.phone,
    this.latitude,
    this.longitude,
    this.houseName,
    this.street,
    this.city,
    this.state,
    this.postalCode,
    this.country,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      if (phone != null) 'phone': phone,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (houseName != null) 'houseName': houseName,
      if (street != null) 'street': street,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (postalCode != null) 'postalCode': postalCode,
      if (country != null) 'country': country,
    };
  }
}
