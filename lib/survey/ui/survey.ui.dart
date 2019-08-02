import 'package:flutter/material.dart';
import 'package:survey_app/survey/model/survey.question.model.dart';
import 'package:survey_app/survey/provider/survey.server.dart';

class SurveyUi extends StatefulWidget {
  @override
  _SurveyUiState createState() => _SurveyUiState();
}

class _SurveyUiState extends State<SurveyUi> {
  List<SurveyQuestionModel> questions;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((a) {
      getQuestions();
    });
  }

  getQuestions() async {
    questions = await surveyServer.getQuestions();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Survey"),
      ),
      body: Center(
        child: (isLoading)
            ? CircularProgressIndicator()
            : (questions == null || questions.length == 0)
                ? Text("No survey for today")
                : Text("survey:${questions.length}"),
      ),
    );
  }
}
