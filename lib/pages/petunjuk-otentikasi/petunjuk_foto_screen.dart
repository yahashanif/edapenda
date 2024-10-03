import 'package:dapenda/themes/themes.dart';
import 'package:flutter/material.dart';

import '../../app/constant.dart';
import '../../app/routes.dart';
import 'componens/indicator.dart';
import 'sliders/main_slider.dart';

class PetunjukFotoScreen extends StatefulWidget {
  final String route;

  const PetunjukFotoScreen({super.key, required this.route});

  @override
  State<PetunjukFotoScreen> createState() => _PetunjukFotoScreenState();
}

class _PetunjukFotoScreenState extends State<PetunjukFotoScreen> {
  final int _numPages = 2;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> buildPageIndicator() {
    return List<Widget>.generate(_numPages, (int index) {
      return Indicator(isActive: index == _currentPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          margin: EdgeInsets.symmetric(
              horizontal: getActualX(x: defaultMargin, context: context),
              vertical: getActualY(y: defaultMargin, context: context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Petunjuk Verifikasi Foto",
                style: tahomaB.copyWith(
                    fontSize: getActualY(y: 18, context: context)),
              ),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: PageView(
                        physics: const ClampingScrollPhysics(),
                        controller: _pageController,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        children: List.generate(_numPages,
                            (index) => MainSliderPetunjuk(index: index)),
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            _currentPage != 0
                                ? buildNavigationButton(
                                    icon: Icons.keyboard_arrow_left,
                                    onTap: () {
                                      _pageController.previousPage(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.ease,
                                      );
                                    },
                                  )
                                : SizedBox(
                                    width: getActualX(x: 50, context: context)),
                            Container(
                              // margin: EdgeInsets.only(
                              //     bottom: getActualY(y: 30, context: context)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: buildPageIndicator(),
                              ),
                            ),
                            _currentPage != _numPages - 1
                                ? buildNavigationButton(
                                    icon: Icons.keyboard_arrow_right,
                                    onTap: () {
                                      _pageController.nextPage(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.ease,
                                      );
                                    },
                                  )
                                : buildNavigationButton(
                                    icon: Icons.check,
                                    onTap: () {
                                      Navigator.popAndPushNamed(
                                          context, widget.route);
                                      // Navigation or other actions
                                    },
                                  ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
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
        border: Border.all(color: green),
      ),
      child: Center(
        child: GestureDetector(
          onTap: onTap,
          child: Icon(
            icon,
            size: getActualY(y: 40, context: context),
            color: green,
          ),
        ),
      ),
    );
  }
}
