import 'package:intl/intl.dart';

class User {
  static const tableName = "users";

  String uid;
  String email;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    this.uid,
    this.email,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    var createdAtString = DateTime.parse(json['CreatedAt']);
    var updatedAtString = DateTime.parse(json['UpdatedAt']);

    return User(
      uid: json['ID'],
      email: json['Email'],
      createdAt: createdAtString,
      updatedAt: updatedAtString,
    );
  }

  Map<String, dynamic> toJson() {
    var dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    String createdAtString = dateFormatter.format(this.createdAt);
    String updatedAtString = dateFormatter.format(this.updatedAt);

    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.uid;
    data['Email'] = this.email;
    data['CreatedAt'] = createdAtString;
    data['UpdatedAt'] = updatedAtString;
    return data;
  }

  factory User.fromMap(Map<String, dynamic> data) {
    var createdAtString = DateTime.parse(data['created_at']);
    var updatedAtString = DateTime.parse(data['updated_at']);

    return User(
      uid: data['uid'],
      email: data['email'],
      createdAt: createdAtString,
      updatedAt: updatedAtString,
    );
  }

  Map<String, dynamic> toMap() {
    var dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    String createdAtString = dateFormatter.format(this.createdAt);
    String updatedAtString = dateFormatter.format(this.updatedAt);

    return {
      'uid': this.uid,
      'email': this.email,
      'created_at': createdAtString,
      'updated_at': updatedAtString,
    };
  }
}
