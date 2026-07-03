class CommuneModel {

  final int id;

  final String name;

  final int regionId;

  final String regionName;

  CommuneModel({
    required this.id,
    required this.name,
    required this.regionId,
    required this.regionName,
  });

  factory CommuneModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return CommuneModel(
      id: json['id'],
      name: json['name'],
      regionId: json['regionId'],
      regionName: json['regionName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'regionId': regionId,
      'regionName': regionName,
    };
  }
}