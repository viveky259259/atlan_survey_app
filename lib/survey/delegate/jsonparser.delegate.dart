import 'package:survey_app/survey/model/survey.question.model.dart';

class JsonParserDelegate {
  SurveyQuestionModel getQuestionFromJson(Map<String, dynamic> data) {
    String question = data["q"];
    List<String> answers = List();

    data["a"].forEach((each) {
      answers.add(each);
    });
    return SurveyQuestionModel(question, answers);
  }
}

JsonParserDelegate jsonParserDelegate = JsonParserDelegate();
