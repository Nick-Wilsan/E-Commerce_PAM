class Login {
  int? code;
  bool? status;
  String? token;
  int? userID;
  String? userEmail;

  Login({this.code, this.status, this.token, this.userID, this.userEmail});

  factory Login.fromJson(Map<String, dynamic> obj) {
    final user = (obj['data']?['user'] as Map<String, dynamic>?);
    final userIdRaw = user?['id'];
    final userId = userIdRaw is int
        ? userIdRaw
        : int.tryParse(userIdRaw?.toString() ?? '');

    return Login(
      code: obj['code'],
      status: obj['status'],
      token: obj['data']['token'],
      userID: userId,
      userEmail: user?['email']?.toString(),
    );
  }
}
