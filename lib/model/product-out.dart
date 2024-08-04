class ProductOutModel {
  int id;
  String date;
  String name;
  int qty;
  String unit;

  ProductOutModel({
    required this.id,
    required this.date,
    required this.name,
    required this.qty,
    required this.unit,
  });

  factory ProductOutModel.fromJson(dynamic e) {
    return ProductOutModel(
      id: e['id'] as int,
      date: e['date'] as String,
      name: e['product']['name'] as String,
      qty: e['qty'] as int,
      unit: e['product']['unit'] as String,
    );
  }
}
