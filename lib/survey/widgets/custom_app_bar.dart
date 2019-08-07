import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final bool isBackNeeded;
  final bool isEndNeeded;
  final bool isHistoryNeeded;
  final Function onHistoryClick;

  CustomAppBar(this.title, this.isBackNeeded, this.isEndNeeded,
      {this.isHistoryNeeded = false, this.onHistoryClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      alignment: Alignment.bottomCenter,
      child: Row(
        children: <Widget>[
          (isBackNeeded)
              ? Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                )
              : SizedBox(),
          Spacer(),
          Text(
            title,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 24),
          ),
          Spacer(),
          (isEndNeeded)
              ? Icon(
                  Icons.close,
                  color: Colors.white,
                )
              : SizedBox(),
          (isHistoryNeeded)
              ? IconButton(
                  onPressed: onHistoryClick,
                  icon: Icon(
                    Icons.history,
                    color: Colors.white,
                  ))
              : SizedBox()
        ],
      ),
    );
  }
}
