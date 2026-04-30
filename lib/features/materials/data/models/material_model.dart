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
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Untitled Material',
      materialType: json['materialType']?.toString() ?? 'Text',
      content: json['content']?.toString() ?? '',
      estimatedDurationMinutes:
          (json['estimatedDurationMinutes'] as num?)?.toInt() ?? 0,
      description: json['description']?.toString(),
      tags: json['tags']?.toString(),
      hasActivePlan: json['hasActivePlan'] == true,
      activePlanId: json['activePlanId']?.toString(),
      activePlanTitle: json['activePlanTitle']?.toString(),
    );
  }
}