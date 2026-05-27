class AppUser {
  const AppUser({required this.id, required this.name, required this.email});

final int id;

final String name;

final String email;

factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(

id: int.parse(json['id'].toString()),
      name: json['name'].toString(),
      email: json['email'].toString(),
    );
  }
}
