import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:survey_app/survey/delegate/snackbar_delegate.dart';
import 'package:survey_app/survey/model/survey.question.model.dart';
import 'package:survey_app/survey/provider/db_provider.dart';
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
  Color bgColor = Color(0xff6200ee);
  Color bgDarkColor = Color(0xff3700b3);
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((a) {
      getSurveys();
    });
  }

  getSurveys() async {
    SurveyDatabaseProvider.db.getSurveyedCount();
    surveyModels = await Provider.of<SurveyProvider>(context).getSurveys();
    setState(() {
      isLoading = false;
    });
  }

  saveAnswers(context) async {
    bool isEverythingCorrect = true;
    int i = 0;
    for (SurveyQuestionModel model in surveyModels) {
      if (model.selectionType == AnswerSelectionType.SINGLE_ANSWER) {
        if (model.selectedAnsIndexSingle == -1) {
          SnackBarDelegate.showSnackBar(
              context, "Please select one!", _scaffoldKey,
              time: 2000);
          print("break");
          pageController.animateToPage(i,
              duration: Duration(seconds: 2),
              curve: Curves.fastLinearToSlowEaseIn);
          isEverythingCorrect = false;
          break;
        }
        i++;
        print(1);
      }
    }
    if (!isEverythingCorrect) return;
    print("save");
    var result =
        await Provider.of<SurveyProvider>(context).saveSurvey(surveyModels);
    print("result:$result");
    showDialogOnSurveyComplete(context);
    resetAnswers();
  }

  resetAnswers() {
    getSurveys();
    pageController.animateToPage(0,
        duration: Duration(seconds: 3), curve: Curves.fastLinearToSlowEaseIn);
  }

  showDialogOnSurveyComplete(context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Survey Completed"),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16))),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[Text("Thanks for giving feedback")],
              ),
            ),
            actions: <Widget>[
              RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                color: bgDarkColor,
                child: Text(
                  "Okay",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 20),
                ),
              )
            ],
          );
        });
  }

  doNext() {
    currentIndexOfPage = currentIndexOfPage + 1;
    pageController.animateToPage(currentIndexOfPage,
        duration: Duration(seconds: 1), curve: ElasticOutCurve(1));
  }

  onClickPageIndicatorItem(int index) {
    pageController.animateToPage(index,
        duration: Duration(seconds: 1), curve: ElasticOutCurve(1));
  }

  onHistoryClick() {
    Navigator.of(context).pushNamed("/history");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
//      appBar: AppBar(
//        title: Text("Test"),
//        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.add),
//            onPressed: () async {
//              if (surveyModels != null && surveyModels.length > 0) {
//                surveyModels.forEach((each) async {
//                  await SurveyDatabaseProvider.db.addSurveyToDatabase(each);
//                });
//              }
//            },
//          ),
//          IconButton(
//            icon: Icon(Icons.get_app),
//            onPressed: () async {
//              List<SurveyQuestionModel> oldRecords =
//                  await SurveyDatabaseProvider.db.getAllQuestions();
//              setState(() {
//                isLoading = false;
//                surveyModels = oldRecords;
//              });
//              print(oldRecords.length);
//            },
//          )
//        ],
//      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height -
              MediaQuery.of(context).viewPadding.bottom,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [bgColor, bgColor],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          child: Stack(
            children: <Widget>[
              (isLoading)
                  ? Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Center(
                          child: CircularProgressIndicator(
//                  backgroundColor: Color(0xffFFDE01),
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.white),
                      )),
                    )
                  : SizedBox(),
              (isLoading)
                  ? SizedBox()
                  : (surveyModels.length == 0)
                      ? Center(
                          child: Text(
                            "No surveys for today",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            CustomAppBar(
                              "Survey",
                              false,
                              false,
                              isHistoryNeeded: true,
                              onHistoryClick: onHistoryClick,
                            ),
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
                                  SurveyQuestionModel surveyQuestionModel =
                                      surveyModels[index];

                                  return SurveyItem(surveyQuestionModel,
                                      surveyModels.length, index);
                                },
                                pageSnapping: true,
                                physics: BouncingScrollPhysics(),
                              ),
                            ),
                          ],
                        ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: bgColor,
        child: (isLoading || surveyModels == null || surveyModels.length == 0)
            ? SizedBox()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width - 32,
                    margin: EdgeInsets.all(16),
                    child: RaisedButton(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      padding: EdgeInsets.all(16),
                      onPressed: () {
                        if (currentIndexOfPage == surveyModels.length - 1) {
                          saveAnswers(context);
                        } else {
                          doNext();
                        }
                      },
                      child: (currentIndexOfPage == surveyModels.length - 1)
                          ? Text("Submit",
                              style: TextStyle(
                                  color: bgDarkColor,
                                  fontSize: 20,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.bold))
                          : Text("Next",
                              style: TextStyle(
                                  color: bgDarkColor,
                                  fontSize: 20,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: PageIndicator(
                            currentIndexOfPage,
                            surveyModels.length,
                            onClickPageIndicatorItem,
                            surveyModels),
                      )),
                  SizedBox(
                    height: 16,
                  )
                ],
              ),
      ),
    );
  }
}
