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
            : ListView.builder(
                shrinkWrap: true,
                itemCount: surveyModels.length,
                itemBuilder: (context, index) {
                  List<SurveyQuestionModel> eachSurveyList =
                      surveyModels[index];

                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: eachSurveyList.length,
                      itemBuilder: (context, index) {
                        SurveyQuestionModel questionModel =
                            eachSurveyList[index];
                        return ListTile(
                          title: Text(questionModel.question),
                        );
                      });
                },
              ));
  }
}
