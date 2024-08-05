import 'package:carousel_slider/carousel_slider.dart';
import 'package:dapenda/app/constant.dart';
import 'package:flutter/material.dart';

import '../../themes/themes.dart';

class CarouselSliderBerita extends StatelessWidget {
  final PageController controller;
  final Function(int) onSlide;

  const CarouselSliderBerita(
      {super.key, required this.controller, required this.onSlide});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: getActualY(y: 200, context: context),
        child: CarouselSlider(
          items: List.generate(
              3,
              (index) => GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => Berita(
                      //       idberita: _berita[index]['id_berita'],
                      //     ),
                      //   ),
                      // );
                    },
                    child: Container(
                      width: double.infinity,
                      height: getActualY(y: 200, context: context),
                      decoration: BoxDecoration(
                        color: green,
                        borderRadius: BorderRadius.circular(8),
                        // image: DecorationImage(
                        // image: NetworkImage(
                        // _berita[index]['gambar_thumb'],
                        // ),
                        // fit: BoxFit.cover,
                        // ),
                      ),
                    ),
                  )),
          options: CarouselOptions(
            autoPlay: true,
            initialPage: 0,
            onPageChanged: (index, reason) {
              // divSetState(() {
              //   currentIndex = index;
              // });
            },
          ),
        )

        // PageView.builder(
        //   onPageChanged: (int page) {
        //     onSlide(page);
        //     // setState(() {
        //     //   currentPageValue = page;
        //     // });
        //   },
        //   controller: controller,
        //   itemCount: 3,
        //   itemBuilder: (context, index) {
        //     return GestureDetector(
        //       onTap: () {
        //         // Navigator.push(
        //         //   context,
        //         //   MaterialPageRoute(
        //         //     builder: (context) => Berita(
        //         //       idberita: _berita[index]['id_berita'],
        //         //     ),
        //         //   ),
        //         // );
        //       },
        //       child: Container(
        //         width: double.infinity,
        //         height: getActualY(y: 200, context: context),
        //         decoration: BoxDecoration(
        //           color: green,
        //           borderRadius: BorderRadius.circular(8),
        //           // image: DecorationImage(
        //           // image: NetworkImage(
        //           // _berita[index]['gambar_thumb'],
        //           // ),
        //           // fit: BoxFit.cover,
        //           // ),
        //         ),
        //       ),
        //     );
        //   },
        // ),
        );
  }
}
