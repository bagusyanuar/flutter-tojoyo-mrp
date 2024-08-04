class RecipeModel {
  int id;
  String name;
  int count;

  RecipeModel({
    required this.id,
    required this.name,
    required this.count,
  });

  factory RecipeModel.fromJson(dynamic e) {
    return RecipeModel(
      id: e['id'] as int,
      name: e['name'] as String,
      count: e['count'] as int,
    );
  }
}

class RecipeDetailModel {
  int id;
  String name;
  int qty;
  String unit;

  RecipeDetailModel(
      {required this.id,
      required this.name,
      required this.qty,
      required this.unit});

  factory RecipeDetailModel.fromJson(dynamic e) {
    return RecipeDetailModel(
      id: e['id'] as int,
      name: e['material']['name'] as String,
      qty: e['qty'] as int,
      unit: e['material']['unit'] as String,
    );
  }
}
