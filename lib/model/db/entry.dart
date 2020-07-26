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
    return Entry(
      uid: json['uid'],
      title: json['title'],
      login: json['login'],
      hash: json['hash'],
      vaultUid: json['vault_uid'],
      categoryUid: json['category_uid'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['title'] = this.title;
    data['login'] = this.login;
    data['hash'] = this.hash;
    data['vault_uid'] = this.vaultUid;
    data['category_uid'] = this.categoryUid;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
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
    var dateFormatter =  DateFormat('yyyy-MM-dd HH:mm:ss');
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
