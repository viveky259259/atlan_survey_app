import 'package:flutter/material.dart';
import 'package:survey_app/survey/model/survey.model.dart';
import 'package:survey_app/survey/provider/survey.server.dart';

class SurveyProvider with ChangeNotifier {
  List<SurveyModel> _surveys;

  SurveyProvider();

  getSurveys() async {
    if (_surveys == null || _surveys.length == 0) {
      _surveys = await surveyServer.getQuestions();
    }
    return _surveys;
  }
}
