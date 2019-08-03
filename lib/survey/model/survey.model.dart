import 'package:survey_app/survey/model/survey.question.model.dart';

class SurveyModel {
  String title;
  List<SurveyQuestionModel> questions;

  SurveyModel({this.title, this.questions});
}
