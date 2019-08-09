class SurveyAnswerModel {
  String answer;
  int id;

  SurveyAnswerModel({this.answer, this.id});

  factory SurveyAnswerModel.fromMap(Map<String, dynamic> data) {
    return SurveyAnswerModel(answer: data["answer"], id: data["id"]);
  }

  SurveyAnswerModel copyInstance() {
    return SurveyAnswerModel(answer: answer, id: id);
  }
}
