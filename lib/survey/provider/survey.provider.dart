import 'package:flutter/material.dart';
import 'package:survey_app/survey/delegate/internect_connectivity_delegate.dart';
import 'package:survey_app/survey/model/survey.question.model.dart';
import 'package:survey_app/survey/provider/survey.server.dart';

import 'db_provider.dart';

class SurveyProvider with ChangeNotifier {
  List<SurveyQuestionModel> _surveys;

  SurveyProvider();

  getSurveys() async {
    bool isInternetConnected = await NetworkCheckDelegate.check();

    if (_surveys == null || _surveys.length == 0) {
      if (isInternetConnected) _surveys = await surveyServer.getQuestions();
    }
    if (_surveys != null && _surveys.length > 0) {
      List<SurveyQuestionModel> oldRecords = await SurveyDatabaseProvider.db
          .getQuestionBySurveyId(_surveys.first.surveyId);

      if (oldRecords == null || oldRecords.length == 0) {
        for (SurveyQuestionModel each in _surveys) {
          await SurveyDatabaseProvider.db.addSurveyToDatabase(each);
        }
      }
      if (oldRecords == null || oldRecords.length == 0) {
        oldRecords = await SurveyDatabaseProvider.db
            .getQuestionBySurveyId(_surveys.first.surveyId);
      }
      return oldRecords;
    } else {
      List<SurveyQuestionModel> oldRecords =
          await SurveyDatabaseProvider.db.getAllQuestions();
      return oldRecords;
    }
  }

  getSurveyHistory() async {
    return await SurveyDatabaseProvider.db.getSavedSurvey();
  }

  saveSurvey(List<SurveyQuestionModel> questions) async {
    return await SurveyDatabaseProvider.db.saveAnswers(questions);
  }
}
