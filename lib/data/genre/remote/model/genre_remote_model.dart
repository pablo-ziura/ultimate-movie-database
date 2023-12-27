class GenreRemoteModel {
  int id;
  String name;

  GenreRemoteModel({
    required this.id,
    required this.name,
  });

  factory GenreRemoteModel.fromMap(Map<String, dynamic> json) =>
      GenreRemoteModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };
}
