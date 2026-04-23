class MaterialModel {
  final String id;
  final String userId;
  final String title;
  final String materialType;
  final String content;
  final int estimatedDurationMinutes;
  final String? description;
  final String? tags;
  final bool hasActivePlan;
  final String? activePlanId;
  final String? activePlanTitle;

  MaterialModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.materialType,
    required this.content,
    required this.estimatedDurationMinutes,
    required this.description,
    required this.tags,
    required this.hasActivePlan,
    required this.activePlanId,
    required this.activePlanTitle,
  });

  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    return MaterialModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      materialType: json['materialType'] as String,
      content: json['content'] as String,
      estimatedDurationMinutes: json['estimatedDurationMinutes'] as int,
      description: json['description'] as String?,
      tags: json['tags'] as String?,
      hasActivePlan: json['hasActivePlan'] as bool? ?? false,
      activePlanId: json['activePlanId'] as String?,
      activePlanTitle: json['activePlanTitle'] as String?,
    );
  }
}