import 'package:intl/intl.dart';

class Category {
  static const tableName = "categories";

  String uid;
  String title;
  String iconName;
  String vaultUid;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime deletedAt;

  Category({
    this.uid,
    this.title,
    this.iconName,
    this.vaultUid,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    var createdAtString = DateTime.parse(json['CreatedAt']);
    var updatedAtString = DateTime.parse(json['UpdatedAt']);
    var deletedAtString;

    if (json['DeletedAt'] != null) {
      deletedAtString = DateTime.parse(json['DeletedAt']);
    }

    return Category(
      uid: json['ID'],
      title: json['Title'],
      iconName: json['IconName'],
      vaultUid: json['VaultID'],
      createdAt: createdAtString,
      updatedAt: updatedAtString,
      deletedAt: deletedAtString,
    );
  }

  Map<String, dynamic> toJson() {
    var dateFormatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
    String createdAtString = dateFormatter.format(this.createdAt);
    String updatedAtString = dateFormatter.format(this.updatedAt);
    String deletedAtString;

    if (this.deletedAt != null) {
      deletedAtString = dateFormatter.format(this.deletedAt);
    }

    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.uid;
    data['Title'] = this.title;
    data['IconName'] = this.iconName;
    data['VaultID'] = this.vaultUid;
    data['CreatedAt'] = createdAtString;
    data['UpdatedAt'] = updatedAtString;
    data['DeletedAt'] = deletedAtString;
    return data;
  }

  factory Category.fromMap(Map<String, dynamic> data) {
    var createdAtString = DateTime.parse(data['created_at']);
    var updatedAtString = DateTime.parse(data['updated_at']);
    var deletedAtString;

    if (data['deleted_at'] != null) {
      deletedAtString = DateTime.parse(data['deleted_at']);
    }

    return Category(
      uid: data['uid'],
      title: data['title'],
      iconName: data['icon_name'],
      vaultUid: data['vault_uid'],
      createdAt: createdAtString,
      updatedAt: updatedAtString,
      deletedAt: deletedAtString,
    );
  }

  Map<String, dynamic> toMap() {
    var dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    String createdAtString = dateFormatter.format(this.createdAt);
    String updatedAtString = dateFormatter.format(this.updatedAt);
    String deletedAtString;

    if (this.deletedAt != null) {
      deletedAtString = dateFormatter.format(this.deletedAt);
    }

    return {
      'uid': this.uid,
      'title': this.title,
      'icon_name': this.iconName,
      'vault_uid': vaultUid,
      'created_at': createdAtString,
      'updated_at': updatedAtString,
      'deleted_at': deletedAtString,
    };
  }
}
