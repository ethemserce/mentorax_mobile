class CreateMaterialChunkRequest {
  final String? title;
  final String content;
  final String? summary;
  final String? keywords;
  final int difficultyLevel;
  final int estimatedStudyMinutes;

  CreateMaterialChunkRequest({
    required this.title,
    required this.content,
    required this.summary,
    required this.keywords,
    required this.difficultyLevel,
    required this.estimatedStudyMinutes,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'summary': summary,
      'keywords': keywords,
      'difficultyLevel': difficultyLevel,
      'estimatedStudyMinutes': estimatedStudyMinutes,
    };
  }
}