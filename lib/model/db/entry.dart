import 'package:intl/intl.dart';

import 'category.dart';

class Entry {
  static const tableName = "entries";

  String uid;
  String title;
  String login;
  String hash;
  String vaultUid;
  String categoryUid;
  DateTime createdAt;
  DateTime updatedAt;
  Category category;

  Entry({
    this.uid,
    this.title,
    this.login,
    this.hash,
    this.vaultUid,
    this.categoryUid,
    this.createdAt,
    this.updatedAt,
    this.category,
  });

  factory Entry.fromJson(Map<String, dynamic> json) {
    var createdAtString = DateTime.parse(json['CreatedAt']);
    var updatedAtString = DateTime.parse(json['UpdatedAt']);

    return Entry(
      uid: json['ID'],
      title: json['Title'],
      login: json['Login'],
      hash: json['Hash'],
      vaultUid: json['VaultID'],
      categoryUid: json['CategoryID'],
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
    data['Title'] = this.title;
    data['Login'] = this.login;
    data['Hash'] = this.hash;
    data['VaultID'] = this.vaultUid;
    data['CategoryID'] = this.categoryUid;
    data['CreatedAt'] = createdAtString;
    data['UpdatedAt'] = updatedAtString;
    return data;
  }

  factory Entry.fromMap(Map<String, dynamic> data) {
    var createdAtString = DateTime.parse(data['created_at']);
    var updatedAtString = DateTime.parse(data['updated_at']);

    return Entry(
      uid: data['uid'],
      title: data['title'],
      login: data['login'],
      hash: data['hash'],
      vaultUid: data['vault_uid'],
      categoryUid: data['category_uid'],
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
      'title': this.title,
      'login': this.login,
      'hash': this.hash,
      'vault_uid': this.vaultUid,
      'category_uid': this.categoryUid,
      'created_at': createdAtString,
      'updated_at': updatedAtString,
    };
  }
}
