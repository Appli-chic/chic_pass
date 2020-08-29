import 'package:intl/intl.dart';

class Vault {
  static const tableName = "vaults";

  String uid;
  String name;
  String signature;
  String userUid;
  DateTime createdAt;
  DateTime updatedAt;

  Vault({
    this.uid,
    this.name,
    this.userUid,
    this.signature,
    this.createdAt,
    this.updatedAt,
  });

  factory Vault.fromJson(Map<String, dynamic> json) {
    var createdAtString = DateTime.parse(json['CreatedAt']);
    var updatedAtString = DateTime.parse(json['UpdatedAt']);

    return Vault(
      uid: json['ID'],
      name: json['Name'],
      signature: json['Signature'],
      userUid: json['UserID'],
      createdAt: createdAtString,
      updatedAt: updatedAtString,
    );
  }

  Map<String, dynamic> toJson() {
    var dateFormatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
    String createdAtString = dateFormatter.format(this.createdAt);
    String updatedAtString = dateFormatter.format(this.updatedAt);

    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.uid;
    data['Name'] = this.name;
    data['Signature'] = this.signature;
    data['UserID'] = this.userUid;
    data['CreatedAt'] = createdAtString;
    data['UpdatedAt'] = updatedAtString;
    return data;
  }

  factory Vault.fromMap(Map<String, dynamic> data) {
    var createdAtString = DateTime.parse(data['created_at']);
    var updatedAtString = DateTime.parse(data['updated_at']);

    return Vault(
      uid: data['uid'],
      name: data['name'],
      signature: data['signature'],
      userUid: data['user_uid'],
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
      'name': this.name,
      'signature': this.signature,
      'user_uid': this.userUid,
      'created_at': createdAtString,
      'updated_at': updatedAtString,
    };
  }
}
