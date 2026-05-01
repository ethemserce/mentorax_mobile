class WeakMaterialModel {
  final String materialId;
  final String title;
  final String performanceLevel;
  final DateTime nextReviewAtUtc;

  WeakMaterialModel({
    required this.materialId,
    required this.title,
    required this.performanceLevel,
    required this.nextReviewAtUtc,
  });

  factory WeakMaterialModel.fromJson(Map<String, dynamic> json) {
    return WeakMaterialModel(
      materialId: json['materialId'] as String,
      title: json['title'] as String,
      performanceLevel: json['performanceLevel'] as String,
      nextReviewAtUtc: DateTime.parse(json['nextReviewAtUtc'] as String),
    );
  }
}
