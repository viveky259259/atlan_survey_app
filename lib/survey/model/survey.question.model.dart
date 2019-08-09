import 'package:survey_app/survey/delegate/jsonparser.delegate.dart';
import 'package:survey_app/survey/model/survey.answer.model.dart';

class SurveyQuestionModel {
  final String question;

  List<SurveyAnswerModel> answerModels;
  final String selectionType; //single,multiple
  int selectedAnsIndexSingle;
  String surveyId;
  int questionId;
  List<int> selectedAnsIndexForMultiple = List();

  SurveyQuestionModel(
      this.question, this.answerModels, this.selectionType, this.surveyId,
      {this.selectedAnsIndexSingle = -1,
      this.selectedAnsIndexForMultiple,
      this.questionId}) {
    if (this.selectedAnsIndexForMultiple == null)
      selectedAnsIndexForMultiple = [];
  }

  SurveyQuestionModel copyInstance() {
    List<int> multipleIndex = List();
    List<SurveyAnswerModel> answers = List();
    this.answerModels.forEach((each) {
      answers.add(each);
    });
    return SurveyQuestionModel(question, answers, selectionType, surveyId,
        selectedAnsIndexSingle: selectedAnsIndexSingle,
        questionId: questionId,
        selectedAnsIndexForMultiple: multipleIndex);
  }

  factory SurveyQuestionModel.fromMap(
      Map<String, dynamic> json, bool isFromServer) {
    return jsonParserDelegate.getQuestionFromJson(json, isFromServer);
  }

  toMapForQuestionTable() {
    return {
      "question": question,
      "selection_type": selectionType,
      "survey_id": surveyId,
    };
  }

  toMapForUserAnswerTable(int surveyedId) {
    List<Map<String, dynamic>> list = List();
    if (selectionType == AnswerSelectionType.SINGLE_ANSWER) {
      list.add({
        "question_id": questionId,
        "answer_id": answerModels[selectedAnsIndexSingle].id,
        "survey_id": surveyId,
        "surveyed_count_id": surveyedId
      });
    } else {
      selectedAnsIndexForMultiple.forEach((each) {
        list.add({
          "question_id": questionId,
          "answer_id": answerModels[each].id,
          "survey_id": surveyId,
          "surveyed_count_id": surveyedId
        });
      });
    }
    return list;
  }

  List<Map<String, dynamic>> toMapForAnswerTable() {
    List<Map<String, dynamic>> list = List();

    answerModels.forEach((each) {
      list.add({
        "survey_id": surveyId,
        "question_id": questionId,
        "answer": each.answer
      });
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

    for (int i = 0; i < answerModels.length; i++) {
      stringBuffer.write(answerModels[i].answer);

      if (i != answerModels.length - 1) {
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
