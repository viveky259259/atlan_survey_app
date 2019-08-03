import 'package:survey_app/survey/model/survey.question.model.dart';

class JsonParserDelegate {
  SurveyQuestionModel getQuestionFromJson(
      Map<String, dynamic> data, bool isFromServer) {
    String question = data["question"];
    String type = data["selection_type"];
    String id = data["survey_id"];
    List<String> answers = List();
    if (isFromServer) {
      data["answers"].forEach((each) {
        answers.add(each);
      });
    } else {
      answers = data["answers"].toString().split(",");
    }

    return SurveyQuestionModel(question, answers, type, id);
  }
}

JsonParserDelegate jsonParserDelegate = JsonParserDelegate();
