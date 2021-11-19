class UserProfile {
  final String email;
  final String phoneNumber;
  final int authenticationLevel;
  final bool confirmMobile;
  final bool confirmEmail;
  final String name;
  final String family;
  final String birthDate;
  final String phone;
  final bool confirmPhone;
  final String nationalCode;
  final String address;
  final String postalCode;
  final String countryName;
  final int gender;
  final int personType;
  final String typeName;
  final String level;

  UserProfile(
      {required this.email,
      this.phoneNumber = '',
      required this.authenticationLevel,
      this.confirmEmail = false,
      this.confirmMobile = false,
      this.confirmPhone = false,
      this.name = '',
      this.address = '',
      this.postalCode = '',
      this.birthDate = '',
      this.countryName = '',
      this.family = '',
      required this.gender,
      required this.personType,
      this.typeName = '',
      this.level = '',
      this.nationalCode = '',
      this.phone = ''});

  factory UserProfile.fromJson(dynamic resposne) {
    final data = resposne as Map<String, dynamic>;
    return UserProfile(
      email: data['email'],
      phoneNumber: data['phoneNumber'],
      authenticationLevel: data['authenticationLevel'],
      gender: data['gender'],
      personType: data['personType'],
      confirmMobile: data['confirmMobile'],
      confirmEmail: data['confirmEmail'],
      name: data['name'],
      family: data['family'],
      birthDate: data['birthDate'],
      phone: data['phone'],
      confirmPhone: data['confirmPhone'],
      nationalCode: data['nationalCode'],
      address: data['address'],
      postalCode: data['postalCode'],
      countryName: data['countryName'],
      typeName: data['typeName'],
      level: data['level'],
    );
  }
}
