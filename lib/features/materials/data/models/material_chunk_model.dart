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
  final int characterCount;
  final bool isGeneratedByAI;

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
    required this.characterCount,
    required this.isGeneratedByAI,
  });

  factory MaterialChunkModel.fromJson(Map<String, dynamic> json) {
    final content = json['content']?.toString() ?? '';

    return MaterialChunkModel(
      id: json['id']?.toString() ?? '',
      learningMaterialId: json['learningMaterialId']?.toString() ?? '',
      orderNo: (json['orderNo'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString(),
      content: content,
      summary: json['summary']?.toString(),
      keywords: json['keywords']?.toString(),
      difficultyLevel: (json['difficultyLevel'] as num?)?.toInt() ?? 1,
      estimatedStudyMinutes:
          (json['estimatedStudyMinutes'] as num?)?.toInt() ?? 0,
      characterCount:
          (json['characterCount'] as num?)?.toInt() ?? content.length,
      isGeneratedByAI: json['isGeneratedByAI'] == true,
    );
  }
}