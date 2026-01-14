import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/survey_model.dart';
import '../services/survey_service.dart';
import '../services/points_service.dart';
import '../services/auth_service.dart';

class SurveyScreen extends StatefulWidget {
  const SurveyScreen({super.key});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

class _SurveyScreenState extends State<SurveyScreen> {
  Survey? _selectedSurvey;
  int _currentQuestionIndex = 0;
  final Map<String, dynamic> _answers = {};

  @override
  Widget build(BuildContext context) {
    final surveyService = context.watch<SurveyService>();
    final availableSurveys = surveyService.getAvailableSurveys();

    if (_selectedSurvey == null) {
      return _buildSurveyList(availableSurveys);
    } else {
      return _buildSurveyQuestions();
    }
  }

  Widget _buildSurveyList(List<Survey> surveys) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Surveys'),
        backgroundColor: Colors.transparent,
      ),
      body: surveys.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: surveys.length,
              itemBuilder: (context, index) {
                return _buildSurveyCard(surveys[index]);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 80,
            color: Colors.white.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'All surveys completed!',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for new surveys',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSurveyCard(Survey survey) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF833AB4), // Instagram Purple
            Color(0xFFE1306C), // Instagram Pink
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedSurvey = survey;
              _currentQuestionIndex = 0;
              _answers.clear();
            });
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        survey.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '+${survey.totalPoints} pts',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  survey.description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.question_answer,
                      size: 16,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${survey.questions.length} questions',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.timer_outlined,
                      size: 16,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '~${survey.questions.length} min',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSurveyQuestions() {
    final question = _selectedSurvey!.questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _selectedSurvey!.questions.length;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            setState(() {
              _selectedSurvey = null;
              _currentQuestionIndex = 0;
              _answers.clear();
            });
          },
        ),
        title: Text(
          'Question ${_currentQuestionIndex + 1}/${_selectedSurvey!.questions.length}',
        ),
      ),
      body: Column(
        children: [
          // Progress bar
          Container(
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF3897F0), // Instagram Blue
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question.question,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildQuestionInput(question),
                ],
              ),
            ),
          ),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildQuestionInput(SurveyQuestion question) {
    switch (question.type) {
      case SurveyQuestionType.multipleChoice:
      case SurveyQuestionType.yesNo:
        return _buildMultipleChoice(question);
      case SurveyQuestionType.rating:
        return _buildRating(question);
    }
  }

  Widget _buildMultipleChoice(SurveyQuestion question) {
    return Column(
      children: question.options!.map((option) {
        final isSelected = _answers[question.id] == option;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF3897F0).withOpacity(0.2)
                : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF3897F0)
                  : Colors.white.withOpacity(0.2),
              width: 2,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _answers[question.id] = option;
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: isSelected
                          ? const Color(0xFF3897F0)
                          : Colors.white.withOpacity(0.5),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        option,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : Colors.white.withOpacity(0.9),
                          fontSize: 16,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRating(SurveyQuestion question) {
    final rating = _answers[question.id] as int? ?? 0;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(
                index < rating ? Icons.star : Icons.star_border,
                size: 48,
                color: index < rating
                    ? const Color(0xFFFCAF45) // Instagram Yellow
                    : Colors.white.withOpacity(0.3),
              ),
              onPressed: () {
                setState(() {
                  _answers[question.id] = index + 1;
                });
              },
            );
          }),
        ),
        const SizedBox(height: 16),
        if (rating > 0)
          Text(
            _getRatingText(rating),
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
            ),
          ),
      ],
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent';
      default:
        return '';
    }
  }

  Widget _buildNavigationButtons() {
    final currentQuestion = _selectedSurvey!.questions[_currentQuestionIndex];
    final hasAnswer = _answers.containsKey(currentQuestion.id);
    final isLastQuestion =
        _currentQuestionIndex == _selectedSurvey!.questions.length - 1;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          if (_currentQuestionIndex > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  setState(() {
                    _currentQuestionIndex--;
                  });
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withOpacity(0.3)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Back'),
              ),
            ),
          if (_currentQuestionIndex > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: hasAnswer
                  ? () {
                      if (isLastQuestion) {
                        _completeSurvey();
                      } else {
                        setState(() {
                          _currentQuestionIndex++;
                        });
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3897F0), // Instagram Blue
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: Colors.white.withOpacity(0.2),
              ),
              child: Text(
                isLastQuestion ? 'Complete Survey' : 'Next',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _completeSurvey() {
    final surveyService = context.read<SurveyService>();
    final pointsService = context.read<PointsService>();
    final authService = context.read<AuthService>();
    final userId = authService.currentUser?.uid ?? 'anonymous';

    // Submit all responses
    _answers.forEach((questionId, answer) {
      final question = _selectedSurvey!.questions
          .firstWhere((q) => q.id == questionId);
      surveyService.submitResponse(
        _selectedSurvey!.id,
        questionId,
        answer,
        userId,
        question.pointsReward,
      );
    });

    // Award total points
    pointsService.addPoints(
      _selectedSurvey!.totalPoints,
      'Completed survey: ${_selectedSurvey!.title}',
    );

    // Mark survey as completed
    surveyService.completeSurvey(_selectedSurvey!.id);

    // Show completion dialog
    _showCompletionDialog();
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF262626),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF833AB4),
                    Color(0xFFE1306C),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                size: 48,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Survey Completed!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'You earned ${_selectedSurvey!.totalPoints} points!',
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _selectedSurvey = null;
                  _currentQuestionIndex = 0;
                  _answers.clear();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3897F0),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}
