class MaterialChunkModel {
  final String id;
  final String learningMaterialId;
  final int orderNo;
  final String? title;
  final String content;
  final String? summary;
  final String? keywords;
  final int difficultyLevel;
  final int estimatedStudyMinutes;

  MaterialChunkModel({
    required this.id,
    required this.learningMaterialId,
    required this.orderNo,
    required this.title,
    required this.content,
    required this.summary,
    required this.keywords,
    required this.difficultyLevel,
    required this.estimatedStudyMinutes,
  });

  factory MaterialChunkModel.fromJson(Map<String, dynamic> json) {
    return MaterialChunkModel(
      id: json['id'] as String,
      learningMaterialId: json['learningMaterialId'] as String,
      orderNo: json['orderNo'] as int,
      title: json['title'] as String?,
      content: json['content'] as String,
      summary: json['summary'] as String?,
      keywords: json['keywords'] as String?,
      difficultyLevel: json['difficultyLevel'] as int,
      estimatedStudyMinutes: json['estimatedStudyMinutes'] as int,
    );
  }

  get characterCount => null;

  get isGeneratedByAI => null;
}