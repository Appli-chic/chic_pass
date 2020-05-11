class Vault {
  int id;
  String name;
  String hash;
  DateTime createdAt;
  DateTime updatedAt;

  Vault({
    this.id,
    this.name,
    this.hash,
    this.createdAt,
    this.updatedAt,
  });

  factory Vault.fromJson(Map<String, dynamic> json) {
    return Vault(
      id: json['id'],
      name: json['name'],
      hash: json['hash'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
