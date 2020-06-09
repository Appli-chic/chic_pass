import 'package:intl/intl.dart';

import 'category.dart';

class Entry {
  static const tableName = "entries";

  int id;
  String title;
  String login;
  String hash;
  int vaultId;
  int categoryId;
  DateTime createdAt;
  DateTime updatedAt;
  Category category;

  Entry({
    this.id,
    this.title,
    this.login,
    this.hash,
    this.vaultId,
    this.categoryId,
    this.createdAt,
    this.updatedAt,
    this.category,
  });

  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(
      id: json['id'],
      title: json['title'],
      login: json['login'],
      hash: json['hash'],
      vaultId: json['vault_id'],
      categoryId: json['category_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['login'] = this.login;
    data['hash'] = this.hash;
    data['vault_id'] = this.vaultId;
    data['category_id'] = this.categoryId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }

  factory Entry.fromMap(Map<String, dynamic> data) {
    var createdAtString = DateTime.parse(data['created_at']);
    var updatedAtString = DateTime.parse(data['updated_at']);

    return Entry(
      id: data['id'],
      title: data['title'],
      login: data['login'],
      hash: data['hash'],
      vaultId: data['vault_id'],
      categoryId: data['category_id'],
      createdAt: createdAtString,
      updatedAt: updatedAtString,
    );
  }

  Map<String, dynamic> toMap() {
    var dateFormatter =  DateFormat('yyyy-MM-dd HH:mm:ss');
    String createdAtString = dateFormatter.format(this.createdAt);
    String updatedAtString = dateFormatter.format(this.updatedAt);

    return {
      'id': this.id,
      'title': this.title,
      'login': this.login,
      'hash': this.hash,
      'vault_id': this.vaultId,
      'category_id': this.categoryId,
      'created_at': createdAtString,
      'updated_at': updatedAtString,
    };
  }
}
