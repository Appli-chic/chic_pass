import 'package:intl/intl.dart';

class Category {
  static const tableName = "categories";

  String uid;
  String title;
  String iconName;
  DateTime createdAt;
  DateTime updatedAt;
  String vaultUid;

  Category({
    this.uid,
    this.title,
    this.iconName,
    this.createdAt,
    this.updatedAt,
    this.vaultUid,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      uid: json['uid'],
      title: json['title'],
      iconName: json['icon_name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      vaultUid: json['vault_uid'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['title'] = this.title;
    data['icon_name'] = this.iconName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['vault_uid'] = this.vaultUid;
    return data;
  }

  factory Category.fromMap(Map<String, dynamic> data) {
    var createdAtString = DateTime.parse(data['created_at']);
    var updatedAtString = DateTime.parse(data['updated_at']);

    return Category(
      uid: data['uid'],
      title: data['title'],
      iconName: data['icon_name'],
      createdAt: createdAtString,
      updatedAt: updatedAtString,
      vaultUid: data['vault_uid'],
    );
  }

  Map<String, dynamic> toMap() {
    var dateFormatter =  DateFormat('yyyy-MM-dd HH:mm:ss');
    String createdAtString = dateFormatter.format(this.createdAt);
    String updatedAtString = dateFormatter.format(this.updatedAt);

    return {
      'uid': this.uid,
      'title': this.title,
      'icon_name': this.iconName,
      'created_at': createdAtString,
      'updated_at': updatedAtString,
      'vault_uid': vaultUid,
    };
  }
}
