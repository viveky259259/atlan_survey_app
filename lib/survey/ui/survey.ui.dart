import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:survey_app/survey/model/survey.model.dart';
import 'package:survey_app/survey/model/survey.question.model.dart';
import 'package:survey_app/survey/provider/survey.provider.dart';
import 'package:survey_app/survey/provider/survey.server.dart';

class SurveyUi extends StatefulWidget {
  @override
  _SurveyUiState createState() => _SurveyUiState();
}

class _SurveyUiState extends State<SurveyUi> {
  List<SurveyModel> surveyModels;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((a) {
      getSurveys();
    });
  }

  getSurveys() async {
    surveyModels = await Provider.of<SurveyProvider>(context).getSurveys();
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
      body: (isLoading)
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            )
          : (surveyModels.length == 0)
              ? Text("No survey for today")
              : SingleChildScrollView(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: surveyModels.length,
                      itemBuilder: (context, index) {
                        SurveyModel surveyModel = surveyModels[index];
                        return ListTile(
                          title: Text(surveyModel.title),
                        );
                      })),
    );
  }
}
