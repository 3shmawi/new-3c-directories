class ZkrModel {
  final int id;
  final String zkr;
  final String? description;
  final int count;

  ZkrModel({
    required this.id,
    required this.zkr,
    this.description,
    required this.count,
  });
}
