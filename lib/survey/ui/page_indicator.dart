import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  final int currentIndex;
  final int pageCount;
  Color bgDarkColor = Color(0xa13700b3);
  final Function onClick;

  PageIndicator(this.currentIndex, this.pageCount, this.onClick);

  _indicator(bool isActive, int index) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        onTap: () {
          onClick(index);
        },
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            AnimatedContainer(
              height: 4.0,
              decoration: BoxDecoration(
                  color: isActive ? Colors.white70 : Colors.white30,
                  boxShadow: [
                    BoxShadow(
                        color: isActive ? Colors.white70 : Colors.white30,
                        offset: Offset(0.0, 1.0),
                        blurRadius: 10.0)
                  ]),
              duration: Duration(seconds: 2),
              // Provide an optional curve to make the animation feel smoother.
              curve: Curves.fastLinearToSlowEaseIn,
            ),
            CircleAvatar(
              backgroundColor: isActive ? Colors.white : bgDarkColor,
              child: Text(
                "${index + 1}",
                style: TextStyle(
                    color: isActive ? bgDarkColor : Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildPageIndicators() {
    List<Widget> indicatorList = [];
    for (int i = 0; i < pageCount; i++) {
      indicatorList
          .add(i <= currentIndex ? _indicator(true, i) : _indicator(false, i));
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
