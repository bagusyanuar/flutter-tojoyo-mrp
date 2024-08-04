class ProductModel {
  int id;
  String name;
  int qty;

  ProductModel({
    required this.id,
    required this.name,
    required this.qty,
  });

  factory ProductModel.fromJson(dynamic e) {
    return ProductModel(
      id: e['id'] as int,
      name: e['name'] as String,
      qty: e['qty'] as int,
    );
  }
}
