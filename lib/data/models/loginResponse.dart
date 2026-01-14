class LoginResponse {
  String? message;
  String? accessToken;
  String? tokenType;
  UserModel? user;

  LoginResponse({this.message, this.accessToken, this.tokenType, this.user});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    user = json['user'] != null ? new UserModel.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['access_token'] = this.accessToken;
    data['token_type'] = this.tokenType;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class UserModel {
  int? id;
  String? name;
  String? email;
  Null? nik;
  Null? foto;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;

  UserModel(
      {this.id,
      this.name,
      this.email,
      this.nik,
      this.foto,
      this.emailVerifiedAt,
      this.createdAt,
      this.updatedAt});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    nik = json['nik'];
    foto = json['foto'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['nik'] = this.nik;
    data['foto'] = this.foto;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
