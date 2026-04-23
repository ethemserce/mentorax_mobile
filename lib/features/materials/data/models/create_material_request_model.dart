class CreateMaterialRequestModel {
  final String title;
  final String materialType;
  final String content;
  final int estimatedDurationMinutes;
  final String? description;
  final String? tags;

  CreateMaterialRequestModel({
    required this.title,
    required this.materialType,
    required this.content,
    required this.estimatedDurationMinutes,
    this.description,
    this.tags,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'materialType': materialType,
      'content': content,
      'estimatedDurationMinutes': estimatedDurationMinutes,
      'description': description,
      'tags': tags,
    };
  }
}