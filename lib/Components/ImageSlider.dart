import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:datamine/Components/colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ImageSlider extends StatefulWidget {
  List imgUrls;
  ImageSlider({@required this.imgUrls});
  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  // ignore: unused_field
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Stack(
        children: [
          CarouselSlider(
            items: List.generate(widget.imgUrls.length, (index) {
              return ImageSliderItem(url: widget.imgUrls[index]);
            }),
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.imgUrls.map((url) {
                int index = widget.imgUrls.indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        _current == index ? appbarTextColorLight : Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class ImageSliderItem extends StatelessWidget {
  String url;
  ImageSliderItem({@required this.url});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 3),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
            boxShadow: [
              BoxShadow(spreadRadius: 1, blurRadius: 2, color: Colors.black12),
            ]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: CachedNetworkImage(
            imageUrl: url,
            errorWidget: (context, url, error) {
              return Center(
                child: Icon(
                  Icons.error,
                  color: Colors.red,
                ),
              );
            },
            progressIndicatorBuilder: (context, url, progress) {
              return Center(
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(appBarColorlight),
                  ),
                ),
              );
            },
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
