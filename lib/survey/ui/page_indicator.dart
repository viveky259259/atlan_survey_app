import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  final int currentIndex;
  final int pageCount;

  PageIndicator(this.currentIndex, this.pageCount);

  _indicator(bool isActive) {
    return Expanded(
      child: Container(
        height: 4.0,
        decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.white30,
            boxShadow: [
              BoxShadow(
                  color: isActive ? Colors.white : Colors.white30,
                  offset: Offset(0.0, 1.0),
                  blurRadius: 10.0)
            ]),
      ),
    );
  }

  _buildPageIndicators() {
    List<Widget> indicatorList = [];
    for (int i = 0; i < pageCount; i++) {
      indicatorList
          .add(i <= currentIndex ? _indicator(true) : _indicator(false));
    }
    return indicatorList;
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: _buildPageIndicators(),
    );
  }
}
