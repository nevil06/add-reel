class SurveyQuestion {
  final String id;
  final String question;
  final SurveyQuestionType type;
  final List<String>? options; // For multiple choice
  final int pointsReward;
  final String? category;

  SurveyQuestion({
    required this.id,
    required this.question,
    required this.type,
    this.options,
    required this.pointsReward,
    this.category,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'question': question,
        'type': type.toString(),
        'options': options,
        'pointsReward': pointsReward,
        'category': category,
      };

  factory SurveyQuestion.fromJson(Map<String, dynamic> json) {
    return SurveyQuestion(
      id: json['id'],
      question: json['question'],
      type: SurveyQuestionType.values.firstWhere(
        (e) => e.toString() == json['type'],
      ),
      options: json['options'] != null
          ? List<String>.from(json['options'])
          : null,
      pointsReward: json['pointsReward'],
      category: json['category'],
    );
  }
}

enum SurveyQuestionType {
  multipleChoice,
  rating,
  yesNo,
}

class SurveyResponse {
  final String questionId;
  final String userId;
  final dynamic answer; // String for choice, int for rating
  final DateTime timestamp;
  final int pointsEarned;

  SurveyResponse({
    required this.questionId,
    required this.userId,
    required this.answer,
    required this.timestamp,
    required this.pointsEarned,
  });

  Map<String, dynamic> toJson() => {
        'questionId': questionId,
        'userId': userId,
        'answer': answer,
        'timestamp': timestamp.toIso8601String(),
        'pointsEarned': pointsEarned,
      };

  factory SurveyResponse.fromJson(Map<String, dynamic> json) {
    return SurveyResponse(
      questionId: json['questionId'],
      userId: json['userId'],
      answer: json['answer'],
      timestamp: DateTime.parse(json['timestamp']),
      pointsEarned: json['pointsEarned'],
    );
  }
}

class Survey {
  final String id;
  final String title;
  final String description;
  final List<SurveyQuestion> questions;
  final int totalPoints;
  final bool isCompleted;

  Survey({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
    required this.totalPoints,
    this.isCompleted = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'questions': questions.map((q) => q.toJson()).toList(),
        'totalPoints': totalPoints,
        'isCompleted': isCompleted,
      };
}
