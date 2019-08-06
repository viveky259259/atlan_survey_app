import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:survey_app/survey/model/survey.question.model.dart';
import 'package:survey_app/survey/provider/survey.provider.dart';
import 'package:survey_app/survey/ui/page_indicator.dart';
import 'package:survey_app/survey/ui/survey_item.dart';
import 'package:survey_app/survey/widgets/custom_app_bar.dart';

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
        duration: Duration(seconds: 1), curve: ElasticOutCurve(1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Color(0xff00a75d),
        Color(0xff4b9775),
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Stack(
        children: <Widget>[
          (isLoading)
              ? SizedBox()
              : (surveyModels.length == 0)
                  ? Text("No survey for today")
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        CustomAppBar("Survey", false, false),
                        SizedBox(height: 24),
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
//                            currentIndexOfPage = index;
                              SurveyQuestionModel surveyQuestionModel =
                                  surveyModels[index];

                              return SurveyItem(surveyQuestionModel,
                                  surveyModels.length, index);
                            },
                            pageSnapping: true,
                            physics: BouncingScrollPhysics(),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width - 32,
                          margin: EdgeInsets.all(16),
                          child: RaisedButton(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(16))),
                            padding: EdgeInsets.all(16),
                            onPressed: () {
                              if (currentIndexOfPage ==
                                  surveyModels.length - 1) {
                                saveAnswers();
                              } else {
                                doNext();
                              }
                            },
                            child:
                                (currentIndexOfPage == surveyModels.length - 1)
                                    ? Text("Submit",
                                        style: TextStyle(
                                            color: Colors.green.shade900,
                                            fontSize: 20,
                                            letterSpacing: 2,
                                            fontWeight: FontWeight.bold))
                                    : Text("Next",
                                        style: TextStyle(
                                            color: Colors.green.shade900,
                                            fontSize: 20,
                                            letterSpacing: 2,
                                            fontWeight: FontWeight.bold)),
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width - 32,
                            child: PageIndicator(
                                currentIndexOfPage, surveyModels.length)),
                        SizedBox(
                          height: 32,
                        )
                      ],
                    ),
          Positioned(
            top: MediaQuery.of(context).size.height / 2,
            left: MediaQuery.of(context).size.width / 2,
            child: (isLoading)
                ? Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : SizedBox(),
          )
        ],
      ),
    ));
  }
}
