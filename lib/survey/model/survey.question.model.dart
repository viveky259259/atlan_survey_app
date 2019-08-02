class SurveyQuestionModel {
  final String question;
  final List<String> answers;

  int selectedAnsIndex;

  SurveyQuestionModel(this.question, this.answers,
      {this.selectedAnsIndex = -1});


}
