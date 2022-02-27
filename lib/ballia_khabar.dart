import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/text_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'bloc/posts/posts_cubit.dart';
import 'bloc/posts/posts_service.dart';
import 'constants.dart';
import 'news_bubble.dart';
import 'text_widgets.dart';
import 'push_nofitications.dart';

PageController _pageController;

class BalliaKhabar extends StatelessWidget {
  static const String id = 'mainscreen_screen';

  final scrollController = ScrollController();

  void setupScrollController(context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          BlocProvider.of<PostsCubit>(context).loadPosts(false);
        }
      }
    });
  }

  void initState() {
    _pageController = PageController();
  }

  void dispose() {
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PushNotificationsManager().init();
    setupScrollController(context);
    BlocProvider.of<PostsCubit>(context).loadPosts(false);
    return new Scaffold(
        body: DefaultTabController(
            length: 1,
            child: Scaffold(
              drawer: SafeArea(
                child: Container(
                  width: 340,
                  child: Drawer(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        Container(
                          height: 270,
                          child: DrawerHeader(
                            child: Column(
                              children: <Widget>[
                                HeadingTextWidget(
                                  heading: "बलिया ख़बर",
                                  fontSize: 20.0,
                                  color: Colors.black,
                                ),
                                ReusableTextWidgetWithPadding(
                                  text: "में आपका स्वागत है",
                                  color: Colors.black54,
                                  fontSize: 16.0,
                                ),
                                ReusableTextWidgetWithPadding(
                                  text: contentInvitation,
                                  color: Colors.black54,
                                  fontSize: 16.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                        ListTile(
                          title: Row(
                            children: [
                              HeadingTextWidget(
                                heading: "प्राइवेसी पालिसी / Privacy policy",
                                fontSize: 20.0,
                                color: Colors.black,
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.open_in_new,
                                  ),
                                  onPressed: () async {
                                    const url =
                                        'https://balliakhabar.com/privacy-policy/';
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  }),
                            ],
                          ),
                          subtitle: ReusableTextWidgetWithPadding(
                            text: privacyPolicy,
                            color: Colors.black54,
                            fontSize: 16.0,
                          ),
                        ),
                        ListTile(
                          title: Row(
                            children: [
                              HeadingTextWidget(
                                heading: "नियम व शर्तें / T n C",
                                fontSize: 20.0,
                                color: Colors.black,
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.open_in_new,
                                  ),
                                  onPressed: () async {
                                    const url =
                                        'https://balliakhabar.com/disclamer/';
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  }),
                            ],
                          ),
                          subtitle: ReusableTextWidgetWithPadding(
                            text: tnc,
                            color: Colors.black54,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              body: new NestedScrollView(
                  controller: _pageController,
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      new SliverAppBar(
                        backgroundColor: Colors.red[900],
                        centerTitle: true,
                        title: Text('बलिया ख़बर',
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'DancingScript',
                            )),
                        pinned: true,
                        floating: true,
                        forceElevated: innerBoxIsScrolled,
                        bottom: new TabBar(
                          labelStyle: TextStyle(fontSize: 15.0),
                          indicatorColor: Colors.white,
                          tabs: <Tab>[new Tab(text: 'क्षेत्रीय समाचार')],
                        ),
                      ),
                    ];
                  },
                  body: RefreshIndicator(
                      onRefresh: () async {
                        await Future.delayed(Duration(seconds: 3));
                        BlocProvider.of<PostsCubit>(context).loadPosts(true);
                      },
                      child: _postList())),
            )));
  }

  Widget _postList() {
    return BlocBuilder<PostsCubit, PostsState>(builder: (context, state) {
      if (state is PostsLoadingState && state.isFirstFetch) {
        return _loadingIndicator();
      }

      List<Posts> posts = [];
      bool isLoading = false;

      if (state is PostsLoadingState) {
        posts = state.oldPosts;
        isLoading = true;
      } else if (state is PostsLoadedState) {
        posts = state.posts;
        if (state.hasError) {
          Fluttertoast.showToast(
              msg: "Something went wrong. Please check your internet connection.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black54,
              textColor: Colors.white,
              fontSize: 12.0
          );
        }
      }

      if (posts.isEmpty) {
        return RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(Duration(seconds: 3));
              BlocProvider.of<PostsCubit>(context).loadPosts(true);
            },
            child: Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                children: [NewsBubble(
                  newsPara: "No internet connection",
                  heading: "",
                  imageurl: "",
                  readmore: "",
                ),]
              ),
            ),
        );
      }

      return ListView.builder(
        controller: scrollController,
        itemBuilder: (context, index) {
          if (index < posts.length)
            return NewsBubble(
              newsPara: posts[index].newsBrief,
              heading: posts[index].newsTitle,
              imageurl: posts[index].coverUrl,
              readmore: posts[index].link,
            );
          else {
            Timer(Duration(milliseconds: 30), () {
              scrollController
                  .jumpTo(scrollController.position.maxScrollExtent);
            });

            return _loadingIndicator();
          }
        },
        itemCount: posts.length + (isLoading ? 1 : 0),
      );
    });
  }
}

Widget _loadingIndicator() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Center(child: CircularProgressIndicator()),
  );
}

