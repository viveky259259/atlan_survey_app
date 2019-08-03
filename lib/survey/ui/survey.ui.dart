import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:survey_app/survey/model/survey.question.model.dart';
import 'package:survey_app/survey/provider/survey.provider.dart';
import 'package:survey_app/survey/provider/survey.server.dart';
import 'package:survey_app/survey/ui/page_indicator.dart';
import 'package:survey_app/survey/ui/surveyItem.dart';

class SurveyUi extends StatefulWidget {
  @override
  _SurveyUiState createState() => _SurveyUiState();
}

class _SurveyUiState extends State<SurveyUi> {
  List<SurveyQuestionModel> surveyModels;
  bool isLoading = true;
  PageController pageController = PageController();
  double currentPageValue = 0.0;
  int currentIndexOfPage = 0;

  @override
  void initState() {
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

  saveAnswers() {
    print("save");
  }

  doNext() {
    currentIndexOfPage = currentIndexOfPage + 1;
    pageController.animateToPage(currentIndexOfPage,
        duration: Duration(microseconds: 374), curve: ElasticOutCurve());
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
                : Column(
                    children: <Widget>[
                      Expanded(
                        child: PageView.builder(
                          itemCount: surveyModels.length,
                          controller: pageController,
                          onPageChanged: (index) {
                            setState(() {
                              currentIndexOfPage = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            currentIndexOfPage = index;
                            SurveyQuestionModel surveyQuestionModel =
                                surveyModels[index];

                            return SurveyItem(surveyQuestionModel);
                          },
                          pageSnapping: true,
                          physics: BouncingScrollPhysics(),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 32,
                        margin: EdgeInsets.all(16),
                        child: RaisedButton(
                          padding: EdgeInsets.all(16),
                          onPressed: () {
                            if (currentIndexOfPage == surveyModels.length - 1) {
                              saveAnswers();
                            } else {
                              doNext();
                            }
                          },
                          child: (currentIndexOfPage == surveyModels.length - 1)
                              ? Text("Complete")
                              : Text("Next"),
                        ),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width - 32,

                          child: PageIndicator(currentIndexOfPage, surveyModels.length)),
                      SizedBox(
                        height: 32,
                      )
                    ],
                  ));
  }
}
