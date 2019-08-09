import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  Color bgColor = Color(0xff6200ee);
  Color bgDarkColor = Color(0xff3700b3);

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

  static const platform = const MethodChannel('get/imei');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Survey History"),
          backgroundColor: bgColor,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [bgColor, bgColor],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : (surveyModels == null || surveyModels.length == 0)
                  ? Center(
                      child: Text(
                        "No Survey "
                        "Record found",
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: surveyModels.length,
                      itemBuilder: (context, index) {
                        List<SurveyQuestionModel> eachSurveyList =
                            surveyModels[index];

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(
                              height: 16,
                            ),
                            Text(
                              "Survey : ${index + 1}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            ListView.builder(
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
                                      text =
                                          questionModel.answerModels[i].answer;
                                    }
                                    if (text == null &&
                                        i ==
                                            questionModel.answerModels.length -
                                                1) {
                                      text = "";
                                    }
                                    i++;
                                  }
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "Q: ${questionModel.question}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              (questionModel.selectionType ==
                                                      AnswerSelectionType
                                                          .SINGLE_ANSWER)
                                                  ? Text("A: $text",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16))
                                                  : (questionModel
                                                              .selectionType ==
                                                          AnswerSelectionType
                                                              .MULTIPLE_ANSWER)
                                                      ? ListView.builder(
                                                          shrinkWrap: true,
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          itemCount: questionModel
                                                              .selectedAnsIndexForMultiple
                                                              .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            int currentAnsIndex =
                                                                questionModel
                                                                        .selectedAnsIndexForMultiple[
                                                                    index];
                                                            String text;
                                                            int i = 0;
                                                            while (
                                                                text == null) {
                                                              if (questionModel
                                                                      .answerModels[
                                                                          i]
                                                                      .id ==
                                                                  currentAnsIndex) {
                                                                text = questionModel
                                                                    .answerModels[
                                                                        i]
                                                                    .answer;
                                                              }
                                                              if (text ==
                                                                      null &&
                                                                  i ==
                                                                      questionModel
                                                                              .answerModels
                                                                              .length -
                                                                          1) {
                                                                text = "";
                                                              }
                                                              i++;
                                                            }
                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          2),
                                                              child: Text(
                                                                "A: $text",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                            );
                                                          },
                                                        )
                                                      : SizedBox(),
                                            ]),
                                      ),
                                      Divider(
                                        color: Colors.white,
                                      )
                                    ],
                                  );
                                }),
                            SizedBox(
                              height: 4,
                            ),
                          ],
                        );
                      },
                    ),
        ));
  }
}
