import 'package:http/http.dart';
import 'package:survey_app/survey/delegate/jsonparser.delegate.dart';
import 'package:survey_app/survey/model/survey.question.model.dart';
import 'dart:convert';

class SurveyServer {
  Future<List<SurveyQuestionModel>> getQuestions() async {
    List<SurveyQuestionModel> questions = List();
    try {
      Response result =
          await get("http://demo8388355.mockable.io/survey/questions");
      var jsonResult = json.decode(result.body);
      if (result.statusCode == 200) {
          jsonResult["questions"].forEach((each) {
            questions.add(jsonParserDelegate.getQuestionFromJson(each,true));
          });

      }
    } catch (e) {
      print(e);
    }

    return questions;
  }
}

SurveyServer surveyServer = SurveyServer();
