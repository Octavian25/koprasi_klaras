class UserModel {
  String blokRumah;
  String name;
  String id;
  String role;
  String email;
  String token;

  UserModel(
      {required this.blokRumah,
      required this.email,
      required this.id,
      required this.role,
      required this.token,
      required this.name});

  UserModel copyWith({
    String? blokRumah,
    String? name,
    String? id,
    String? role,
    String? email,
    String? token,
  }) =>
      UserModel(
          blokRumah: blokRumah ?? this.blokRumah,
          email: email ?? this.email,
          id: id ?? this.id,
          role: role ?? this.role,
          token: token ?? this.token,
          name: name ?? this.name);

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      blokRumah: json['blok_rumah'],
      email: json['email'],
      id: json['id'],
      role: json['role'],
      token: json['token'],
      name: json['nama']);

  Map<String, dynamic> toJson() => {
        "blok_rumah": blokRumah,
        "email": email,
        "id": id,
        "role": role,
        "token": token,
        "nama": name
      };
}
