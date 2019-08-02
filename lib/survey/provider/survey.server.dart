import 'package:http/http.dart';
import 'package:survey_app/survey/delegate/jsonparser.delegate.dart';
import 'package:survey_app/survey/model/survey.question.model.dart';
import 'dart:convert';

class SurveyServer {
  Future<List<SurveyQuestionModel>> getQuestions() async {
    List<SurveyQuestionModel> questions;
    try {
      Response result =
          await get("http://demo8388355.mockable.io/survey/questions");
      var jsonResult = json.decode(result.body);
      if (result.statusCode == 200) {
        questions = List();
        jsonResult["questions"].forEach((each) {
          questions.add(jsonParserDelegate.getQuestionFromJson(each));
        });
      }
    } catch (e) {}

    return questions;
  }
}

SurveyServer surveyServer = SurveyServer();
