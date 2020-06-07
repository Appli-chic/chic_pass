import 'package:intl/intl.dart';

class Category {
  static const tableName = "categories";

  int id;
  String title;
  String iconName;
  DateTime createdAt;
  DateTime updatedAt;

  Category({
    this.id,
    this.title,
    this.iconName,
    this.createdAt,
    this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      title: json['title'],
      iconName: json['icon_name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['icon_name'] = this.iconName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }

  factory Category.fromMap(Map<String, dynamic> data) {
    var createdAtString = DateTime.parse(data['created_at']);
    var updatedAtString = DateTime.parse(data['updated_at']);

    return Category(
      id: data['id'],
      title: data['title'],
      iconName: data['icon_name'],
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
      'icon_name': this.iconName,
      'created_at': createdAtString,
      'updated_at': updatedAtString,
    };
  }
}