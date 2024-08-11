class MaterialModel {
  int id;
  String name;
  int qty;
  String unit;

  MaterialModel({
    required this.id,
    required this.name,
    required this.qty,
    required this.unit,
  });

  factory MaterialModel.fromJson(dynamic e) {
    return MaterialModel(
      id: e['id'] as int,
      name: e['name'] as String,
      qty: e['qty'] as int,
      unit: e['unit'] as String,
    );
  }
  factory MaterialModel.fromJsonProductMaterial(dynamic e) {
    return MaterialModel(
      id: e['material']['id'] as int,
      name: e['material']['name'] as String,
      qty: e['qty'] as int,
      unit: e['material']['unit'] as String,
    );
  }
}
