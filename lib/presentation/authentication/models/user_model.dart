class UserModel {
  final String? uid;
  final String name;
  final String email;
  String? imagePath;
  final String? phone;
  final double? latitude;
  final double? longitude;
  final String? houseName;
  final String? street;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? country;

  UserModel({
    this.uid,
    required this.email,
    required this.name,
    this.imagePath,
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
      if (imagePath != null) 'imagePath': imagePath,
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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String?,
      name: json['name'] as String,
      email: json['email'] as String,
      imagePath: json['imagePath'] as String?,
      phone: json['phone'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      houseName: json['houseName'] as String?,
      street: json['street'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      postalCode: json['postalCode'] as String?,
      country: json['country'] as String?,
    );
  }
}