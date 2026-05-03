class Patient {
  final int id;
  final String name;
  final String childName;
  final int childAge;
  final String? profileImage;

  Patient({
    required this.id,
    required this.name,
    required this.childName,
    required this.childAge,
    this.profileImage,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown Patient',
      childName: json['child_name'] ?? 'Unknown Child',
      childAge: json['child_age'] ?? 0,
      profileImage: json['profile_image'],
    );
  }
}
