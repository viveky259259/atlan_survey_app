import 'package:survey_app/survey/delegate/jsonparser.delegate.dart';

class SurveyQuestionModel {
  final String question;
  List<String> answers;
  final String selectionType; //single,multiple
  int selectedAnsIndexSingle;
  String surveyId;
  int questionId;
  List<int> selectedAnsIndexForMultiple = List();

  SurveyQuestionModel(
      this.question, this.answers, this.selectionType, this.surveyId,
      {this.selectedAnsIndexSingle = -1,
      this.selectedAnsIndexForMultiple,
      this.questionId});

  factory SurveyQuestionModel.fromMap(
      Map<String, dynamic> json, bool isFromServer) {
    return jsonParserDelegate.getQuestionFromJson(json, isFromServer);
  }

  toMap() {
    return {
      "question": question,
      "selection_type": selectionType,
      "survey_id": surveyId,
      "answers": answers.toString(),
      "selectedAnsIndexSingle": selectedAnsIndexSingle,
      "selectedAnsIndexForMultiple": selectedAnsIndexForMultiple.toString(),
    };
  }

  toMapForQuestionTable() {
    return {
      "question": question,
      "selection_type": selectionType,
      "survey_id": surveyId,
    };
  }

  List<Map<String, dynamic>> toMapForAnswerTable() {
    List<Map<String, dynamic>> list = List();

    answers.forEach((each) {
      list.add(
          {"survey_id": surveyId, "question_id": questionId, "answer": each});
    });
    return list;

//    if (selectionType == AnswerSelectionType.SINGLE_ANSWER) {
//      return {
//        "survey_id":surveyId,
//        "question_id":questionId,
//        "answer":answers
//      };
//    } else if (selectionType == AnswerSelectionType.MULTIPLE_ANSWER) {}
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

class AnswerSelectionType {
  static const String SINGLE_ANSWER = "single";
  static const String MULTIPLE_ANSWER = "multiple";
}
