import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:survey_app/survey/model/survey.question.model.dart';
import 'package:survey_app/survey/provider/survey.provider.dart';

class SurveyHistoryUi extends StatefulWidget {
  @override
  _SurveyHistoryUiState createState() => _SurveyHistoryUiState();
}

class _SurveyHistoryUiState extends State<SurveyHistoryUi> {
  List<List<SurveyQuestionModel>> surveyModels = List();
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getHistory();
    });
  }

  getHistory() async {
    surveyModels =
        await Provider.of<SurveyProvider>(context).getSurveyHistory();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : (surveyModels == null || surveyModels.length == 0)
                ? Center(
                    child: Text("No "
                        "History"),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: surveyModels.length,
                    itemBuilder: (context, index) {
                      List<SurveyQuestionModel> eachSurveyList =
                          surveyModels[index];

                      return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: eachSurveyList.length,
                          itemBuilder: (context, index) {
                            SurveyQuestionModel questionModel =
                                eachSurveyList[index];
                            String text;
                            int i = 0;
                            while (text == null) {
                              if (questionModel.answerModels[i].id ==
                                  questionModel.selectedAnsIndexSingle) {
                                text = questionModel.answerModels[i].answer;
                              }
                              if (text == null &&
                                  i == questionModel.answerModels.length - 1) {
                                text = "";
                              }
                              i++;
                            }
                            return ListTile(
                                title: Text(questionModel.question),
                                subtitle: (questionModel.selectionType ==
                                        AnswerSelectionType.SINGLE_ANSWER)
                                    ? Text(text)
                                    : (questionModel.selectionType ==
                                            AnswerSelectionType.MULTIPLE_ANSWER)
                                        ? ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount: questionModel
                                                .selectedAnsIndexForMultiple
                                                .length,
                                            itemBuilder: (context, index) {
                                              int currentAnsIndex = questionModel
                                                      .selectedAnsIndexForMultiple[
                                                  index];
                                              String text;
                                              int i = 0;
                                              while (text == null) {
                                                if (questionModel
                                                        .answerModels[i].id ==
                                                    currentAnsIndex) {
                                                  text = questionModel
                                                      .answerModels[i].answer;
                                                }
                                                if (text == null &&
                                                    i ==
                                                        questionModel
                                                                .answerModels
                                                                .length -
                                                            1) {
                                                  text = "";
                                                }
                                                i++;
                                              }
                                              return Text(text);
                                            },
                                          )
                                        : SizedBox());
                          });
                    },
                  ));
  }
}
