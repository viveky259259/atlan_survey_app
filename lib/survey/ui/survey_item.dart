import 'package:flutter/material.dart';
import 'package:survey_app/survey/model/survey.question.model.dart';

class SurveyItem extends StatefulWidget {
  final SurveyQuestionModel surveyQuestionModel;
  final int length;
  final int index;

  SurveyItem(this.surveyQuestionModel, this.length, this.index);

  @override
  _SurveyItemState createState() => _SurveyItemState();
}

class _SurveyItemState extends State<SurveyItem> {
  Widget getCheckerIcon(int index) {
    if (widget.surveyQuestionModel.type.compareTo("single") == 0) {
      if (widget.surveyQuestionModel.selectedAnsIndexSingle == -1 ||
          widget.surveyQuestionModel.selectedAnsIndexSingle != index) {
        return Icon(
          Icons.radio_button_unchecked,
          color: Colors.white,
        );
      } else {
        return Icon(Icons.radio_button_checked, color: Colors.white);
      }
    } else if (widget.surveyQuestionModel.type.compareTo("multiple") == 0) {
      if (widget.surveyQuestionModel.selectedAnsIndexForMultiple.length == 0 ||
          !widget.surveyQuestionModel.selectedAnsIndexForMultiple
              .contains(index)) {
        return Icon(Icons.check_box_outline_blank, color: Colors.white);
      } else {
        return Icon(Icons.check_box, color: Colors.white);
      }
    } else
      return Icon(Icons.radio_button_unchecked, color: Colors.white);
  }

  updateAnswerStatus(index) {
    if (widget.surveyQuestionModel.type.compareTo("single") == 0) {
//      if (widget.surveyQuestionModel.selectedAnsIndexSingle == -1 &&
//          widget.surveyQuestionModel.selectedAnsIndexSingle != index) {
//        widget.surveyQuestionModel.selectedAnsIndexSingle = index;
//
//      } else {
//        widget.surveyQuestionModel.selectedAnsIndexSingle = index;
//      }
      widget.surveyQuestionModel.selectedAnsIndexSingle = index;
    } else if (widget.surveyQuestionModel.type.compareTo("multiple") == 0) {
      if (widget.surveyQuestionModel.selectedAnsIndexForMultiple
          .contains(index)) {
        widget.surveyQuestionModel.selectedAnsIndexForMultiple.remove(index);
      } else
        widget.surveyQuestionModel.selectedAnsIndexForMultiple.add(index);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
//      mainAxisAlignment: MainAxisAlignment.center,
//      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          "QUESTION ${widget.index + 1} OF ${widget.length} ",
          style: TextStyle(
              color: Colors.white,
              letterSpacing: 2,
              fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 16,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(widget.surveyQuestionModel.question,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.surveyQuestionModel.answers.length,
              itemBuilder: (context, index) {
                String answer = widget.surveyQuestionModel.answers[index];
                return InkWell(
                  onTap: () {
                    updateAnswerStatus(index);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(flex: 1, child: getCheckerIcon(index)),
                            Expanded(
                                flex: 5,
                                child: Text(
                                  answer,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ))
                          ],
                        ),
                      ),
                      Padding(
                          child: ((index + 1) <
                                  widget.surveyQuestionModel.answers.length)
                              ? Divider(
                                  color: Colors.white,
                                )
                              : SizedBox(),
                          padding: EdgeInsets.symmetric(horizontal: 16)),
                    ],
                  ),
                );
              }),
        )
      ],
    );
  }
}
