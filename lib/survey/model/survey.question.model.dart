import 'package:survey_app/survey/delegate/jsonparser.delegate.dart';

class SurveyQuestionModel {
  final String question;
  final List<String> answers;
  final String type; //single,multiple
  int selectedAnsIndexSingle;
  String surveyId;
  List<int> selectedAnsIndexForMultiple = List();

  SurveyQuestionModel(this.question, this.answers, this.type, this.surveyId,
      {this.selectedAnsIndexSingle = -1, selectedAnsIndexForMultiple});

  factory SurveyQuestionModel.fromMap(Map<String, dynamic> json,bool isFromServer) {
    return jsonParserDelegate.getQuestionFromJson(json,isFromServer);
  }

  toMap() {
    return {
      "question": question,
      "selection_type": type,
      "survey_id": surveyId,
      "answers": answers.toString(),
      "selectedAnsIndexSingle": selectedAnsIndexSingle,
      "selectedAnsIndexForMultiple": selectedAnsIndexForMultiple.toString(),
    };
  }

  toMapForTable() {
    return {
      "question": question,
      "selection_type": type,
      "survey_id": surveyId,
      "answers": getAnswerInString()
    };
  }


  getAnswerInString() {
    StringBuffer stringBuffer = StringBuffer();

    for (int i = 0; i < answers.length; i++) {
      stringBuffer.write(answers[i]);

      if (i != answers.length - 1) {
        stringBuffer.write(",");
      }
    }
    print(stringBuffer.toString());
    return stringBuffer.toString();
  }
}
