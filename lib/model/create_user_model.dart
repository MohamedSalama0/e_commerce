
//
// FireStore
//

class CreateUserModel {
  late String email;
  late String password;
  late String uId;

  CreateUserModel({
    required this.email,
    required this.password,
    required this.uId,
  });

  CreateUserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    uId = json['uId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'uId': uId,
    };
  }
}
