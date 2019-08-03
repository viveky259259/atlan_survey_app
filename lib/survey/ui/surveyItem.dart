import 'package:flutter/material.dart';
import 'package:survey_app/survey/model/survey.question.model.dart';

class SurveyItem extends StatefulWidget {
  final SurveyQuestionModel surveyQuestionModel;

  SurveyItem(this.surveyQuestionModel);

  @override
  _SurveyItemState createState() => _SurveyItemState();
}

class _SurveyItemState extends State<SurveyItem> {
  Widget getCheckerIcon(int index) {
    if (widget.surveyQuestionModel.type.compareTo("single") == 0) {
      if (widget.surveyQuestionModel.selectedAnsIndexSingle == -1 ||
          widget.surveyQuestionModel.selectedAnsIndexSingle != index) {
        return Icon(Icons.radio_button_unchecked);
      } else {
        return Icon(Icons.radio_button_checked);
      }
    } else if (widget.surveyQuestionModel.type.compareTo("multiple") == 0) {
      if (widget.surveyQuestionModel.selectedAnsIndexForMultiple.length == 0 ||
          !widget.surveyQuestionModel.selectedAnsIndexForMultiple
              .contains(index)) {
        return Icon(Icons.check_box_outline_blank);
      } else {
        return Icon(Icons.check_box);
      }
    } else
      return Icon(Icons.radio_button_unchecked);
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
      children: <Widget>[
        ListTile(
          title: Text(widget.surveyQuestionModel.question),
        ),
        ListView.builder(
            shrinkWrap: true,
            itemCount: widget.surveyQuestionModel.answers.length,
            itemBuilder: (context, index) {
              String answer = widget.surveyQuestionModel.answers[index];
              return InkWell(
                onTap: () {
                  updateAnswerStatus(index);
                },
                child: Row(
                  children: <Widget>[getCheckerIcon(index), Text(answer)],
                ),
              );
            })
      ],
    );
  }
}
