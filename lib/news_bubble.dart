import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsBubble extends StatelessWidget {
  NewsBubble({this.newsPara, this.heading, this.imageurl, this.readmore});

  final String newsPara;
  final String heading;
  final String imageurl;
  final String readmore;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        children: <Widget>[
          Material(
            elevation: 1.0,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        imageurl != null
                            ? GestureDetector(
                                child: CachedNetworkImage(
                                  imageUrl: imageurl,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, object) =>
                                      Icon(Icons.error),
                                ),
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (_) {
                                    return DetailScreen(
                                      imageUrl: imageurl,
                                    );
                                  }));
                                },
                              )
                            : SizedBox.shrink(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Text(
                            heading,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        Text(
                          newsPara,
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.black54,
                          ),
                        ),
                        GestureDetector(
                            child: Text("read more at balliakhabar.com",
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.black)),
                            onTap: () async {
                              if (await canLaunch(readmore)) {
                                await launch(readmore);
                              } else {
                                throw 'Could not launch $readmore';
                              }
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {

  final String imageUrl;
  DetailScreen({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: PhotoView(
          imageProvider: CachedNetworkImageProvider(imageUrl),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
