class MaterialInModel {
  int id;
  String date;
  String name;
  int qty;
  String unit;

  MaterialInModel({
    required this.id,
    required this.date,
    required this.name,
    required this.qty,
    required this.unit,
  });

  factory MaterialInModel.fromJson(dynamic e) {
    return MaterialInModel(
      id: e['id'] as int,
      date: e['date'] as String,
      name: e['material']['name'] as String,
      qty: e['qty'] as int,
      unit: e['material']['unit'] as String,
    );
  }
}
