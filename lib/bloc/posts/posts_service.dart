import 'dart:convert';
import 'package:http/http.dart';
import 'package:html/parser.dart';

class PostsService {
  final baseUrl = "https://balliakhabar.com/wp-json/wp/v2/posts/";

  Future<List<Posts>> fetchPosts(int page) async {
    try {
      print("fetching data");
      final response = await get(Uri.parse(baseUrl + "?per_page=10&page=$page"));
      print("resonse code : "+response.statusCode.toString());
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var list = data as List;
        List<Posts> resultList = list.map((e) => Posts.fromJson(e)).toList();

        return resultList;
      } else {
        print("resonse code eroor: "+response.statusCode.toString());
        throw Exception('Unexpected error occurred!');
      }
    } catch (err) {
      return [];
    }
  }
}

class Posts {
  final String newsBrief;
  final String newsTitle;
  final String coverUrl;
  final String link;

  Posts({this.newsBrief, this.newsTitle, this.coverUrl, this.link});

  factory Posts.fromJson(Map<String, dynamic> result) {
    return Posts(
        newsBrief: Title.fromJson(result['excerpt']).name,
        newsTitle: Title.fromJson(result['title']).name,
        coverUrl: result['jetpack_featured_media_url'],
        link: result['link']);
  }
}

class Title {
  final String name;

  Title({this.name});

  factory Title.fromJson(Map<String, dynamic> result) {
    return Title(name: _parseHtmlString(result['rendered']));
  }
}

String _parseHtmlString(String htmlString) {
  final document = parse(htmlString);
  final String parsedString = parse(document.body.text).documentElement.text;

  return parsedString;
}
