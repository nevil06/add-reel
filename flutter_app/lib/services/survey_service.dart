import 'package:flutter/foundation.dart';
import '../models/survey_model.dart';

class SurveyService extends ChangeNotifier {
  final List<Survey> _availableSurveys = [];
  final Map<String, List<SurveyResponse>> _responses = {};
  
  List<Survey> get availableSurveys => _availableSurveys;
  
  SurveyService() {
    _loadSampleSurveys();
  }

  void _loadSampleSurveys() {
    _availableSurveys.addAll([
      // Quick Survey - Ad Feedback
      Survey(
        id: 'survey_1',
        title: 'Quick Ad Feedback',
        description: 'Help us improve your ad experience',
        totalPoints: 5,
        questions: [
          SurveyQuestion(
            id: 'q1',
            question: 'How relevant was the ad you just watched?',
            type: SurveyQuestionType.rating,
            pointsReward: 5,
            category: 'ad_feedback',
          ),
        ],
      ),

      // Standard Survey - User Preferences
      Survey(
        id: 'survey_2',
        title: 'Your Preferences',
        description: 'Tell us what you like',
        totalPoints: 10,
        questions: [
          SurveyQuestion(
            id: 'q2',
            question: 'What type of ads do you prefer?',
            type: SurveyQuestionType.multipleChoice,
            options: [
              'Product Ads',
              'Service Ads',
              'Entertainment',
              'Technology',
            ],
            pointsReward: 5,
            category: 'preferences',
          ),
          SurveyQuestion(
            id: 'q3',
            question: 'Would you recommend AdReel to friends?',
            type: SurveyQuestionType.yesNo,
            options: ['Yes', 'No'],
            pointsReward: 5,
            category: 'feedback',
          ),
        ],
      ),

      // Detailed Survey - Experience
      Survey(
        id: 'survey_3',
        title: 'App Experience Survey',
        description: 'Share your thoughts on AdReel',
        totalPoints: 20,
        questions: [
          SurveyQuestion(
            id: 'q4',
            question: 'How would you rate your overall experience?',
            type: SurveyQuestionType.rating,
            pointsReward: 5,
            category: 'experience',
          ),
          SurveyQuestion(
            id: 'q5',
            question: 'How easy is it to navigate the app?',
            type: SurveyQuestionType.rating,
            pointsReward: 5,
            category: 'usability',
          ),
          SurveyQuestion(
            id: 'q6',
            question: 'What feature do you use most?',
            type: SurveyQuestionType.multipleChoice,
            options: [
              'Watch Ads',
              'Wallet',
              'Surveys',
              'Settings',
            ],
            pointsReward: 5,
            category: 'usage',
          ),
          SurveyQuestion(
            id: 'q7',
            question: 'Would you like more survey opportunities?',
            type: SurveyQuestionType.yesNo,
            options: ['Yes', 'No'],
            pointsReward: 5,
            category: 'feedback',
          ),
        ],
      ),
    ]);
    notifyListeners();
  }

  void submitResponse(String surveyId, String questionId, dynamic answer, String userId, int points) {
    final response = SurveyResponse(
      questionId: questionId,
      userId: userId,
      answer: answer,
      timestamp: DateTime.now(),
      pointsEarned: points,
    );

    if (_responses[surveyId] == null) {
      _responses[surveyId] = [];
    }
    _responses[surveyId]!.add(response);
    notifyListeners();
  }

  void completeSurvey(String surveyId) {
    final index = _availableSurveys.indexWhere((s) => s.id == surveyId);
    if (index != -1) {
      _availableSurveys[index] = Survey(
        id: _availableSurveys[index].id,
        title: _availableSurveys[index].title,
        description: _availableSurveys[index].description,
        questions: _availableSurveys[index].questions,
        totalPoints: _availableSurveys[index].totalPoints,
        isCompleted: true,
      );
      notifyListeners();
    }
  }

  List<Survey> getAvailableSurveys() {
    return _availableSurveys.where((s) => !s.isCompleted).toList();
  }

  List<Survey> getCompletedSurveys() {
    return _availableSurveys.where((s) => s.isCompleted).toList();
  }

  int getTotalPointsEarned() {
    return _responses.values
        .expand((responses) => responses)
        .fold(0, (sum, response) => sum + response.pointsEarned);
  }
}
