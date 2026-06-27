class CategoryModel {
  final int id;
  final String name;
  final String description;

  final int serviceId;
  final String serviceName;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.serviceId,
    required this.serviceName,
  });

  factory CategoryModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      serviceId: json['serviceId'],
      serviceName: json['serviceName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'serviceId': serviceId,
      'serviceName': serviceName,
    };
  }

  @override
  String toString() {
    return 'CategoryModel('
        'id: $id, '
        'name: $name, '
        'serviceName: $serviceName'
        ')';
  }
}