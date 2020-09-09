import 'package:carousel_slider/carousel_slider.dart';
import 'package:datamine/Components/colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ImageSliderPlaceHolder extends StatefulWidget {
  @override
  _ImageSliderPlaceHolderState createState() => _ImageSliderPlaceHolderState();
}

class _ImageSliderPlaceHolderState extends State<ImageSliderPlaceHolder> {
  // ignore: unused_field
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Stack(
        children: [
          CarouselSlider(
            items: [ImageSliderItem()],
            options: CarouselOptions(
                height: 200,
                autoPlay: true,
                reverse: false,
                enableInfiniteScroll: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                initialPage: 0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class ImageSliderItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 3),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: [
              BoxShadow(spreadRadius: 1, blurRadius: 2, color: Colors.black12),
            ]),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(appBarColorlight),
          ),
        ),
      ),
    );
  }
}
