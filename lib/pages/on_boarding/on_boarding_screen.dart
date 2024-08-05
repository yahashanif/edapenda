import 'package:dapenda/app/constant.dart';
import 'package:dapenda/app/routes.dart';
import 'package:dapenda/pages/on_boarding/componens/indicator.dart';
import 'package:flutter/material.dart';
import 'sliders/main_slider.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> buildPageIndicator() {
    return List<Widget>.generate(_numPages, (int index) {
      return Indicator(isActive: index == _currentPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            physics: const ClampingScrollPhysics(),
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children:
                List.generate(_numPages, (index) => MainSlider(index: index)),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin:
                  EdgeInsets.only(bottom: getActualY(y: 30, context: context)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: buildPageIndicator(),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(
                  left: getActualX(x: 24, context: context),
                  right: getActualX(x: 24, context: context),
                  bottom: getActualY(y: 16, context: context)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _currentPage != 0
                      ? buildNavigationButton(
                          icon: Icons.keyboard_arrow_left,
                          onTap: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease,
                            );
                          },
                        )
                      : SizedBox(width: getActualX(x: 50, context: context)),
                  _currentPage != _numPages - 1
                      ? buildNavigationButton(
                          icon: Icons.keyboard_arrow_right,
                          onTap: () {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease,
                            );
                          },
                        )
                      : buildNavigationButton(
                          icon: Icons.check,
                          onTap: () {
                            Navigator.pushNamed(context, loginRoute);
                            // Navigation or other actions
                          },
                        ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildNavigationButton(
      {required IconData icon, required VoidCallback onTap}) {
    return Container(
      width: getActualX(x: 50, context: context),
      height: getActualY(y: 50, context: context),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(color: Colors.white),
      ),
      child: Center(
        child: GestureDetector(
          onTap: onTap,
          child: Icon(
            icon,
            size: getActualY(y: 40, context: context),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
