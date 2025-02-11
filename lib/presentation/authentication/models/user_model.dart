class UserModel {
  final String? uid;
  final String name;
  final String email;
  String? imagePath;
  final String? phone;
  final String? houseName;
  final String? street;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? country;
  final bool? isBanned;

  UserModel({
    this.uid,
    required this.email,
    required this.name,
    this.imagePath,
    this.phone,
    this.houseName,
    this.street,
    this.city,
    this.state,
    this.postalCode,
    this.country,
    this.isBanned,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? imagePath,
    String? phone,
    String? houseName,
    String? street,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    bool? isBanned,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      imagePath: imagePath ?? this.imagePath,
      phone: phone ?? this.phone,
      houseName: houseName ?? this.houseName,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      isBanned: isBanned ?? this.isBanned,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      if (imagePath != null) 'imagePath': imagePath,
      if (phone != null) 'phone': phone,
      if (houseName != null) 'houseName': houseName,
      if (street != null) 'street': street,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (postalCode != null) 'postalCode': postalCode,
      if (country != null) 'country': country,
      if (isBanned != null) 'isBanned': isBanned,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String?,
      name: json['name'] as String,
      email: json['email'] as String,
      imagePath: json['imagePath'] as String?,
      phone: json['phone'] as String?,
      houseName: json['houseName'] as String?,
      street: json['street'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      postalCode: json['postalCode'] as String?,
      country: json['country'] as String?,
      isBanned: json['isBanned'] as bool?,
    );
  }
}
