class Vault {
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
}
