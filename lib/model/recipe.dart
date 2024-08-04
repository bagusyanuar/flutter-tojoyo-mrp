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
