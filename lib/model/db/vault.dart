import 'package:intl/intl.dart';

class Vault {
  static const tableName = "vaults";

  int id;
  String name;
  String signature;
  DateTime createdAt;
  DateTime updatedAt;

  Vault({
    this.id,
    this.name,
    this.signature,
    this.createdAt,
    this.updatedAt,
  });

  factory Vault.fromJson(Map<String, dynamic> json) {
    return Vault(
      id: json['id'],
      name: json['name'],
      signature: json['signature'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['signature'] = this.signature;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }

  factory Vault.fromMap(Map<String, dynamic> data) {
    var createdAtString = DateTime.parse(data['created_at']);
    var updatedAtString = DateTime.parse(data['updated_at']);

    return Vault(
      id: data['id'],
      name: data['name'],
      signature: data['signature'],
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
      'name': this.name,
      'signature': this.signature,
      'created_at': createdAtString,
      'updated_at': updatedAtString,
    };
  }
}
