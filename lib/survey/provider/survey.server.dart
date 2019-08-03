import 'package:http/http.dart';
import 'package:survey_app/survey/delegate/jsonparser.delegate.dart';
import 'package:survey_app/survey/model/survey.model.dart';
import 'package:survey_app/survey/model/survey.question.model.dart';
import 'dart:convert';

class SurveyServer {
  Future<List<SurveyModel>> getQuestions() async {
    List<SurveyModel> surveys = List();
    try {
      Response result =
          await get("http://demo8388355.mockable.io/survey/questions");
      var jsonResult = json.decode(result.body);
      if (result.statusCode == 200) {
        jsonResult["surveys"].forEach((eachSurvey) {
          SurveyModel surveyModel = SurveyModel();
          List<SurveyQuestionModel> questions = List();
          surveyModel.title = eachSurvey["title"];
          eachSurvey["questions"].forEach((each) {
            questions.add(jsonParserDelegate.getQuestionFromJson(each));
          });
          surveyModel.questions = questions;
          surveys.add(surveyModel);
        });
      }
    } catch (e) {
      print(e);
    }

    return surveys;
  }
}

SurveyServer surveyServer = SurveyServer();
